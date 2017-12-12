function [vstar,mindist]=closestVertex(p,vertices,points)

verticeslist=reshape(vertices,numel(vertices),1);
%relative vector in x-y plane
rel=points(verticeslist,[1 2])-p;

%
dist=vecnorm(rel,2);
[mindist,imin]=min(dist);
vstar=verticeslist(imin,:);


end