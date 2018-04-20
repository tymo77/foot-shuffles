function [xstars,fstars,exitflags]=optimizeAllShuffles(init,orders,fResult,...
    nResult,regions,robot,gsOn)
% optimizeAllShuffles finds the optimum foot placements for each steporder
%   [xstars,fstars,exitflags] = optimizeAllShuffles(init,orders,fResult,...
%    nResult,regions,robot,gsOn)
%   init - initial foot positions
%   orders - possible steporders
%   fresult/nresult - resultant force/moment vectors
%   regions - stepspaces
%   robot - robot struct with all its parameters
%   gsOn - use global search on/off (must have Global Opt Toolbox)
%   
%   xstars - x,y of opt foot positions for each shuffle
%   fstars - fitness of each shuffle
%   exitflags - exit flag of each shuffle:
%       exitflag > 0 : optimum solution
%       exitflag = -20 : shuffle was skipped because it would be
%       reduntant and have no feasible solution
% see fmincon for other exitflags

skip={};
N=length(orders);
xstars={};
fstars=zeros(N,1)+NaN;
exitflags=zeros(N,1)+9;


for i=1:length(orders)
    order=orders(i);
    order=removeOrderStarts(skip,order);
    if isempty(order)
        xstars{i}=[];
        exitflags(i)=-20;
    else
        
        [xstar,fstars(i),exitflag,~]=optimFinalStabInitStabAndLegConst(init,order{1},...
            fResult,nResult,regions,robot,gsOn);
        xstars{i}=xstar;
        exitflags(i)=exitflag;
        if exitflag==-2
            skip{end+1}=order{1};
        end
    end
end
end