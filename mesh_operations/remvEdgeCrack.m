function newVertices=remvEdgeCrack(vertices)

edges=getExternalEdges(vertices);
allVertices=sort(edges(:));
[countV,uniqueV]=hist(allVertices,unique(allVertices));

crackV=uniqueV(countV>2);

if ~isempty(crackV)
    for v=crackV
        suspectEdges=edges(findFace(v,edges),:);
        suspectVerts=setdiff(unique(suspectEdges(:)),v);
        testEdges=sort(nchoosek(suspectVerts,2),2);
        missingCrackE=intersect(edges,testEdges,'rows');
        if isempty(missingCrackE)
            error('crack is too large to resolve');
        end
        newTri=sort([v missingCrackE]);
        newVertices=[vertices; newTri];
    end
else
    newVertices=vertices;
end
end