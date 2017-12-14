function [stability,interstability,x]=shuffleFitness(points,order,initialPos,pc,f,n)

x=initialPos;
stability=zeros(length(order)+1,1);
interstability=zeros(length(order),1);

%initial stability
stability(1)=angularStabilityMargin(pc,x,f,n);

%measure intermediate stability, take step and then measure new stability
for i=1:length(order)
    
    interstability(i)=angularStabilityMargin(pc,x(setdiff([1 2 3 4],order(i)),:),f,n);
    x(order(i),:)=points(i,:);
    stability(i+1)=angularStabilityMargin(pc,x,f,n);
end
end