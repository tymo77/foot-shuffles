function [x,y,z]=generatePointCloud(N,th1Range,th2Range,th3Range,bodyPos,bodyRot,bodyW,bodyL,distalLen,proximalLen,legNo)

[TH1,TH2,TH3]=meshgrid(th1Range,th2Range,th3Range);

f=@(th1,th2,th3) footPosForwardKinematics(bodyRot(1),bodyRot(2),bodyRot(3),...
    bodyRot(1),bodyPos(2),bodyPos(3),[th1,th2,th3],...
    bodyW,bodyL,distalLen,proximalLen,legNo);

x=zeros(N^3,1);
y=x;z=x;

for i=1:N^3
    pos=f(TH1(i),TH2(i),TH3(i));
    x(i)=pos(1);
    y(i)=pos(2);
    z(i)=pos(3);
end
end