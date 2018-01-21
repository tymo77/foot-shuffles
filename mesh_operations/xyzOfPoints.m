function [xyzPts]=xyzOfPoints(order,xyPts,regions)

N=size(xyPts,1);
xyzPts=zeros(N,3);
for i=1:N
    int=xyMeshIntercept(xyPts(i,:),regions(order(i)).mesh.vertPt1,...
        regions(order(i)).mesh.vertPt2,regions(order(i)).mesh.vertPt3);
    if isempty(int)
        [~,int]=distanceFromEdge(xyPts(i,:),regions(order(i)).mesh.extEdges,...
            regions(order(i)).mesh.points);
    end
    xyzPts(i,:)=int;
end
end
