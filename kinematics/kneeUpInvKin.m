function [optiAngles,flags]=kneeUpInvKin(px, py, pz, LegNo, robot)

[angles,flags]=computeInverseKinematics(px, py, pz, LegNo, robot);

optiAngles=kneeUpAngles(angles,LegNo,robot);


end