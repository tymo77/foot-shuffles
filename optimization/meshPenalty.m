function fval=meshPenalty(f,xy,p,order,regions)
Nregions=length(order);

if Nregions ~= size(xy,1)
    error('no. of mesh regions passed does not match no. of points');
end
xyzmesh=zeros(Nregions,3);
dists=zeros(Nregions,1);

for i=1:Nregions
    xyzint=xyMeshIntercept(xy(i,:), regions(order(i)).mesh.vertPt1,...
        regions(order(i)).mesh.vertPt2, regions(order(i)).mesh.vertPt3);
    
    if numel(xyzint)==0
        [dists(i),xyzmesh(i,:)]=distanceFromEdge(xy(i,:),...
            regions(order(i)).mesh.extEdges,regions(order(i)).mesh.points);
    else
        xyzmesh(i,:)=xyzint;
    end
    

end

fval=sum(sum(f(xyzmesh)+dists.^p));

end