%% Initialize
loadSubDirectories();
close all

distalLen=1;
proximalLen=1;
bodyPos=[0,0,0];
bodyRot=[0,0,0];
bodyW=1;
bodyL=1;

robot=struct();
robot.distLen=distalLen;
robot.proxLen=proximalLen;
robot.bodyPos=[0,0,0];
robot.bodyRot=[0,0,0];
robot.bodyW=1;
robot.bodyL=1;
%% Workspace point cloud
N=12;
deg70=deg2rad(70);
th1=linspace(-deg70,deg70,N);
th2=th1;
th3=th1;
[x,y,z]=generatePointCloud(N,th1,th2,th3,1,robot);
scatter3(x,y,z)
axis equal

workspacePts=[x y z];
tri = delaunay(x,y,z);
trisurf(tri,x,y,z);
workspaceFaces=meshFaces(tri);
axis equal

%% intersection

Nsurf=8;
%box in shadow of workspace
xbnds=[min(workspacePts(:,1)),max(workspacePts(:,1))];
ybnds=[min(workspacePts(:,2)),max(workspacePts(:,2))];

surfPts=generateSurfacePoints(Nsurf,xbnds,ybnds,'wave');
sx=surfPts(:,1);sy=surfPts(:,2);sz=surfPts(:,3);
triSurf=delaunay(sx,sy);

intPts=mesh2mesh(workspaceFaces,workspacePts,triSurf,surfPts);

scatter3(intPts(:,1),intPts(:,2),intPts(:,3))
hold on
scatter3(x,y,z,'r')
axis equal


interSectTri=delaunay(intPts(:,1),intPts(:,2));
figure
hold on
scatter3(intPts(:,1),intPts(:,2),intPts(:,3))
axis equal
%% filter intersection
filterPts=filterPtsByInvKin(intPts-robot.bodyPos,-deg70,deg70,1,robot);
filterTri=delaunay(filterPts(:,1),filterPts(:,2));

figure
trisurf(filterTri,filterPts(:,1),filterPts(:,2),filterPts(:,3))
axis equal

filterTri=filterTriByCentroid(filterTri,filterPts-robot.bodyPos,-deg70,deg70,1,robot);

filterTri=removeDuplicateFaces(filterTri);

figure
trisurf(filterTri,filterPts(:,1),filterPts(:,2),filterPts(:,3))
axis equal

%% remove bad cells
filterTri=improveMesh(filterTri,filterPts);
figure
trisurf(filterTri,filterPts(:,1),filterPts(:,2),filterPts(:,3))
axis equal

vertPt1List=filterPts(filterTri(:,1),:);
vertPt2List=filterPts(filterTri(:,2),:);
vertPt3List=filterPts(filterTri(:,3),:);
extEdges=getExternalEdges(filterTri);

allindices=reshape(filterTri,numel(filterTri),1);%list all indices in one line
allindices=unique(allindices);%get all unique indices in use

leg1Mesh=struct();
leg1Mesh.vertPt1=vertPt1List;
leg1Mesh.vertPt2=vertPt2List;
leg1Mesh.vertPt3=vertPt3List;
leg1Mesh.extEdges=int32(extEdges);
leg1Mesh.points=filterPts;
leg1Mesh.tri=int32(filterTri);
leg1Mesh.allindices=int32(allindices);
