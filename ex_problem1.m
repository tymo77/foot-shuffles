%% Initialize
problemName='ex2';
loadSubDirectories();
close all

%define the robot struct
robot=struct();
robot.distLen=1;
robot.proxLen=1;
robot.bodyPos=[0,0,1];
robot.bodyRot=[0,0,0];
robot.bodyW=1;
robot.bodyL=1;

%resultant forces snd moments
fResult=[3 3 -4];
nResult=[0 0 0];

%initial foot positions
init=[2.1544    0.5492    0.2435;...
-1.9865    0.8372   -0.2201;...
-1.3230   -1.7178    0.0606;...
1.8362   -1.4301   -0.0233];

%calculate intial stability and export intitial data
initStab=angularStabilityMargin(robot.bodyPos,init,fResult,nResult);
exportInitPts(init,problemName);
exportRobot(robot,problemName);
%% generate mesh
%NOTE: This is arguably the hardest part to understand, and the most likely
%to give difficulty if you start to change the terrain. Basically, I had to
%write my own mesh repair function as the ray-interection method of
%mesh2mesh intersction often gives VERY degenerate mesh cells. If you want
%to expand the utility, you may have to invest considerable time into
%understanding and fixing my mesh repair functions or writing/acquiring
%your own.


%joint angle constraints
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

%build step-space regions
regions=buildAllRegions(minAngles,maxAngles,10,'wave',robot);

%plot regions
displayRegions(regions)
exportRegions(regions,problemName);
%% optimization using all step orders - order type 2

%generate the possible step orders that are not redundant
orders=stepOrders(init,initStab,robot.bodyPos,fResult,nResult,4,2);

%find optimum shuffles for each step-order
[xstars,fstars,exitflags]=optimizeAllShuffles(init,orders,fResult,nResult,regions,robot,false);

%this is the best step-order and those within a tolerance margin of the
%best
[xstars2,fstars2,orders2,exitflags2]=findMaxResult(orders,xstars,-fstars,exitflags);

%show the steps of each
Nresults=length(exitflags2);
for i=1:Nresults
    endStab(i)=showResult(xstars2{i},orders2{i},init,regions,robot,fResult,nResult,exitflags2(i));
end

% construt pareto-front from optimized shuffles
[paretoFront, indices]=stepPareto(xstars,orders,init,fResult,nResult,regions,robot);

%plot figures of pareto front
figure
plot(paretoFront(:,1),paretoFront(:,2),'rx')
xlim([0 5])
xlabel('no. of steps')
ylabel('optimium stability')
title('pareto-optimum front')

%NOTE: The rest of the steps from here on out repeat the same process but
%use different optimization routines and different types of orders. They
%should be straightforward if you understand the previous sections
%% Global Search - order type 2
orders3=orders;
[xstars3,fstars3,exitflags3]=optimizeAllShuffles(init,orders3,fResult,nResult,regions,robot,true);
[xstars4,fstars4,orders4,exitflags4]=findMaxResult(orders3,xstars3,-fstars3,exitflags3);

%results
Nresults=length(exitflags4);
for i=1:Nresults
    endStab3(i)=showResult(xstars4{i},orders4{i},init,regions,robot,fResult,nResult,exitflags4(i));
end

% pareto-front

[paretoFront2, indices2]=stepPareto(xstars,orders,init,fResult,nResult,regions,robot);

figure
plot(paretoFront2(:,1),paretoFront2(:,2),'rx')
xlim([0 5])
xlabel('no. of steps')
ylabel('optimium stability')
title('pareto-optimum front')

iexport=indices(end);
xyz=xyzOfPoints(orders{iexport},xstars{iexport},regions);
exportShuffle(orders{iexport},xyz,'lastPareto',problemName);
%% fmincon - order type 3 

orders5=stepOrders(init,initStab,robot.bodyPos,fResult,nResult,4,3);

[xstars5,fstars5,exitflags5]=optimizeAllShuffles(init,orders5,fResult,nResult,regions,robot,false);
[xstars6,fstars6,orders6,exitflags6]=findMaxResult(orders5,xstars5,-fstars5,exitflags);


Nresults=length(exitflags6);
for i=1:Nresults
    endStab5(i)=showResult(xstars6{i},orders6{i},init,regions,robot,fResult,nResult,exitflags6(i));
end

% pareto-front

[paretoFront3, indices3]=stepPareto(xstars5,orders5,init,fResult,nResult,regions,robot);

figure
plot(paretoFront3(:,1),paretoFront3(:,2),'rx')
xlim([0 5])
xlabel('no. of steps')
ylabel('optimium stability')
title('pareto-optimum front')

%% Global Search - order type 3
orders5=stepOrders(init,initStab,robot.bodyPos,fResult,nResult,4,3);
orders7=orders5;
[xstars7,fstars7,exitflags7]=optimizeAllShuffles(init,orders7,fResult,nResult,regions,robot,true);
[xstars8,fstars8,orders8,exitflags8]=findMaxResult(orders7,xstars7,-fstars7,exitflags7);

%results
Nresults=length(exitflags8);
for i=1:Nresults
    endStab7(i)=showResult(xstars8{i},orders8{i},init,regions,robot,fResult,nResult,exitflags8(i));
end

% pareto front
[paretoFront4, indices4]=stepPareto(xstars7,orders7,exitflags7,init,fResult,nResult,regions,robot);

plotPareto(paretoFront4);

% before and after
[endStab,stability,interstability]=showResult(xstars7{8},orders7{8},...
    init,regions,robot,fResult,nResult,exitflags7(8));
plotInitial(init)

plotStability(interstability,stability)
    
    
