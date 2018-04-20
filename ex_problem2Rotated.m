%% Initialize
problemName='ex3Rotated';
loadSubDirectories();
close all

robot=struct();
robot.distLen=1;
robot.proxLen=1;
robot.bodyPos=[0,0,1];
robot.bodyRot=[0,0,0];

robot.bodyW=1;
robot.bodyL=1;

fResult=[4 -5 -4];
nResult=[0 0 0];
% init=[...
% randomPoint(regions(1).mesh);...
% randomPoint(regions(2).mesh);...
% randomPoint(regions(3).mesh);...
% randomPoint(regions(4).mesh)];
   
init =[...
    1.6738    1.7531    0.0185;...
   -1.5422    1.3406    0.0375;...
   -1.1492   -1.6833    0.0504;...
    1.8399    0.6888    0.1484];

initStab=angularStabilityMargin(robot.bodyPos,init,fResult,nResult);
exportInitPts(init,problemName);
exportRobot(robot,problemName);
%% generate mesh
minAngles=...
    [-70 -70 -70;...
    110 -70 -70;...
    110 -70 -70;...
    -70 -70 -70];

maxAngles=...
    [70 70 70;...
    250 70 70;...
    250 70 70;...
    70 70 70];

regions=buildAllRegions(minAngles,maxAngles,10,'wave',robot);

displayRegions(regions)
exportRegions(regions,problemName);

%% Global Search - order type 3
orders=stepOrders(init,initStab,robot.bodyPos,fResult,nResult,4,3);

[xstars,fstars,exitflags]=optimizeAllShuffles(init,orders,fResult,nResult,regions,robot,true);
[xstars2,fstars2,orders2,exitflags2]=findMaxResult(orders,xstars,-fstars,exitflags);

%% results
Nresults=length(exitflags2);
for i=1:Nresults
    endStab(i)=showResult(xstars2{i},orders2{i},init,regions,robot,fResult,nResult,exitflags2(i));
end

%% pareto front
[paretoFront, indices]=stepPareto(xstars,orders,exitflags,init,fResult,nResult,regions,robot);

plotPareto(paretoFront);

%% before and after
n=indices(end);
[endStab,stability,interstability]=showResult(xstars{n},orders{n},...
    init,regions,robot,fResult,nResult,exitflags(n));
plotInitial(init)

plotStability(interstability,stability)

%%
iexport=indices(end);
xyz=xyzOfPoints(orders{iexport},xstars{iexport},regions);
exportShuffle(orders{iexport},xyz,'ex3',problemName);
