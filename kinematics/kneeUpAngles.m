function optiAngles=kneeUpAngles(jointAngles,legNo,robot)

psol1=jointPositions(jointAngles(1,:),legNo,robot);
psol2=jointPositions(jointAngles(2,:),legNo,robot);

if psol2(2,3)>psol1(2,3)
    optiAngles=jointAngles(1,:);
else
    optiAngles=jointAngles(2,:);
end
end