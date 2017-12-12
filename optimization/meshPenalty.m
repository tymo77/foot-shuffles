function fval=meshPenalty(f,xy,p,vertPts1,vertPts2,vertPts3,edges,points)

xyzmesh=xyMeshIntercept(xy, vertPts1, vertPts2, vertPts3);

if numel(xyzmesh)==0
    [dist,clspt]=distanceFromEdge(xy,edges,points);
    fval=f(clspt)+dist^p;
else
    fval=f(xyzmesh(1,:));
end


end