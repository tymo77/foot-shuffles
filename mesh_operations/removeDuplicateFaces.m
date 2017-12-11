function filtertestindices=removeDuplicateFaces(indices)

duplicateKey=logical(0*indices(:,1));

for i=1:size(indices,1)
    matches=findFace(indices(i,:),indices);
    if length(matches)>1
        for j=2:length(matches)
            duplicateKey(matches(j))=1;
        end
    end
end
filtertestindices=indices(~duplicateKey,:);
end