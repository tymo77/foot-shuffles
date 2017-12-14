function xyz=postProcess(xystar,regions,legNo)

 if ~exist('legNo','var')
     legNo=[1 2 3 4];
 end


xyz=zeros(size(legNo,1),3);
for i=1:length(legNo)
    leg=legNo(i);
    intPt=xyMeshIntercept(xystar(leg,:),regions(leg).mesh.vertPt1,regions(leg).mesh.vertPt2,regions(leg).mesh.vertPt3);
    
    if numel(intPt)==0
        [dist,xyz(leg,:)]=distanceFromEdge(xystar(leg,:),regions(leg).mesh.extEdges,regions(leg).mesh.points);

        if dist>.001
            warning(['point ' num2str(leg) ' was outside the mesh by' num2str(dist)])
        end
    else
        xyz(leg,:)=intPt;
    end
end
end