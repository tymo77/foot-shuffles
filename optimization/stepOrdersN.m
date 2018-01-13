function order=stepOrdersN(initpos,thresh,pc,f,n,N,method)

initmoveable=moveableLegs(initpos,thresh,pc,f,n);
legs=[1 2 3 4];

if numel(initmoveable)==0
    order=[];
else
    if method == 1
        
        if N<=4
            order=permsr(nchoosek(legs,N));
            
            
            %get only those which are initially moveable
            
        else
            error('invalid step order gen method for no. of steps (N)')
        end
    elseif method == 2
        order=permsVKN(legs,setdiff(legs,initmoveable),N);
        
        
    elseif method == 3
        if N<=4
            order=permsr(nchoosek(legs,N));
        else
            error('invalid step order gen method for no. of steps (N)')
        end
       
        
    else
        error('invalid step order gen method')
    end
    
    order=order(any(order(:,1)==initmoveable,2),:);
end
end

function p=permsr(x)
N=size(x,1);
P=factorial(size(x,2));

p=zeros(N*P,size(x,2));
for i=1:N
    y=perms(x(i,:));
    p(P*(i-1)+1:P*i,:)=y;
end
end