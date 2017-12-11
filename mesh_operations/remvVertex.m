function cleanvertices=remvVertex(badvert,vertices,points)

%recursively look for all bad vertices that are adjacent to the target one
allbadverts=checkForAdjacentSkinnyCells(badvert,[],vertices,points);
allbadverts=unique(allbadverts);

%get all the faces that are involved with the bad vertices
faces=[];
for i=1:length(allbadverts)
    faces=[faces; unique(findFace(allbadverts(i),vertices))];
end
targetvertices=unique(flatten2D(vertices(faces,:)));
oldbound=getExternalEdges(vertices(faces,:));

%remove the badverts
targetvertices=setdiff(targetvertices,allbadverts);
subpoints=points(targetvertices,:);

%re-mesh
submesh=delaunay(subpoints(:,[1 2]));
submesh=targetvertices(submesh);
newbound=getExternalEdges(submesh);

%preserve the original bounds
diffbound=setdiff(newbound,oldbound,'rows');
while numel(diffbound)>0
    extraFace=findFace(diffbound(1,:),submesh);
    submesh=removeRows(extraFace,submesh);
    newbound=getExternalEdges(submesh);
    diffbound=setdiff(newbound,oldbound,'rows');
end

%delete the old faces and append the new ones
cleanvertices=removeRows(faces,vertices);
cleanvertices=[cleanvertices; submesh];
end

function y=flatten2D(x)
N=numel(x);
y=reshape(x,1,N);
end

function C=remove(x,A)
C=A(~(A==x));
end

function C=removeRows(n,A)
key=setdiff(1:size(A,1),n);
C=A(key,:);
end

function allbadverts=checkForAdjacentSkinnyCells(badverts,facestoignore,vertices,points)
if numel(badverts)==0
    allbadverts=[];
else
    faces=[];
    for i=1:length(badverts)
        faces=[faces; unique(findFace(badverts(i),vertices))];
    end
    
    faces=setdiff(faces,facestoignore);
    testvertices=vertices(faces,:);
    allangles=zeros(length(faces),3);
    
    for i=1:size(testvertices,1)
        allangles(i,:)=interAngles(points(testvertices(i,:),:));
    end
    
    newbadverts=setdiff(testvertices(allangles>deg2rad(179.5))',badverts);
    
    subsequentbad=checkForAdjacentSkinnyCells(newbadverts,[faces; facestoignore],vertices,points);
    newbadverts=[newbadverts subsequentbad];
    allbadverts=[badverts newbadverts];
end
end