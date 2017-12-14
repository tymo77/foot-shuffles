function [angles,flags]=computeInverseKinematics(px, py, pz, LegNo, robot)
%calculates four inverse kinematic solutions for each leg
%accounts for the different displacement of the hip frame
%relative to the body frame for each hip position
flagA=0;flagB=0;

WBody=robot.bodyW;
LBody=robot.bodyL;
LProximal=robot.proxLen;
LDistal=robot.distLen; 


ky = py - 1/2*sqrt(2)*sin(1/2*pi*(LegNo - 1)+pi/4)*WBody;
kx = px - 1/2*sqrt(2)*cos(1/2*pi*(LegNo - 1)+pi/4)*LBody;

%solving for theta
th1Sol = atan2(ky, kx);

%constants
k = kx*cos(th1Sol) + ky*sin(th1Sol);

%theta 3 solutions
th3yA=sqrt(1 - ((pz^2 + k^2 - LProximal^2 - LDistal^2)/(2*LDistal*LProximal))^2);
th3xA=(pz^2 + k^2 - LProximal^2 - LDistal^2)/(2*LDistal*LProximal);
th3SolA = atan2(real(th3yA),real(th3xA));

th3yB=-sqrt(1 - ((pz^2 + k^2 - LProximal^2 - LDistal^2)/(2*LDistal*LProximal))^2);
th3xB=(pz^2 + k^2 - LProximal^2 - LDistal^2)/(2*LDistal*LProximal);
th3SolB = atan2(real(th3yB),real(th3xB));

%constants
P1A = LProximal + LDistal*cos(th3SolA);
P2A = LDistal*sin(th3SolA);

P1B = LProximal + LDistal*cos(th3SolB);
P2B = LDistal*sin(th3SolB);

%Theta 2 solution
th2SolA = atan2(k, pz) - atan2(P2A, P1A) - pi/2;
th2SolB = atan2(k, pz) - atan2(P2B, P1B) - pi/2;

%Check if the solution is technically unreachable and flag for an error
if sum(abs(imag([th3yA,th3xA])))>0
    flagA=1;
end
if sum(abs(imag([th3yB,th3xB])))>0
    flagB=1;
end


flags = [flagA,flagB];
angles = [th1Sol, th2SolA, th3SolA; th1Sol, th2SolB, th3SolB];
end