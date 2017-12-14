function optiAngles=kneeUpAngles(jointAngles,legNo,robot)

psol1=jointPositions(jointAngles(1,:),robot,legNo);
psol2=jointPositions(jointAngles(2,:),robot,legNo);

if psol2(2,3)>psol1(2,3)
    optiAngles=jointAngles(1,:);
else
    optiAngles=jointAngles(3,:);
end
end