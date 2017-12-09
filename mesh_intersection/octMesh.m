function [binsA, binsB, faceBinsA,faceBinsB] = octMesh(facesA, pointsA, facesB, pointsB, octs)
% OCTMESH: Split two triangular meshes into a single system of octree
% spatial bins

% Only bins with both meshes present are retained (to be searched for mesh
% mesh intersections.

% INPUT:
% pointsA: nx3 vertex list for mesh A
% pointsB: nx3 vertex list for mesh B
% facesB: nx3 face list of triangle corner indices for mesh A
% facesB: nx3 face list of triangle corner indices for mesh B
% oct: maximum bin size for the octree

% OUTPUT:
% binsA: nx1 cell containing binned vertex lists for mesh A
% binsB: nx1 cell containing binned vertex lists for mesh B

% Author: Thomas Seers, the Univerity of Manchester, UK.

% max bins
idsA = transpose(1:size(pointsA, 1));
idsB = transpose(1:size(pointsB, 1));

% % size of each point list
sizeA = size(pointsA, 1);

% stack points 
points_stack = vertcat(pointsA, pointsB);

% Build octree
OT = OcTree(points_stack, 'binCapacity', octs);

% split point IDs
binIdsA = OT.PointBins(1:sizeA);
binIdsB = OT.PointBins(sizeA+1:end);

% binIds = OT.PointBins;
% assign points to bins then collapse
binsA = cell(OT.BinCount,1);
binsB = cell(OT.BinCount,1);
indA = cell(OT.BinCount,1);
indB = cell(OT.BinCount,1);
logi = zeros(max(OT.PointBins),1);
for i = 1:size(binsA,1)
    binsA{i} = pointsA(binIdsA==i,:);
    binsB{i} = pointsB(binIdsB==i,:);
    indA{i} = idsA(binIdsA==i,:);
    indB{i} = idsB(binIdsB==i,:);
    if  size(binsA{i},1) > 0 && size(binsB{i},1) > 0
        logi(i) = 1;
    end
end

% Collapse empty bins
binsA = binsA(logical(logi));
binsB = binsB(logical(logi));
indA = indA(logical(logi));
indB = indB(logical(logi));

% split f mesh into octree bins
faceBinsA = cell(size(binsA,1),1);
newIDBinsA = cell(size(binsA,1),1);
sizeFaceA = size(facesA,1);
faceAstack = vertcat(facesA(:,1), facesA(:,2), facesA(:,3));
for i=1:size(binsA,1)
    logi = ismember(faceAstack, indA{i});
    logicut = logi(1:sizeFaceA) + logi(sizeFaceA+1:sizeFaceA*2) + logi((sizeFaceA*2)+1:end);
    logicut(logicut > 0)=1;
    faceBinsA{i} = facesA(logical(logicut),:);
    % find missing points from the binned triangles
    inpoints = unique(faceBinsA{i});
    inpoints(ismember(inpoints, indA{i})) = [];
    binsA{i} = vertcat(binsA{i}, pointsA(inpoints,:));
    indA{i} = vertcat(indA{i}, idsA(inpoints,:));
    newIDBinsA{i} = transpose(1:size(indA{i},1));
    sizeFaceAbin = size(faceBinsA{i},1);
    faceBinAstack = vertcat(faceBinsA{i}(:,1), faceBinsA{i}(:,2), faceBinsA{i}(:,3));
    tempInds = arrayfun(@(x) find(indA{i} == x,1,'first'), faceBinAstack);
    faceBinAstack = newIDBinsA{i}(tempInds);
    faceBinsA{i} = [faceBinAstack(1:sizeFaceAbin)  faceBinAstack(sizeFaceAbin+1:sizeFaceAbin*2)  faceBinAstack((sizeFaceAbin*2)+1:end)];
end

% split t mesh into octree bins
faceBinsB = cell(size(binsB,1),1);
newIDBinsB = cell(size(binsB,1),1);
sizeFaceB = size(facesB,1);
faceBstack = vertcat(facesB(:,1), facesB(:,2), facesB(:,3));
for i=1:size(binsB,1)
    logi = ismember(faceBstack, indB{i});
    logicut = logi(1:sizeFaceB) + logi(sizeFaceB+1:sizeFaceB*2) + logi((sizeFaceB*2)+1:end);
    logicut(logicut > 0)=1;
    faceBinsB{i} = facesB(logical(logicut),:);
    % find missing points from the binned triangles
    inpoints = unique(faceBinsB{i});
    inpoints(ismember(inpoints, indB{i})) = [];
    binsB{i} = vertcat(binsB{i}, pointsB(inpoints,:));
    indB{i} = vertcat(indB{i}, idsB(inpoints,:));
    newIDBinsB{i} = transpose(1:size(indB{i},1));
    sizeFaceBbin = size(faceBinsB{i},1);
    faceBinBstack = vertcat(faceBinsB{i}(:,1), faceBinsB{i}(:,2), faceBinsB{i}(:,3));
    tempInds = arrayfun(@(x) find(indB{i} == x,1,'first'), faceBinBstack);
    faceBinBstack = newIDBinsB{i}(tempInds);
    faceBinsB{i} = [faceBinBstack(1:sizeFaceBbin)  faceBinBstack(sizeFaceBbin+1:sizeFaceBbin*2)  faceBinBstack((sizeFaceBbin*2)+1:end)];
end

end

