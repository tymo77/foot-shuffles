function [C, Ceq]=minStabAndLegDistConst(threshStab,threshLegDist,...
    points,order,initialPos,pc,f,n,regions,robot)

x=initialPos;
stability=zeros(length(order),1);
interstability=zeros(length(order),1);
minDists=zeros(length(order),1);


%measure intermediate stability, take step and then measure new stability

for i=1:length(order)
    
    interstability(i)=angularStabilityMargin(pc,x(setdiff([1 2 3 4],order(i)),:),f,n);
    x(order(i),:)=nearestSurfPoint(points(i,:),regions(order(i)).mesh);
    stability(i)=angularStabilityMargin(pc,x,f,n);
    minDists(i)=minLegDistFromPos(x,robot);
end

minstab=(min([min(stability),min(interstability)]));

minLegDist=min(minDists);


C=[threshStab-minstab,threshLegDist-minLegDist];
Ceq=[];

end

function xyzmesh=nearestSurfPoint(pt,mesh)
xyMeshIntercept(pt,mesh.vertPt1, mesh.vertPt2, mesh.vertPt3);
xyzint=xyMeshIntercept(pt,mesh.vertPt1, mesh.vertPt2, mesh.vertPt3);
if numel(xyzint)==0
    [~,xyzmesh]=distanceFromEdge(pt,mesh.extEdges,mesh.points);
else
    xyzmesh=xyzint;
end

end