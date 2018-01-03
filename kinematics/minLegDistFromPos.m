function d=minLegDistFromPos(x,robot)

sols=zeros(4,3);
jointPos=zeros(4,3,4);

for i=1:4
    sols(i,:)=kneeUpInvKin(x(i,1),x(i,2),x(i,3),i,robot);
    jointPos(:,:,i)=jointPositions(sols(i,:),i,robot);
end

leg1joints=jointPos(2:4,:,1);
leg2joints=jointPos(2:4,:,2);
leg3joints=jointPos(2:4,:,3);
leg4joints=jointPos(2:4,:,4);

d=nearestLegPair(leg1joints,leg2joints,leg3joints,leg4joints);
end