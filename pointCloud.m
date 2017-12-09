close all
distalLen=1;
proximalLen=1;
bodyPos=[0,0,0];
bodyRot=[0,0,0];
bodyW=1;
bodyL=1;


N=20;
deg70=deg2rad(70);
th1=linspace(-deg70,deg70,N);
th2=th1;
th3=th1;
[TH1,TH2,TH3]=meshgrid(th1,th2,th3);
f=@(th1,th2,th3) footPosForwardKinematics(bodyRot(1),bodyRot(2),bodyRot(3),...
    bodyRot(1),bodyPos(2),bodyPos(3),[th1,th2,th3],...
    bodyW,bodyL,distalLen,proximalLen,1);

clear x y z
for i=1:N^3
    pos=f(TH1(i),TH2(i),TH3(i));
    x(i)=pos(1);
    y(i)=pos(2);
    z(i)=pos(3);
end
scatter3(x,y,z)
axis equal

workspacePts=[x' y' z'];
tri = delaunayTriangulation(x',y',z');
trisurf(tri.ConnectivityList,x,y,z);
workspaceFaces=meshFaces(tri.ConnectivityList);
axis equal

%% surface
Nsurf=10;
sx=linspace(-1,3,Nsurf);
sy=linspace(-2,2,Nsurf);
[sX,sY]=meshgrid(sx,sy);
sZ=1/10*sin(2*sX).*sin(2*sY+pi);

sx=reshape(sX,[1,Nsurf*Nsurf]);
sy=reshape(sY,[1,Nsurf*Nsurf]);
sz=reshape(sZ,[1,Nsurf*Nsurf]);

scatter3(sx,sy,sz)
triSurf=delaunayTriangulation(sx',sy');
trisurf(triSurf.ConnectivityList,sx,sy,sz)

%% intersection
surfPts=[sx' sy' sz'];

pts=mesh2mesh(workspaceFaces,workspacePts,triSurf.ConnectivityList,surfPts);

scatter3(pts(:,1),pts(:,2),pts(:,3))
hold on
scatter3(x,y,z,'r')
axis equal

%% intersection surface
interSectTri=delaunayTriangulation(pts(:,1),pts(:,2));
figure
hold on
triplot(interSectTri)
scatter3(pts(:,1),pts(:,2),pts(:,3))
axis equal

%% testing Filter
filterPts=filterPtsByInvKin(workspacePts-bodyPos,-deg70,deg70,bodyW,bodyL,distalLen,proximalLen,1);

figure
scatter3(workspacePts(:,1),workspacePts(:,2),workspacePts(:,3),'k');
hold on
scatter3(filterPts(:,1),filterPts(:,2),filterPts(:,3),'rx');
axis equal

figure
scatter3(filterPts(:,1),filterPts(:,2),filterPts(:,3),'rx');
axis equal
%% filter intersection
filterPts=filterPtsByInvKin(pts-bodyPos,-deg70,deg70,bodyW,bodyL,distalLen,proximalLen,1);

filterTri=delaunay(filterPts(:,1),filterPts(:,2));
trisurf(filterTri,filterPts(:,1),filterPts(:,2),filterPts(:,3))
axis equal

filterTri2=filterTriByCentroid(filterTri,pts-bodyPos,-deg70,deg70,bodyW,bodyL,distalLen,proximalLen,1);

trisurf(filterTri2,filterPts(:,1),filterPts(:,2),filterPts(:,3))
axis equal
