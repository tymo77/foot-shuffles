function [positions]=footPosForwardKinematics(thX,thY,thZ,bodyX,bodyY,bodyZ,jointAngles,wBodyInput,lenBodyInput,distalLen,proximalLen,legNo)

if (~exist('legNo', 'var'))
    N=4;
    Nstart=1;
else
    N=legNo;
    Nstart=legNo;
    temp=zeros(4,3);
    temp(legNo,:)=jointAngles;
    jointAngles=temp;
end
    
positions=zeros(N,3);
for i=Nstart:N
    th11 = jointAngles(i, 1);
    th12 = jointAngles(i, 2);
    th13 = jointAngles(i, 3);
    WBody = wBodyInput*sqrt(2)*sin(1/2*pi*(i - 1) + pi/4) ;
    LBody = lenBodyInput*sqrt(2)*cos(1/2*pi*(i - 1) + pi/4) ;
    
    positions(i,:)=...
        [...
        bodyX - (proximalLen*sin(th12) + distalLen*sin(th12 + th13))*sin(thY) + (cos(thY)*(LBody*cos(thZ) + 2*(proximalLen*cos(th12) + distalLen*cos(th12 + th13))*cos(th11 + thZ) - WBody*sin(thZ)))/2,...
        bodyY + cos(thY)*(proximalLen*sin(th12) + distalLen*sin(th12 + th13))*sin(thX) + (sin(thX)*sin(thY)*(LBody*cos(thZ) + 2*(proximalLen*cos(th12) + distalLen*cos(th12 + th13))*cos(th11 + thZ) - WBody*sin(thZ)) + cos(thX)*(WBody*cos(thZ) + LBody*sin(thZ) + 2*(proximalLen*cos(th12) + distalLen*cos(th12 + th13))*sin(th11 + thZ)))/2,...
        bodyZ - (cos(thX)*(2*cos(thY)*(proximalLen*sin(th12) + distalLen*sin(th12 + th13)) + sin(thY)*(LBody*cos(thZ) + 2*(proximalLen*cos(th12) + distalLen*cos(th12 + th13))*cos(th11 + thZ) - WBody*sin(thZ))))/2 + (sin(thX)*(WBody*cos(thZ) + LBody*sin(thZ) + 2*(proximalLen*cos(th12) + distalLen*cos(th12 + th13))*sin(th11 + thZ)))/2,...
        ];
end
end