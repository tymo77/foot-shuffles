function cleanindices=remvBadCells(indices,points)

allindices=reshape(indices,numel(indices),1);%list all indices in one line
allindices=unique(allindices);%get all unique indices in use
counter=0;

duplicateMap=[];%pair where 2 maps to 1
duplicateList=[];%list of every index that gets mapped in the duplicate map

for i=1:length(allindices)
    if sum(duplicateList==i)>0%if i is in the skip array, skip it
        continue
    end
    
    pt1=points(allindices(i),:);
    for j=i+1:length(allindices)
        if sum(duplicateList==j)>0%if j is in the skip array, skip it
            continue
        end
        
        pt2=points(allindices(j),:);
        if norm(pt1-pt2)<100*eps
            counter=counter+1;
            duplicateList=[duplicateList allindices(j)];
            duplicateMap=[duplicateMap;allindices(j),allindices(i)];
            
        end
    end
end

for i=1:length(duplicateList)
    for j=1:numel(indices)
        if indices(j)==duplicateMap(i,1)
            indices(j)=duplicateMap(i,2);
        end
    end
end



%remove collapsed faces
indices=sort(indices,2);
cleanindices=indices(~((indices(:,1)==indices(:,2))|(indices(:,2)==indices(:,3))),:);
end
