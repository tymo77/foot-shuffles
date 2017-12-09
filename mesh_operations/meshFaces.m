function faceIndices=meshFaces(tetraIndices)

targetDim=3;
sourceDim=size(tetraIndices,2);

N=size(tetraIndices,1);
NperTet=nchoosek(sourceDim,targetDim);


faceIndices=zeros(NperTet*N,targetDim);
ind=nchoosek(1:sourceDim,targetDim);

for i=1:NperTet:NperTet*N
    
    for j=1:NperTet
        faceIndices(i+j-1,:)=tetraIndices(floor(i/NperTet)+1,ind(j,:));
    end
    
end


end