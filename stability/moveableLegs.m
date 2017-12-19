function moveable=moveableLegs(initpos,thresh,pc,f,n)
legs=[1 2 3 4];
interstability=zeros(4,1);
for i=1:4
    interstability(i)=angularStabilityMargin(pc,initpos(setdiff(legs,i),:),f,n);
end

moveable=legs(interstability>=thresh);
end