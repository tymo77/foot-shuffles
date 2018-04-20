%this example plots the surfaces of one of the regions
%Note: requires the region to be created already


g=@(x) 0;
ftest=@(x)meshPenalty(g,x,2,1,regions);
x=linspace(0,3);
y=linspace(-3,3);
[X,Y]=meshgrid(x,y);
Z=zeros(100);

for i=1:size(X,1)
    for j=1:size(X,2)
        
        Z(i,j)=ftest([X(i,j) Y(i,j)]);
    end
end

%%
figure
hold on
surf(X,Y,Z)
contour(X,Y,Z,20)
xpts=regions(1).mesh.points(:,1);
ypts=regions(1).mesh.points(:,2);
zpts=zeros(length(xpts),1);

shading interp
trisurf(regions(1).mesh.tri,xpts,ypts,zpts)
axis square
view(3)
grid on
c = gray;
c = flipud(c);
colormap(c);