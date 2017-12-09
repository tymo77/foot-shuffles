function [feasiblePts,mask]=filterPtsByInvKin(pts,minAngles,maxAngles,WBody, LBody, LProximal, LDistal, LegNo)

if length(minAngles)==1
    minAngles=[minAngles minAngles minAngles];
end

if length(maxAngles)==1
    maxAngles=[maxAngles maxAngles maxAngles];
end

nPts=size(pts,1);
mask=zeros(nPts,1);
for i=1:nPts
    mask(i)=testPoint(pts(i,:));
end

feasiblePts=pts(logical(mask),:);


    function feasible=testPoint(p)
        px=p(1);py=p(2);pz=p(3);
        [angles,flags]=computeInverseKinematics(px, py, pz, WBody, LBody, LProximal, LDistal, LegNo);
        angles=mapAngleAroundZero(angles);
        minAngles=mapAngleAroundZero(minAngles);
        maxAngles=mapAngleAroundZero(maxAngles);
        
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
end

function thMapped=mapAngleAroundZero(th)

th=th/pi;
th=mod(th+1,2)-1;
thMapped=th*pi;

end

