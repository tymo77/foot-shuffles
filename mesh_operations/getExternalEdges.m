function exterior=getExternalEdges(vertices)
edges=[];

%for each triangle in the vertices, get all its edges and append them
for row=vertices'
    edges=[edges; nchoosek(row',2)];
end

%order all edges smallest to largest
edges=sort(edges,2);

%get indices of unique elements
[~,ia,~]=unique(edges,'rows');

%interior are those which were not unique (repeated edges)
interior=edges(setdiff(1:size(edges,1),ia),:);

%exterior edges are all edges less the interior edges
exterior=setdiff(edges,interior,'rows');
end
