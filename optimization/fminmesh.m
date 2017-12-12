function [xstarList,fstar]=fminmesh(fun,initVertex,points,indices)

remainingOptions=indices;
step=1;
atMin=false;

%find a face with the inital vertex
initFaces=findFace(initVertex,indices);
initFace=initFaces(1);

opFace=initFace;
opIndices=indices(initFace,:);
opPoints=points(opIndices,:);
startVertex=initVertex;

%start loop
while ~atMin&&step<1000
    startPoint=points(startVertex,:);
    if (norm(opPoints(1,:)-opPoints(2,:))<eps) || (norm(opPoints(1,:)-opPoints(3,:))<eps) || (norm(opPoints(2,:)-opPoints(3,:))<eps)
        xstar=startPoint;%if the face is degenerate, don't optimize - just skip
        fstar=fun(startPoint);
        
        activeVertex=opIndices==startVertex;
        if all(activeVertex==[1 0 0])
            activeEdges=[1 0 1];
        elseif all(activeVertex==[0 1 0])
            activeEdges=[1 1 0];
        else
            activeEdges=[0 1 1];
        end
    else
        [xstar,fstar,activeEdges]=fminOnMeshFace(fun,startPoint,opPoints);
    end
    
    xstarList(step,:)=xstar';
    %the result can be on a vertex, on an edge, or in the middle of a face
    if sum(activeEdges)==2 %vertex
        if all(activeEdges==[1 1 0])
            activeVertex=opIndices(2);
        elseif all(activeEdges==[0 1 1])
            activeVertex=opIndices(3);
        else
            activeVertex=opIndices(1);
        end
        
        %remove the vertex on that face from remaining options
        remainingOptions(opFace,remainingOptions(opFace,:)==activeVertex)=0;
        nextFaces=findFace(activeVertex,remainingOptions);
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
        activeEdgeIndices=activeConstToEdges(activeEdges,opIndices);
        
        nextFaces=findFace(activeEdgeIndices,remainingOptions);
        nextFaces=nextFaces(nextFaces~=opFace);%don't go to the same face again dummy
        if numel(nextFaces)==0%if there are no faces left that share that edge
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

function activeEdgeIndices=activeConstToEdges(activeEdges,opIndices)

if sum(activeEdges==[1 0 0])==3
    key=[1 2];
elseif sum(activeEdges==[0 1 0])==3
    key=[2 3];
elseif sum(activeEdges==[0 0 1])==3
    key=[1 3];
else
    error('active edge condition misidentified')
end

activeEdgeIndices=opIndices(key);
end