function [xstars,exitflags]=optimizeAllShuffles(init,orders,fResult,...
    nResult,regions,robot)

skip={};
N=length(orders);
xstars={};
exitflags=zeros(N,1)+9;


for i=1:length(orders)
    order=orders(i);
    order=removeOrderStarts(skip,order);
    if isempty(order)
        xstars{i}=[];
        exitflags(i)=-20;
    else
        
        [xstar,~,exitflag,~]=optimFinalStabInitStabConst(init,order{1},...
            fResult,nResult,regions,robot);
        xstars{i}=xstar;
        exitflags(i)=exitflag;
        if exitflag==-2
            skip{end+1}=order{1};
        end
    end
end
end