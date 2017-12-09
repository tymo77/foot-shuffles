%% Initialize
loadSubDirectories();
close all

distalLen=1;
proximalLen=1;
bodyPos=[0,0,0];
bodyRot=[0,0,0];
bodyW=1;
bodyL=1;
%% Workspace point cloud
N=12;
deg70=deg2rad(70);
th1=linspace(-deg70,deg70,N);
th2=th1;
th3=th1;
[x,y,z]=generatePointCloud(N,th1,th2,th3,bodyPos,bodyRot,bodyW,bodyL,distalLen,proximalLen,1);
scatter3(x,y,z)
axis equal

workspacePts=[x y z];
tri = delaunay(x,y,z);
trisurf(tri,x,y,z);
workspaceFaces=meshFaces(tri.ConnectivityList);
axis equal

%% surface
Nsurf=20;xbnds=[-3,3];ybnds=[-3,3];

surfPts=generateSurfacePoints(Nsurf,xbnds,ybnds,'wave');
sx=surfPts(:,1);sy=surfPts(:,2);sz=surfPts(:,3);

scatter3(sx,sy,sz)
triSurf=delaunayTriangulation(sx,sy);
trisurf(triSurf.ConnectivityList,sx,sy,sz)

%% intersection

Nsurf=15;
%box in shadow of workspace
xbnds=[min(workspacePts(:,1)),max(workspacePts(:,1))];
ybnds=[min(workspacePts(:,2)),max(workspacePts(:,2))];

surfPts=generateSurfacePoints(Nsurf,xbnds,ybnds,'wave');
sx=surfPts(:,1);sy=surfPts(:,2);sz=surfPts(:,3);
triSurf=delaunay(sx,sy);

intPts=mesh2mesh(workspaceFaces,workspacePts,triSurf,surfPts);

scatter3(intPts(:,1),intPts(:,2),intPts(:,3))
hold on
scatter3(x,y,z,'r')
axis equal


interSectTri=delaunay(intPts(:,1),intPts(:,2));
figure
hold on
scatter3(intPts(:,1),intPts(:,2),intPts(:,3))
axis equal
%% filter intersection
filterPts=filterPtsByInvKin(intPts-bodyPos,-deg70,deg70,bodyW,bodyL,distalLen,proximalLen,1);
filterTri=delaunay(filterPts(:,1),filterPts(:,2));

figure
trisurf(filterTri,filterPts(:,1),filterPts(:,2),filterPts(:,3))
axis equal

filterTri2=filterTriByCentroid(filterTri,filterPts-bodyPos,-deg70,deg70,bodyW,bodyL,distalLen,proximalLen,1);
figure
trisurf(filterTri2,filterPts(:,1),filterPts(:,2),filterPts(:,3))
axis equal
