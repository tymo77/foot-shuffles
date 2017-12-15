function points=removeDuplicatePoints(points,tol)


i=1;
while i<size(points,1)
    searched=points(1:i,:);
    remaining=points(i+1:end,:);
    
    
    
    remaining=remaining((vecnorm((remaining-points(i,:))')')>tol,:);
    points=[searched; remaining];
    i=i+1;
end
end