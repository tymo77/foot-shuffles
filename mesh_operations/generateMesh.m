function mesh=generateMesh(legNo,minAngle,maxAngle,Nangle,surface,...
    Nsurface,robot)

%% Workspace point cloud

th1=linspace(minAngle(1),maxAngle(1),Nangle);
th2=linspace(minAngle(2),maxAngle(3),Nangle);
th3=linspace(minAngle(3),maxAngle(3),Nangle);

[x,y,z]=generatePointCloud(th1,th2,th3,legNo,robot);

workspacePts=[x y z];
tri = delaunay(x,y,z);
workspaceFaces=meshFaces(tri);

%% intersection

%box in shadow of workspace
xbnds=[min(workspacePts(:,1)),max(workspacePts(:,1))];
ybnds=[min(workspacePts(:,2)),max(workspacePts(:,2))];

surfPts=generateSurfacePoints(Nsurface,xbnds,ybnds,surface);
sx=surfPts(:,1);sy=surfPts(:,2);

triSurf=delaunay(sx,sy);
intPts=mesh2mesh(workspaceFaces,workspacePts,triSurf,surfPts);

%% filter intersection
filterPts=filterPtsByInvKin(intPts-robot.bodyPos,minAngle,maxAngle,legNo,robot);
filterTri=delaunay(filterPts(:,1),filterPts(:,2));
filterTri=filterTriByCentroid(filterTri,filterPts-robot.bodyPos,minAngle,maxAngle,legNo,robot);
filterTri=removeDuplicateFaces(filterTri);

%% remove bad cells
filterTri=improveMesh(filterTri,filterPts);

vertPt1List=filterPts(filterTri(:,1),:);
vertPt2List=filterPts(filterTri(:,2),:);
vertPt3List=filterPts(filterTri(:,3),:);
extEdges=getExternalEdges(filterTri);

allindices=reshape(filterTri,numel(filterTri),1);%list all indices in one line
allindices=unique(allindices);%get all unique indices in use

mesh=struct();
mesh.vertPt1=vertPt1List;
mesh.vertPt2=vertPt2List;
mesh.vertPt3=vertPt3List;
mesh.extEdges=int32(extEdges);
mesh.points=filterPts;
mesh.tri=int32(filterTri);
mesh.allindices=int32(allindices);

end