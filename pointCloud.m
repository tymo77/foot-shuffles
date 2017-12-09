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
N=20;
deg70=deg2rad(70);
th1=linspace(-deg70,deg70,N);
th2=th1;
th3=th1;
[x,y,z]=generatePointCloud(N,th1,th2,th3,bodyPos,bodyRot,bodyW,bodyL,distalLen,proximalLen,1);
scatter3(x,y,z)
axis equal

workspacePts=[x y z];
tri = delaunayTriangulation(x,y,z);
trisurf(tri.ConnectivityList,x,y,z);
workspaceFaces=meshFaces(tri.ConnectivityList);
axis equal

%% surface
Nsurf=30;xbnds=[-3,3];ybnds=[-3,3];
surfPts=generateSurfacePoints(Nsurf,xbnds,ybdns,'wave');

sx=surfPts(:,1);sy=surfPts(:,2);sz=surfPts(:,3);

scatter3(sx,sy,sz)
triSurf=delaunayTriangulation(sx,sy);
trisurf(triSurf.ConnectivityList,sx,sy,sz)

%% intersection
surfPts=[sx sy sz];

intPts=mesh2mesh(workspaceFaces,workspacePts,triSurf.ConnectivityList,surfPts);

scatter3(pts(:,1),pts(:,2),pts(:,3))
hold on
scatter3(x,y,z,'r')
axis equal


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
