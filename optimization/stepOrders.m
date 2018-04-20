function ordersList=stepOrders(initpos,thresh,pc,f,n,N,method)
% stepOrders  Returns possible step orders given the problem statement.
%   ordersList = stepOrders(initpos,thresh,pc,f,n,N,method) 
%   returns the list of step orders that are possible according to the
%   initpos of the feet, the threshold (thresh) for whether a foot is
%   moveable (0 should be default, thresh >= 0 ). pc is the center of mass
%   of the robot. f and n are the body forces/momemnts. N is the maximum
%   number of steps in a step-order (4 should be default). method chooses
%   the method (3 should be default/best).
%   method:
%       1 - all possible sub-orders intially moveable - no duplicates
%       2 - all possible sub-orders intially moveable - includes duplicates
%       3 - method 1 + removes subsequent opposites (they don't affect
%       eachother in a quadruped)

ordersList={};
for i=1:N
    ordersI=stepOrdersN(initpos,thresh,pc,f,n,i,method);
    for j=1:size(ordersI,1)
        ordersList{end+1}=ordersI(j,:);
    end
end


if method ==3
    %remove moves with subsequent opposites
    for i=1:length(ordersList)
        for j=1:length(ordersList{i})-1
            if abs(ordersList{i}(j+1)-ordersList{i}(j))==2
                ordersList{i}=[];
                break
            end
        end
    end
end

ordersList=ordersList(~cellfun('isempty',ordersList));
end