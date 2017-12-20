function newArray=removeOrderStarts(targets,array)


%key used to select which array elements pass
key=true(length(array),1);

%check each element in array
for i=1:length(array)
    %get length of element
    N=length(array{i});
    
    %compare to each target
    for target=targets
        
        %if the target is longer than ignore it
        if length(target{1})<=N
            %pad the target to the element length
            t=padarray(target{1},[0 N-length(target{1})],0,'post');
            if sum(t==array{i})==length(target{1})
                key(i)=false;
            end
        end
    end
end

temp=1:length(array);

newArray=array(temp(key));
end
