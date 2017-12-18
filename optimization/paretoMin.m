function [pareto,indices]=paretoMin(listPairs)

if size(listPairs,2)~=2
    error('paretoMin is meant to compare a list of pairs')
end

N=size(listPairs,1);
test=false(N,1);


for i=1:N
    indices=1:N;
    indices(i)=[];

    test(i)=~any(all(listPairs(indices,:)<=listPairs(i,:),2));

end

pareto=listPairs(test,:);
indices=1:N;
indices=indices(test);

end