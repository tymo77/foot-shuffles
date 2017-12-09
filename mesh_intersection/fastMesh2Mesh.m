function [intersections] = fastMesh2Mesh(pointsA, pointsB, facesA, facesB, octs)
% FASTMESH2MESH: Fast mesh-mesh intersections using ray-triangle 
% intersection swolution with octree spatial partitioning.

% Putative points of intersection between each pair of surfaces are located
% by assuming that each constituent mesh triangle edge represents an
% infinitesimal ray, then solving the ray-triangle intersection problem 
% using the Barycentric coordinate based solution presented by Möller and 
% Trumbore [1997: vectorized implementation for speed]. Positive 
% intersections occur when the intersecting point, p0 lies between the end 
% nodes of its corresponding triangle edge (p1, p2), identified when the 
% following criterion is satisfied:

%                 ||p0 - p1|| + ||p0 - p2|| = ||p1 - p2||

% Note: rounding errors do not permit solving of the above criteria 
% directly. Dot and cross functions are instead used for constraining
% whether the point is between the triangle edge end nodes.

% Ray tracing becomes prohibative for meshes greater than a few thousand 
% triangles. The reliance on spatial partitioning using octree subdivision
% carries overhead in binning the two input meshes, but is still usually
% MUCH faster than a brute force search for most mesh objects.

% INPUT:
% pointsA: nx3 vertex list for mesh A
% pointsB: nx3 vertex list for mesh B
% facesA: nx3 face list of triangle corner indices for mesh A
% facesB: nx3 face list of triangle corner indices for mesh B
% oct: maximum bin size for the octree

% OUTPUT
% intersections: nx3 vertex list of intersections between the two meshes

% Author: Thomas Seers, the Univerity of Manchester, UK.

% input check
if nargin < 5 || nargin > 5
    error('two point lists, two face lists and a max bin size are required for intersection');
end

if isequal(size(pointsA,2),3)==0 || isequal(size(pointsB,2),3)==0
    error('point lists must be nx3');
end

if isequal(size(facesA,2),3)==0 || isequal(size(facesB,2),3)==0
    error('face lists must be nx3');
end


% segregate mesh objects into a single octree structure
disp('Assigning meshes to octree bins... please be patient.');
[binsA, binsB, faceBinsA,faceBinsB] = octMesh(facesA, pointsA, facesB, pointsB, octs);
disp([num2str(size(binsA,1)) ' octree bins created.']);

% solve mesh-mesh intersections for each bin
traceStore = cell(size(binsA,1),1);
for i = 1:size(binsA,1)
    disp(['Processing octree bin... ' num2str(i) ' of ' num2str(size(binsA,1))]);
    facesInA = faceBinsA{i};
    facesInB = faceBinsB{i};
    pointsInA = binsA{i};
    pointsInB = binsB{i};
    if size(binsA{i},1) < 3 ||  size(binsB{i},1) < 3 || isempty(facesInA) == 1 || isempty(facesInB) == 1
        continue
    end
    [trace] = mesh2mesh(facesInA, pointsInA, facesInB, pointsInB);
    traceStore{i} = trace;
    disp(['Octree bin... ' num2str(i) ' processed ']);
end

% sort outputs
intersections = cell2mat(traceStore);
intersections = unique(intersections, 'rows');
[B, I]  = sort(intersections(:,2));
intersections = intersections(I,:);

end

