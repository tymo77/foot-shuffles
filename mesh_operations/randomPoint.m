function xyzRand=randomPoint(mesh)

points=mesh.points(mesh.allindices,1:2);
xbounds=[min(points(:,1)),max(points(:,1))];
ybounds=[min(points(:,2)),max(points(:,2))];

steps=0;
while true
    randPt=[rand()*(xbounds(2)-xbounds(1))+xbounds(1),rand()*(ybounds(2)-ybounds(1))+ybounds(1)];
    xyzRand=xyMeshIntercept(randPt, mesh.vertPt1, mesh.vertPt2, mesh.vertPt3);
    if ~isempty(xyzRand)
        break
    end
    if steps>1000
        
        xyzRand=double.empty(0,3);
        break
    end
    steps=steps+1;
end
end