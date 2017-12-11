function exterior=getExternalEdges(vertices)
edges=[];
for row=vertices'
    edges=[edges; nchoosek(row',2)];
end
edges=sort(edges,2);

[~,ia,~]=unique(edges,'rows');
interior=edges(setdiff(1:size(edges,1),ia),:);
exterior=setdiff(edges,interior,'rows');
end
