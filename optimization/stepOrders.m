function ordersList=stepOrders(initpos,thresh,pc,f,n,N,method)
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