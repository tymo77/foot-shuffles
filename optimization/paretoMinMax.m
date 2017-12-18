function [pareto,indices]=paretoMinMax(listPairs)

[pareto,indices]=paretoMin([listPairs(:,1) -listPairs(:,2)]);
pareto=[pareto(:,1) -pareto(:,2)];

end