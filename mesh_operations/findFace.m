function faceIndex=findFace(targetIndices,faceIndices)
Ntarget=length(targetIndices);

faceIndex=zeros(size(faceIndices,1),1);
for i=1:size(faceIndices,1)
    perms=nchoosek(faceIndices(i,:),Ntarget);
    for j=1:size(perms,1)
        if sum(sort(targetIndices)==sort(perms(j,:)))==Ntarget
            faceIndex(i)=i;
        end
    end
end

faceIndex=faceIndex(~faceIndex==0);
end