function clean=improveMesh(vertices,points)

step=0;
clean=vertices;

%cleanup until no change
while step<10
    step=step+1;
    
    nTri=size(clean,1);
    % remove bad cells
    clean=remvBadCells(clean,points);

    % remove skinny cells
    clean=remvSkinnyCells(clean,points);
    
    nCleaned=nTri-size(clean,1);
    
    
    if nCleaned<1
        break
    end
end
end