function [points,order]=randomShuffle(initpos,regions,robot,n,fResult,nResult,threshStab)

x=initpos;
threshLegDist=.1;

%calculate initial stability
initstab=angularStabilityMargin(robot.bodyPos, initpos, fResult, nResult);

%if no stability threshold, use initial stability
if ~exist('threshStab','var')
    % third parameter does not exist, so default it to something
    threshStab=initstab;
end

order=[];
points=[];
while true
    %calc moveable
    moveable=moveableLegs(x,threshStab,robot.bodyPos,fResult,nResult);
    
    %pick random moveable
    leg=moveable(randi(length(moveable)));
    
    %pick random point
    randPt=randomPoint(regions(leg).mesh);
    
    %check if it meets constraints
    [C, ~]=minStabAndLegDistConst(threshStab,threshLegDist,...
        [points; randPt(:,1:2)],[order leg],initpos,robot.bodyPos,fResult,nResult,regions,robot);
    
    %check if it meets the contraints
    if all(C<=0)
        %check if it is the same as the last leg
        if isempty(order)
            %append new step
            points=[points; randPt(:,1:2)];
            order=[order leg];
            x(leg,:)=randPt;
        elseif order(end)==leg
            %modify last step
            x(leg,:)=randPt;
            points(end,:)=randPt(:,1:2);
        else
            %append new step
            points=[points; randPt(:,1:2)];
            order=[order leg];
            x(leg,:)=randPt;
        end
    else
        continue
    end
    
    if length(order)>=n
        break
    end
end
end