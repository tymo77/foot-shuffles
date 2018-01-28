function [paretoFront, indices]=stepPareto(xstars,orders,exitflags,init,fResult,nResult,regions,robot)
%initialize foot positions

N=length(orders);
endStab=zeros(N,1)+NaN;
noSteps=zeros(N,1);
for i=1:N
    x=init;
    order=orders{i};
    noSteps(i)=length(order);
    
    %skip those values which failed to find an optimum
    if exitflags(i)>0
        %convert and update foot positions with xyz point
        for j=1:noSteps(i)
            x(order(j),:)=postProcess(xstars{i}(j,:),regions,order(j));
        end
        %compute end-stability
        endStab(i)=angularStabilityMargin(robot.bodyPos, x, fResult, nResult);
    end
    
end

[paretoFront,indices]=paretoMinMax([noSteps endStab]);

%add initial condition
paretoFront=[0 angularStabilityMargin(robot.bodyPos, init, fResult, nResult);paretoFront];
end