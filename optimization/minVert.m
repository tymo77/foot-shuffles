function [xstar,fstar,activeEdges]=minVert(fun,vertexPts)

fval=zeros(size(vertexPts,1),1);

for i=1:size(vertexPts,1)
    fval(i)=fun(vertexPts(i,:));
end

[fstar,istar]=min(fval);
xstar=vertexPts(istar,:);

if size(vertexPts,1)==3
    if istar==1
        activeEdges=[1 0 1];
    elseif istar==2
        activeEdges=[1 1 0];
    else
        activeEdges=[0 1 1];
    end
else
   activeEdges=[]; 
end

end
