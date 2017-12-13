function d=nearestLegPair(leg1joints,leg2joints,leg3joints,leg4joints)
joints(:,:,1)=leg1joints;
joints(:,:,2)=leg2joints;
joints(:,:,3)=leg3joints;
joints(:,:,4)=leg4joints;

legcompare=[...
1 2;
1 3;
1 4;
2 3;
2 4;
3 4];

linkcompare=[1 1;1 2;2 1;2 2];

jointsoflink=[1 2;2 3];

dist=zeros(1,24);

i=1;
for legpair=legcompare'
    for linkpair=linkcompare'
        link1=joints(jointsoflink(linkpair(1),:),:,legpair(1));
        link2=joints(jointsoflink(linkpair(2),:),:,legpair(2));
        dist(i)=DistBetween2Segment(link1(1,:),link1(2,:),link2(1,:),link2(2,:));
        i=i+1;
    end
end

d=min(dist);
end
        