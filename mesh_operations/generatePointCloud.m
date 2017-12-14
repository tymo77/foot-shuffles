function [x,y,z]=generatePointCloud(th1Range,th2Range,th3Range,legNo,robot)

N=length(th1Range);
[TH1,TH2,TH3]=meshgrid(th1Range,th2Range,th3Range);

f=@(th1,th2,th3) footPosForwardKinematics([th1,th2,th3],legNo,robot);

x=zeros(N^3,1);
y=x;z=x;

for i=1:N^3
    pos=f(TH1(i),TH2(i),TH3(i));
    x(i)=pos(1);
    y(i)=pos(2);
    z(i)=pos(3);
end
end