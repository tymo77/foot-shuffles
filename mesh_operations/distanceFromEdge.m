function [dist,closept]=distanceFromEdge(xypt,extEdges,points)
N=size(extEdges,1);
dists=zeros(N,1);
closepts=zeros(N,3);

p1=[xypt -10^5];
p2=[xypt 10^5];


for i=1:N
    p3=points(extEdges(i,1),:);
    p4=points(extEdges(i,2),:);
    [dists(i), closepts(i,:)]=DistBetween2Segment(p1,p2,p3,p4);
end
[dist, imin]=min(dists);
closept=closepts(imin,:);

end
