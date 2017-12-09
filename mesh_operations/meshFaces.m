function faceIndices=meshFaces(tetraIndices)

faceIndices=zeros(4*size(tetraIndices,1),3);
ind=[1 2 3;2 3 4;1 3 4;1 2 4];
for i=1:4:4*size(tetraIndices,1)
    faceIndices(i,:)=tetraIndices(floor(i/4)+1,ind(1,:));
    faceIndices(i+1,:)=tetraIndices(floor(i/4)+1,ind(2,:));
    faceIndices(i+2,:)=tetraIndices(floor(i/4)+1,ind(3,:));
    faceIndices(i+3,:)=tetraIndices(floor(i/4)+1,ind(4,:));
end


end