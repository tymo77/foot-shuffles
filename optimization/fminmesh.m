function [xstar,fstar]=fminmesh(fun,initVertex,points,indices)

remainingOptions=indices;
step=0;
atMin=false;

%find a face with the inital vertex
initFaces=findFace([initVertex],indices);
initFace=initFaces(1);

opFace=initFace;
opIndices=indices(initFace,:);
opPoints=points(opIndices,:);
startVertex=initVertex;
address=[1 2 3];

%start loop
while ~atMin&&step<1000
    [xstar,fstar,activeEdges]=fminOnMeshFace(fun,opPoints(address(opIndices==startVertex),:),opPoints);
    
    %the result can be on a vertex, on an edge, or in the middle of a face
    if sum(activeEdges)==2 %vertex
        if sum(activeEdges==[1 1 0])==3
            activeVertex=opIndices(2);
        elseif sum(activeEdges==[0 1 1])==3
            activeVertex=opIndices(3);
        else
            activeVertex=opIndices(1);
        end
        
        %remove the vertex on that face from remaining options
        remainingOptions(opFace,remainingOptions(opFace,:)==activeVertex)=0;
        nextFaces=findFace([activeVertex],remainingOptions);
        if numel(nextFaces)==0
            atMin=true;
        else
            %setup options for next optimization
            opFace=nextFaces(1);
            opIndices=indices(opFace,:);
            opPoints=points(opIndices,:);
            startVertex=closestVertex(points(activeVertex,:),opIndices,opPoints);
        end
        
    elseif sum(activeEdges)==1 %edge
        activeEdgeIndices=opIndices(address(activeEdges));
        
        nextFaces=findFace(activeEdgeIndices,indices);
        if numel(nextFaces)<2%if there aren't two faces that share that edge it is a boundary
            atMin=true;
        else
            
            %setup options for next optimization
            opFace=nextFaces(1);
            opIndices=indices(opFace,:);
            opPoints=points(opIndices,:);
            startVertex=closestVertex(points(activeVertex,:),opIndices,opPoints);
        end
    elseif sum(activeEdges)==0 %middle
        atMin=true;
    else
        error('invalid no. of active edges in optimization result');
    end
    
    step=step+1;
end %while end

end

function index=closestVertex(activePoint,nextIndices,nextPoints)

dist=zeros(1,size(nextIndices,1));
for i=1:length(nextIndices)
    dist(i)=norm(activePoint-nextPoints(i,:));
end

[~,I]=min(dist);
index=nextIndices(I(1));

end
