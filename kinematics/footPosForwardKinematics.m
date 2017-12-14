function p=footPosForwardKinematics(jointAngles,legNo,robot)

thX=robot.bodyRot(1);
thY=robot.bodyRot(2);
thZ=robot.bodyRot(3);
bodyX=robot.bodyPos(1);
bodyY=robot.bodyPos(2);
bodyZ=robot.bodyPos(3);
wBodyInput=robot.bodyW;
lenBodyInput=robot.bodyL;
distalLen=robot.distLen;
proximalLen=robot.proxLen;
i=legNo;

th11 = jointAngles(1);
th12 = jointAngles(2);
th13 = jointAngles(3);
WBody = wBodyInput*sqrt(2)*sin(1/2*pi*(i - 1) + pi/4) ;
LBody = lenBodyInput*sqrt(2)*cos(1/2*pi*(i - 1) + pi/4) ;

p=...
    [...
    bodyX - (proximalLen*sin(th12) + distalLen*sin(th12 + th13))*sin(thY) + (cos(thY)*(LBody*cos(thZ) + 2*(proximalLen*cos(th12) + distalLen*cos(th12 + th13))*cos(th11 + thZ) - WBody*sin(thZ)))/2,...
    bodyY + cos(thY)*(proximalLen*sin(th12) + distalLen*sin(th12 + th13))*sin(thX) + (sin(thX)*sin(thY)*(LBody*cos(thZ) + 2*(proximalLen*cos(th12) + distalLen*cos(th12 + th13))*cos(th11 + thZ) - WBody*sin(thZ)) + cos(thX)*(WBody*cos(thZ) + LBody*sin(thZ) + 2*(proximalLen*cos(th12) + distalLen*cos(th12 + th13))*sin(th11 + thZ)))/2,...
    bodyZ - (cos(thX)*(2*cos(thY)*(proximalLen*sin(th12) + distalLen*sin(th12 + th13)) + sin(thY)*(LBody*cos(thZ) + 2*(proximalLen*cos(th12) + distalLen*cos(th12 + th13))*cos(th11 + thZ) - WBody*sin(thZ))))/2 + (sin(thX)*(WBody*cos(thZ) + LBody*sin(thZ) + 2*(proximalLen*cos(th12) + distalLen*cos(th12 + th13))*sin(th11 + thZ)))/2,...
    ];

end