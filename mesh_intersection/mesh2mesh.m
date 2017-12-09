function [trace] = mesh2mesh(facesInA, pointsInA, facesInB, pointsInB)
% Find intersection line between mesh A and mesh B using ray-triangle 
% intersection solution of Moller and Trumbore (1997). Positive 
% intersections occur when the intersecting point, p0 lies between the end 
% nodes of its corresponding triangle edge (p1, p2), identified when the 
% following criterion is satisfied:

%                 ?p0 - p1? + ?p0 - p2? = ?p1 - p2?

% Note: rounding errors do not permit solving of the above criteria 
% directly. Dot and cross functions are instead used for constaining
% whether the point is between the triangle edge end nodes.

% INPUT:
% pointsInA: nx3 vertex list for mesh A
% pointsInB: nx3 vertex list for mesh B
% facesInA: nx3 face list of triangle corner indices for mesh A
% facesInB: nx3 face list of triangle corner indices for mesh B

% OUTPUT
% trace: nx3 vertex list of intersections between the two meshes

% Author: Thomas Seers, the Univerity of Manchester, UK.


%%
% build triangles, rays and origins
tri_target  = [pointsInA(facesInA(:,1),:) pointsInA(facesInA(:,2),:) pointsInA(facesInA(:,3),:)];
tri_source = [pointsInB(facesInB(:,1),:) pointsInB(facesInB(:,2),:) pointsInB(facesInB(:,3),:)]; % we will project the triangle segments from the topo surface onto the fracture surface

% visualise
% for i = 1:size(tri_target,1); plot3([tri_target(i,1) tri_target(i,4) tri_target(i,7)],[tri_target(i,2) tri_target(i,5) tri_target(i,8)],[tri_target(i,3) tri_target(i,6) tri_target(i,9)],'k'); hold on; end; axis equal;
% hold on
% for i = 1:size(tri_source,1); plot3([tri_source(i,1) tri_source(i,4) tri_source(i,7)],[tri_source(i,2) tri_source(i,5) tri_source(i,8)],[tri_source(i,3) tri_source(i,6) tri_source(i,9)],'k'); hold on; end; axis equal;

% create 2 rays for each triangle edge segment (one for each sign). Use the
% first vertex as the origin

% get edge segments
tri_pair1 = zeros(size(tri_source,1),6);
tri_pair2 = zeros(size(tri_source,1),6); 
tri_pair3 = zeros(size(tri_source,1),6);
tri_pair1(:,1:3) = tri_source(:,1:3);
tri_pair1(:,4:6) = tri_source(:,4:6);
tri_pair2(:,1:3) = tri_source(:,7:9);
tri_pair2(:,4:6) = tri_source(:,1:3);
tri_pair3(:,1:3) = tri_source(:,4:6);
tri_pair3(:,4:6) = tri_source(:,7:9);

% get origins
or1 = tri_pair1(:,1:3);
or2 = tri_pair2(:,1:3);
or3 = tri_pair3(:,1:3);

% translate each pair to origin and normalise (ray tree)
rays1 = [tri_pair1(:,1:3)-tri_pair1(:,1:3) tri_pair1(:,4:6)-tri_pair1(:,1:3)];
rays2 = [tri_pair2(:,1:3)-tri_pair2(:,1:3) tri_pair2(:,4:6)-tri_pair2(:,1:3)];
rays3 = [tri_pair3(:,1:3)-tri_pair3(:,1:3) tri_pair3(:,4:6)-tri_pair3(:,1:3)];
rays1 = rays1(:,1:3)+rays1(:,4:6);
rays2 = rays2(:,1:3)+rays2(:,4:6);
rays3 = rays3(:,1:3)+rays3(:,4:6);
for i = 1:size(rays1,1)
    rays1(i,:) =  rays1(i,:)/norm(rays1(i,:));
    if sign(rays1(i,3)) == -1;
        rays1(i,:) = -rays1(i,:);
    end
    rays2(i,:) =  rays2(i,:)/norm(rays2(i,:));
    if sign(rays2(i,3)) == -1;
        rays2(i,:) = -rays2(i,:);
    end
    rays3(i,:) =  rays3(i,:)/norm(rays3(i,:));
    if sign(rays3(i,3)) == -1;
        rays3(i,:) = -rays3(i,:);
    end
end

% correct


% setup target mesh vertices
P0 = tri_target(:,1:3);
P1 = tri_target(:,4:6);
P2 = tri_target(:,7:9);


% replicate origin and each ray sign to size(P0,1)
repRay1 = repmat(rays1,size(P0,1),1);
or1Rep = repmat(or1,size(P0,1),1);
repRay2 = repmat(rays2,size(P0,1),1);
or2Rep = repmat(or2,size(P0,1),1);
repRay3 = repmat(rays3,size(P0,1),1);
or3Rep = repmat(or3,size(P0,1),1);

% indexes for rays
IDs = transpose(1:size(rays1,1));
ID_triRay = repmat(IDs,size(P0,1),1);

if size(or1,1) > 1
    
    % replicate P0, P1, P2 to size(or,1)
    P0cell = cell(size(or1,1),1);
    P1cell = cell(size(or1,1),1);
    P2cell = cell(size(or1,1),1);
    
    for i = 1:size(P0,1)
        P0cell{i} = repmat(P0(i,:),size(or1,1),1);
        P1cell{i} = repmat(P1(i,:),size(or1,1),1);
        P2cell{i} = repmat(P2(i,:),size(or1,1),1);
    end
    
    P0 = cell2mat(P0cell);
    P1 = cell2mat(P1cell);
    P2 = cell2mat(P2cell);
end

tol = 0.0000001;
% find intersections for edge 1
or = or1Rep;
D = repRay1;

[dist_out,IDs_out] = rayTri(P0, P1, P2, or, D, ID_triRay);
orOut = or1(IDs_out,:);
raysOut = rays1(IDs_out,:);

P = orOut+repmat(dist_out,1,3).*raysOut;
v1 = tri_pair1(IDs_out,1:3);
v2 = tri_pair1(IDs_out,4:6);
logi = (norm(cross(P-v1,v2-v1,2)) < tol) & ...
    (dot(P-v1,v2-v1,2) >= 0) & (dot(P-v2,v2-v1,2) <= 0);
hitsOut1 = P(logical(logi),:);

% find intersections for edge 2
or = or2Rep;
D = repRay2;

[dist_out,IDs_out] = rayTri(P0, P1, P2, or, D, ID_triRay);
orOut = or2(IDs_out,:);
raysOut = rays2(IDs_out,:);

P = orOut+repmat(dist_out,1,3).*raysOut;
v1 = tri_pair2(IDs_out,1:3);
v2 = tri_pair2(IDs_out,4:6);
logi = (norm(cross(P-v1,v2-v1,2)) < tol) & ...
    (dot(P-v1,v2-v1,2) >= 0) & (dot(P-v2,v2-v1,2) <= 0);
hitsOut2 = P(logical(logi),:);

% find intersections for edge 3
or = or3Rep;
D = repRay3;

[dist_out,IDs_out] = rayTri(P0, P1, P2, or, D, ID_triRay);
orOut = or3(IDs_out,:);
raysOut = rays3(IDs_out,:);

P = orOut+repmat(dist_out,1,3).*raysOut;
v1 = tri_pair3(IDs_out,1:3);
v2 = tri_pair3(IDs_out,4:6);
logi = (norm(cross(P-v1,v2-v1,2)) < tol) & ...
    (dot(P-v1,v2-v1,2) >= 0) & (dot(P-v2,v2-v1,2) <= 0);
hitsOut3 = P(logical(logi),:);

% traceT = unique(vertcat(hitsOut1,hitsOut2,hitsOut3),'rows'); 
traceT = vertcat(hitsOut1,hitsOut2,hitsOut3); 

% create 2 rays for each triangle edge segment (one for each sign). Use the
% first vertex as the origin

%% test second mesh

% get edge segments
tri_pair1 = zeros(size(tri_target,1),6);
tri_pair2 = zeros(size(tri_target,1),6); 
tri_pair3 = zeros(size(tri_target,1),6);
tri_pair1(:,1:3) = tri_target(:,1:3);
tri_pair1(:,4:6) = tri_target(:,4:6);
tri_pair2(:,1:3) = tri_target(:,7:9);
tri_pair2(:,4:6) = tri_target(:,1:3);
tri_pair3(:,1:3) = tri_target(:,4:6);
tri_pair3(:,4:6) = tri_target(:,7:9);

% get origins
or1 = tri_pair1(:,1:3);
or2 = tri_pair2(:,1:3);
or3 = tri_pair3(:,1:3);

% translate each pair to origin and normalise (ray tree)
rays1 = [tri_pair1(:,1:3)-tri_pair1(:,1:3) tri_pair1(:,4:6)-tri_pair1(:,1:3)];
rays2 = [tri_pair2(:,1:3)-tri_pair2(:,1:3) tri_pair2(:,4:6)-tri_pair2(:,1:3)];
rays3 = [tri_pair3(:,1:3)-tri_pair3(:,1:3) tri_pair3(:,4:6)-tri_pair3(:,1:3)];
rays1 = rays1(:,1:3)+rays1(:,4:6);
rays2 = rays2(:,1:3)+rays2(:,4:6);
rays3 = rays3(:,1:3)+rays3(:,4:6);
for i = 1:size(rays1,1)
    rays1(i,:) =  rays1(i,:)/norm(rays1(i,:));
    if sign(rays1(i,3)) == -1;
        rays1(i,:) = -rays1(i,:);
    end
    rays2(i,:) =  rays2(i,:)/norm(rays2(i,:));
    if sign(rays2(i,3)) == -1;
        rays2(i,:) = -rays2(i,:);
    end
    rays3(i,:) =  rays3(i,:)/norm(rays3(i,:));
    if sign(rays3(i,3)) == -1;
        rays3(i,:) = -rays3(i,:);
    end
end

% correct


% setup target mesh vertices
P0 = tri_source(:,1:3);
P1 = tri_source(:,4:6);
P2 = tri_source(:,7:9);


% replicate origin and each ray sign to size(P0,1)
repRay1 = repmat(rays1,size(P0,1),1);
or1Rep = repmat(or1,size(P0,1),1);
repRay2 = repmat(rays2,size(P0,1),1);
or2Rep = repmat(or2,size(P0,1),1);
repRay3 = repmat(rays3,size(P0,1),1);
or3Rep = repmat(or3,size(P0,1),1);

% indexes for rays
IDs = transpose(1:size(rays1,1));
ID_triRay = repmat(IDs,size(P0,1),1);

if size(or1,1) > 1
    
% replicate P0, P1, P2 to size(or,1)
P0cell = cell(size(or1,1),1);
P1cell = cell(size(or1,1),1);
P2cell = cell(size(or1,1),1);

for i = 1:size(P0,1)
    P0cell{i} = repmat(P0(i,:),size(or1,1),1);
    P1cell{i} = repmat(P1(i,:),size(or1,1),1);
    P2cell{i} = repmat(P2(i,:),size(or1,1),1);
end

P0 = cell2mat(P0cell);
P1 = cell2mat(P1cell);
P2 = cell2mat(P2cell);
end

% find intersections for edge 1
or = or1Rep;
D = repRay1;

[dist_out,IDs_out] = rayTri(P0, P1, P2, or, D, ID_triRay);
orOut = or1(IDs_out,:);
raysOut = rays1(IDs_out,:);

P = orOut+repmat(dist_out,1,3).*raysOut;
v1 = tri_pair1(IDs_out,1:3);
v2 = tri_pair1(IDs_out,4:6);
logi = (norm(cross(P-v1,v2-v1,2)) < tol) & ...
    (dot(P-v1,v2-v1,2) >= 0) & (dot(P-v2,v2-v1,2) <= 0);
hitsOut1 = P(logical(logi),:);

% find intersections for edge 2
or = or2Rep;
D = repRay2;

[dist_out,IDs_out] = rayTri(P0, P1, P2, or, D, ID_triRay);
orOut = or2(IDs_out,:);
raysOut = rays2(IDs_out,:);

P = orOut+repmat(dist_out,1,3).*raysOut;
v1 = tri_pair2(IDs_out,1:3);
v2 = tri_pair2(IDs_out,4:6);
logi = (norm(cross(P-v1,v2-v1,2)) < tol) & ...
    (dot(P-v1,v2-v1,2) >= 0) & (dot(P-v2,v2-v1,2) <= 0);
hitsOut2 = P(logical(logi),:);

% find intersections for edge 3
or = or3Rep;
D = repRay3;

[dist_out,IDs_out] = rayTri(P0, P1, P2, or, D, ID_triRay);
orOut = or3(IDs_out,:);
raysOut = rays3(IDs_out,:);

P = orOut+repmat(dist_out,1,3).*raysOut;
v1 = tri_pair3(IDs_out,1:3);
v2 = tri_pair3(IDs_out,4:6);
logi = (norm(cross(P-v1,v2-v1,2)) < tol) & ...
    (dot(P-v1,v2-v1,2) >= 0) & (dot(P-v2,v2-v1,2) <= 0);
hitsOut3 = P(logical(logi),:);

% traceF = unique(vertcat(hitsOut1,hitsOut2,hitsOut3),'rows'); 
traceF = vertcat(hitsOut1,hitsOut2,hitsOut3); 

%%
% concatenate the outputs and sort along the y axis
trace = vertcat(traceT,traceF);
[B, I]  = sort(trace(:,2));
trace = trace(I,:);


end

