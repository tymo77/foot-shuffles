function init = randomInit(thresh,robot,regions)

steps=0;
while steps<1000
    steps=steps+1;
    
    %pick random points
    x=[...
        randomPoint(regions(1).mesh);...
        randomPoint(regions(2).mesh);...
        randomPoint(regions(3).mesh);...
        randomPoint(regions(4).mesh)];
    %check distance
    dist=minLegDistFromPos(x,robot);
    if dist>thresh
        break
    end
end
init=x;
end