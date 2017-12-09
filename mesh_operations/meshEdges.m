function faceIndices=meshEdges(tetraIndices)

targetDim=2;

N=size(tetraIndices,1);
NperTet=nchoosek(4,targetDim);

faceIndices=zeros(NperTet*N,targetDim);
ind=nchoosek([1 2 3 4],targetDim);

for i=1:NperTet:NperTet*N
    
    for j=1:NperTet
        faceIndices(i+j-1,:)=tetraIndices(floor(i/NperTet)+1,ind(j,:));
    end
    
end


end
