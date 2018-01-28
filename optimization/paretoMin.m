function [pareto,indices]=paretoMin(listPairs)

if size(listPairs,2)~=2
    error('paretoMin is meant to compare a list of pairs')
end
key=1:size(listPairs,1);

%remove NaN entries
key(any(isnan(listPairs),2))=[];
listPairs(any(isnan(listPairs),2),:)=[];


N=size(listPairs,1);
test=false(N,1);

for i=1:N
    indices=1:N;
    indices(i)=[];
    
    %pareto condition
    test(i)=~any(all(listPairs(indices,:)<=listPairs(i,:),2));
    
    %check for exact duplicate
    if any(all(listPairs(indices,:)==listPairs(i,:),2))
        
        %if the duplicate pairs are pareto-optimal when compared to their
        %non-duplicates, then include them in the pareto-front
        duplicateIndices=indices(~all(listPairs(indices,:)==listPairs(i,:),2));
        
        dupInPareto=~any(all(listPairs(duplicateIndices,:)<=listPairs(i,:),2));
        if dupInPareto
            test(i)=true;
            test(duplicateIndices)=true;
        end
    end
    
end

pareto=listPairs(test,:);
indices=1:N;
indices=indices(test);
indices=key(indices);

end