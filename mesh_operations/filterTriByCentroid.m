function [feasibleTri,mask]=filterTriByCentroid(triIndices,pts,...
    minAngles,maxAngles,LegNo,robot)

if length(minAngles)==1
    minAngles=[minAngles minAngles minAngles];
end

if length(maxAngles)==1
    maxAngles=[maxAngles maxAngles maxAngles];
end

nTri=size(triIndices,1);
mask=zeros(nTri,1);
for i=1:nTri
    mask(i)=testPoint(mean(pts(triIndices(i,:),:)),minAngles,maxAngles,LegNo,robot);
end

feasibleTri=triIndices(logical(mask),:);



end

function feasible=testPoint(p,minAngles,maxAngles,LegNo,robot)
px=p(1);py=p(2);pz=p(3);
[angles,flags]=computeInverseKinematics(px, py, pz, LegNo, robot);

angles=[mapAngle1AroundZero(angles(:,1)) mapAngleAroundZero(angles(:,2:3))];
minAngles=[mapAngle1AroundZero(minAngles(1)) mapAngleAroundZero(minAngles(2:3))];
maxAngles=[mapAngle1AroundZero(maxAngles(1)) mapAngleAroundZero(maxAngles(2:3))];

sol1Check=(minAngles(1) <= angles(1,1) && angles(1,1) <= maxAngles(1)) &&...
    (minAngles(2) <= angles(1,2) && angles(1,2) <= maxAngles(2)) &&...
    (minAngles(3) <= angles(1,3) && angles(1,3) <= maxAngles(3));

sol2Check=(minAngles(1) <= angles(2,1) && angles(2,1) <= maxAngles(1)) &&...
    (minAngles(2) <= angles(2,2) && angles(2,2) <= maxAngles(2)) &&...
    (minAngles(3) <= angles(2,3) && angles(2,3) <= maxAngles(3));

if (sol1Check && ~logical(flags(1))) || (sol2Check && ~logical(flags(2)))
    feasible=1;
else
    feasible=0;
end

end

function thMapped=mapAngleAroundZero(th)

th=th/pi;
th=mod(th+1,2)-1;
thMapped=th*pi;

end

function thMapped=mapAngle1AroundZero(th)

th=th/pi;
th=mod(th+.5,2)-.5;
thMapped=th*pi;

end


