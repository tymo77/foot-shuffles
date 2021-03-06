function output=allJointTransformMatrices(jointAngles,robot)
output = zeros(4,4,5,4);
%{
    Simply defines the transformation matrices for each leg.
	The solution matrix is obtained from a separate file in the parent directory
%}

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

for i=1:4
    %{
    collecting joint angles from the array,
    and compensating for the differences in the transformations of each leg relative to the body center
    %}
    
    th11 = jointAngles(i, 1);
    th12 = jointAngles(i, 2);
    th13 = jointAngles(i, 3);
    WBody = wBodyInput*sqrt(2)*sin(1/2*pi*(i - 1) + pi/4) ;
    LBody = lenBodyInput*sqrt(2)*cos(1/2*pi*(i - 1) + pi/4) ;
    
    
    particularSolMatrix(:,:,1)=...
        [cos(thY)*cos(thZ), -(cos(thY)*sin(thZ)), sin(thY), bodyX;...
        cos(thZ)*sin(thX)*sin(thY) + cos(thX)*sin(thZ), cos(thX)*cos(thZ) - sin(thX)*sin(thY)*sin(thZ), -(cos(thY)*sin(thX)), bodyY;...
        -(cos(thX)*cos(thZ)*sin(thY)) + sin(thX)*sin(thZ), cos(thZ)*sin(thX) + cos(thX)*sin(thY)*sin(thZ), cos(thX)*cos(thY), bodyZ;...
        0, 0, 0, 1];
    particularSolMatrix(:,:,2)=...
        [cos(thY)*cos(thZ), -(cos(thY)*sin(thZ)), sin(thY), bodyX + (cos(thY)*(LBody*cos(thZ) - WBody*sin(thZ)))/2;...
        cos(thZ)*sin(thX)*sin(thY) + cos(thX)*sin(thZ), cos(thX)*cos(thZ) - sin(thX)*sin(thY)*sin(thZ), -(cos(thY)*sin(thX)), (2*bodyY + cos(thX)*(WBody*cos(thZ) + LBody*sin(thZ)) + sin(thX)*sin(thY)*(LBody*cos(thZ) - WBody*sin(thZ)))/2;...
        -(cos(thX)*cos(thZ)*sin(thY)) + sin(thX)*sin(thZ), cos(thZ)*sin(thX) + cos(thX)*sin(thY)*sin(thZ), cos(thX)*cos(thY), (2*bodyZ + sin(thX)*(WBody*cos(thZ) + LBody*sin(thZ)) + cos(thX)*sin(thY)*(-(LBody*cos(thZ)) + WBody*sin(thZ)))/2;...
        0, 0, 0, 1];
    particularSolMatrix(:,:,3)=...
        [cos(thY)*cos(th11 + thZ), -sin(thY), -(cos(thY)*sin(th11 + thZ)), bodyX + (cos(thY)*(LBody*cos(thZ) - WBody*sin(thZ)))/2;...
        cos(th11 + thZ)*sin(thX)*sin(thY) + cos(thX)*sin(th11 + thZ), cos(thY)*sin(thX), cos(thX)*cos(th11 + thZ) - sin(thX)*sin(thY)*sin(th11 + thZ), (2*bodyY + cos(thX)*(WBody*cos(thZ) + LBody*sin(thZ)) + sin(thX)*sin(thY)*(LBody*cos(thZ) - WBody*sin(thZ)))/2;...
        -(cos(thX)*cos(th11 + thZ)*sin(thY)) + sin(thX)*sin(th11 + thZ), -(cos(thX)*cos(thY)), cos(th11 + thZ)*sin(thX) + cos(thX)*sin(thY)*sin(th11 + thZ), (2*bodyZ + sin(thX)*(WBody*cos(thZ) + LBody*sin(thZ)) + cos(thX)*sin(thY)*(-(LBody*cos(thZ)) + WBody*sin(thZ)))/2;...
        0, 0, 0, 1];
    particularSolMatrix(:,:,4)=...
        [cos(th12)*cos(thY)*cos(th11 + thZ) - sin(th12)*sin(thY), -(cos(thY)*cos(th11 + thZ)*sin(th12)) - cos(th12)*sin(thY), -(cos(thY)*sin(th11 + thZ)), bodyX - proximalLen*sin(th12)*sin(thY) + (cos(thY)*(LBody*cos(thZ) + 2*proximalLen*cos(th12)*cos(th11 + thZ) - WBody*sin(thZ)))/2;...
        cos(thY)*sin(th12)*sin(thX) + cos(th12)*(cos(th11 + thZ)*sin(thX)*sin(thY) + cos(thX)*sin(th11 + thZ)), cos(th12)*cos(thY)*sin(thX) - sin(th12)*(cos(th11 + thZ)*sin(thX)*sin(thY) + cos(thX)*sin(th11 + thZ)), cos(thX)*cos(th11 + thZ) - sin(thX)*sin(thY)*sin(th11 + thZ), bodyY + proximalLen*cos(thY)*sin(th12)*sin(thX) + (sin(thX)*sin(thY)*(LBody*cos(thZ) + 2*proximalLen*cos(th12)*cos(th11 + thZ) - WBody*sin(thZ)) + cos(thX)*(WBody*cos(thZ) + LBody*sin(thZ) + 2*proximalLen*cos(th12)*sin(th11 + thZ)))/2;...
        -(cos(thX)*(cos(thY)*sin(th12) + cos(th12)*cos(th11 + thZ)*sin(thY))) + cos(th12)*sin(thX)*sin(th11 + thZ),-(cos(th12)*cos(thX)*cos(thY)) + sin(th12)*(cos(thX)*cos(th11 + thZ)*sin(thY) - sin(thX)*sin(th11 + thZ)), cos(th11 + thZ)*sin(thX) + cos(thX)*sin(thY)*sin(th11 + thZ), (2*bodyZ - cos(thX)*(2*proximalLen*cos(thY)*sin(th12) + sin(thY)*(LBody*cos(thZ) + 2*proximalLen*cos(th12)*cos(th11 + thZ) - WBody*sin(thZ))) + sin(thX)*(WBody*cos(thZ) + LBody*sin(thZ) + 2*proximalLen*cos(th12)*sin(th11 + thZ)))/2;...
        0, 0, 0, 1];
    particularSolMatrix(:,:,5)=...
        [cos(th12 + th13)*cos(thY)*cos(th11 + thZ) - sin(th12 + th13)*sin(thY), -(cos(thY)*cos(th11 + thZ)*sin(th12 + th13)) - cos(th12 + th13)*sin(thY), -(cos(thY)*sin(th11 + thZ)), bodyX - (proximalLen*sin(th12) + distalLen*sin(th12 + th13))*sin(thY) + (cos(thY)*(LBody*cos(thZ) + 2*(proximalLen*cos(th12) + distalLen*cos(th12 + th13))*cos(th11 + thZ) - WBody*sin(thZ)))/2;...
        cos(thY)*sin(th12 + th13)*sin(thX) + cos(th12 + th13)*(cos(th11 + thZ)*sin(thX)*sin(thY) + cos(thX)*sin(th11 + thZ)), cos(th12 + th13)*cos(thY)*sin(thX) - sin(th12 + th13)*(cos(th11 + thZ)*sin(thX)*sin(thY) + cos(thX)*sin(th11 + thZ)), cos(thX)*cos(th11 + thZ) - sin(thX)*sin(thY)*sin(th11 + thZ), bodyY + cos(thY)*(proximalLen*sin(th12) + distalLen*sin(th12 + th13))*sin(thX) + (sin(thX)*sin(thY)*(LBody*cos(thZ) + 2*(proximalLen*cos(th12) + distalLen*cos(th12 + th13))*cos(th11 + thZ) - WBody*sin(thZ)) + cos(thX)*(WBody*cos(thZ) + LBody*sin(thZ) + 2*(proximalLen*cos(th12) + distalLen*cos(th12 + th13))*sin(th11 + thZ)))/2;...
        -(cos(thX)*(cos(thY)*sin(th12 + th13) + cos(th12 + th13)*cos(th11 + thZ)*sin(thY))) + cos(th12 + th13)*sin(thX)*sin(th11 + thZ), -(cos(th12 + th13)*cos(thX)*cos(thY)) + sin(th12 + th13)*(cos(thX)*cos(th11 + thZ)*sin(thY) - sin(thX)*sin(th11 + thZ)), cos(th11 + thZ)*sin(thX) + cos(thX)*sin(thY)*sin(th11 + thZ), bodyZ - (cos(thX)*(2*cos(thY)*(proximalLen*sin(th12) + distalLen*sin(th12 + th13)) + sin(thY)*(LBody*cos(thZ) + 2*(proximalLen*cos(th12) + distalLen*cos(th12 + th13))*cos(th11 + thZ) - WBody*sin(thZ))))/2 + (sin(thX)*(WBody*cos(thZ) + LBody*sin(thZ) + 2*(proximalLen*cos(th12) + distalLen*cos(th12 + th13))*sin(th11 + thZ)))/2;...
        0, 0, 0, 1];
    
    output(:,:,:,i)=particularSolMatrix;
end
end