function [xstar,fstar,exitflag,output]=optimFinalStabInitStabConst(init,...
    order,fResult,nResult,regions,robot)

initstab=angularStabilityMargin(robot.bodyPos, init, fResult, nResult);
thresh=initstab;


stability=@(x) -endStabFit(x,order,init,robot.bodyPos,fResult,nResult);
f=@(x)meshPenalty(stability,x,2,order,regions);

nonlconst=@(x) minStabConst(thresh,x,order,init,robot.bodyPos,fResult,nResult,regions);

opts = optimoptions(@fmincon,'MaxFunctionEvaluations',10000,'Display','off');

problem = struct('solver','fmincon','x0',init(order,1:2),...
    'objective',f,'nonlcon',nonlconst,'Aineq',[],'bineq',[],...
    'Aeq',[],'beq',[],'lb',[],'ub',[],'options',opts);

tic;
[xstar,fstar,exitflag,output] =fmincon(problem);
toc
end