function xyz=postProcess(xystar,regions,legNo)

xyz=zeros(size(legNo,1),3);
for i=1:length(legNo)
    leg=legNo(i);
    intPt=xyMeshIntercept(xystar(i,:),regions(leg).mesh.vertPt1,regions(leg).mesh.vertPt2,regions(leg).mesh.vertPt3);
    
    if numel(intPt)==0
        [dist,xyz(i,:)]=distanceFromEdge(xystar(i,:),regions(leg).mesh.extEdges,regions(leg).mesh.points);

        if dist>.001
            warning(['step ' num2str(i) ' was outside the mesh by ' num2str(dist)])
        end
    else
        xyz(i,:)=intPt;
    end
end
end