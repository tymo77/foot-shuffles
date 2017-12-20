function ordersList=stepOrders(initpos,thresh,pc,f,n,N,method)
ordersList={};
for i=1:N
    ordersI=stepOrdersN(initpos,thresh,pc,f,n,i,method);
    for j=1:size(ordersI,1)
        ordersList{end+1}=ordersI(j,:);
    end
end

ordersList=ordersList(~cellfun('isempty',ordersList));
end