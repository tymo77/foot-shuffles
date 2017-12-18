function [xstar,fstar,exitflag,output]=optimFinalStabInitStabConst(init,...
    order,fResult,nResult,regions,robot)

initstab=angularStabilityMargin(robot.bodyPos, init, fResult, nResult);
thresh=initstab;


stability=@(x) -endStabFit(x,order,init,robot.bodyPos,fResult,nResult);
f=@(x)meshPenalty(stability,x,2,...
    regions(order(1)).mesh,regions(order(2)).mesh,...
    regions(order(3)).mesh,regions(order(4)).mesh);

nonlconst=@(x) minStabConst(thresh,x,order,init,robot.bodyPos,fResult,nResult,regions);

opts = optimoptions(@fmincon,'MaxFunctionEvaluations',10000,'Display','notify');

problem = struct('solver','fmincon','x0',init(:,1:2),...
    'objective',f,'nonlcon',nonlconst,'Aineq',[],'bineq',[],...
    'Aeq',[],'beq',[],'lb',[],'ub',[],'options',opts);

tic;
[xstar,fstar,exitflag,output] =fmincon(problem);
toc
end