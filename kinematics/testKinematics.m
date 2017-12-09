testAngles=(rand(100,3)-.5)*pi;
%testAngles=[0,0,0;0,0,0];
distalLen=1;
proximalLen=1;
bodyPos=[0,0,0];
bodyRot=[0,0,0];
bodyW=1;
bodyL=1;

clear diff1 diff2 invkin1 invkin2


for i=1:size(testAngles,1)
    forwardKin(i,:)=footPosForwardKinematics(bodyRot(1),bodyRot(2),...
        bodyRot(3),bodyPos(1),bodyPos(2),bodyPos(3),...
        testAngles(i,:),bodyW,bodyL,distalLen,proximalLen,1);
    
    px=forwardKin(i,1)-bodyPos(1);py=forwardKin(i,2)-bodyPos(2);pz=forwardKin(i,3)-bodyPos(3);
    
    invkin=computeInverseKinematics(px,py,pz,bodyW,bodyL,proximalLen,distalLen,1);
    
    invkin1(i,:)=invkin(1,:);
    invkin2(i,:)=invkin(2,:);
    diff1(i,:)=testAngles(i,:)-invkin1(i,:);
    diff2(i,:)=testAngles(i,:)-invkin2(i,:);
end

[diff1 diff2]
    