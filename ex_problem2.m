%% Initialize
problemName='ex3';
loadSubDirectories();
close all

robot=struct();
robot.distLen=1;
robot.proxLen=1;
robot.bodyPos=[0,0,1];
robot.bodyRot=[0,0,0];
robot.bodyW=1;
robot.bodyL=1;

fResult=[3 3 -4];
nResult=[0 0 0];
% init=[...
% randomPoint(regions(1).mesh);...
% randomPoint(regions(2).mesh);...
% randomPoint(regions(3).mesh);...
% randomPoint(regions(4).mesh)];

init =[...
    1.4761   -0.8025    0.0559;...
   -1.9040   -0.1029    0.0408;...
   -1.1492   -1.6833    0.0504;...
    1.0155    0.6785   -0.2607];

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
