function filterindices=remvSkinnyCells(indices,points)
filterindices=indices;

% for each face
i=1;
while i<=size(filterindices,1)
    %measure the interior angles and find the largest
    angles=interAngles(points(filterindices(i,:),:));
    [maxangle,angI]=max(angles);
    
    %if the angle is too oblique remove the vertex it corresponds to and
    %remesh the indices
    if maxangle>deg2rad(170)
        filterindices=remvVertex(filterindices(i,angI),filterindices,points);
    end
    i=i+1;
end
        

end