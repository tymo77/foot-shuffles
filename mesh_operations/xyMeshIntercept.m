function xyz=xyMeshIntercept(p, vertPts1, vertPts2, vertPts3)
N=size(vertPts1,1);
dir=repmat([0 0 1],N,1);%vertical line;
origin=repmat([p 0],N,1);%make 2dpt 3d;


[intercepts, ~, ~, ~, coord] = TriangleRayIntersection(origin, dir, vertPts1,...
    vertPts2, vertPts3,'lineType','line');
xyz=coord(intercepts,:);
end