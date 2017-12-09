function [alphamin, alpha, aNorm, Ivector, fStar, p, pc]=angularStabilityMargin(pc, pAll, fResult, nResult)
%Takes a given robot state for the position of the center of mass
%and the foot positions in contact with the ground and computes the
%angular stability margin
%output: angular stability margin,
%angular stability for all un tripped tipping modes,
%the tipover modes, tipover normals

p = convexSupportPattern(pAll);%determine the convex CCW orderind of p
numberOfContactPoints = length(p); %initialize the number of contact points based

%Tipover Mode Axes
a=circshift(p,-1)-p;
aNorm = normr(a);

%pre-allocate
Ivector=zeros(numberOfContactPoints,3);

for i=1:numberOfContactPoints-1
    %Tipover Axis Normals
    Ivector(i,:) = (eye(3) - transpose(aNorm(i,:))*aNorm(i,:))*(p(i + 1,:) - pc)';
end
Ivector(numberOfContactPoints,:) =(eye(3) - transpose(aNorm(numberOfContactPoints,:))*aNorm(numberOfContactPoints,:))*(p(1,:) - pc)';

%pre-allocate
temp=zeros(numberOfContactPoints,3);f=temp;n=temp;fstar=temp;fstarNorm=temp;
th=zeros(numberOfContactPoints,1);alpha=th;

for i=1:numberOfContactPoints
    %Useful Force and Moment Components
    f(i,:) = (eye(3) - transpose(aNorm(i,:))*aNorm(i,:))*fResult';
    n(i,:) = (transpose(aNorm(i,:))*aNorm(i,:))*nResult';
    
    %New Net Force Vector for the Tipover Axes
    fStar(i,:) = f(i,:) + cross(normr(Ivector(i,:)), n(i,:))/norm(Ivector(i,:));
    fStarNorm(i,:) = normr(fStar(i,:));
    
    %Force-Angle Stability Measure Candidate Angles
    if cross(normr(Ivector(i,:)), fStarNorm(i,:))*aNorm(i,:)' < 0
        sigma = 1;
    else
        sigma = -1;
    end
    th(i)=sigma*acos(fStarNorm(i,:)*normr(Ivector(i,:))');
    
    %Angular Stability Margin
    alpha(i) = th(i)*norm(fResult);
end

alphamin = min(alpha);
end

function sortedVertices=convexSupportPattern(p)

%Takes a given robot support pattern and provides the subset that forms the convex hull for the anti-
%clockwise loop according to the RHR for the universal frame's z*)

stripped = p(:,1:2); %takes the x-y of all points
C = sum(stripped) / size(stripped, 1);
dv = bsxfun(@minus, stripped, C);
a = atan2(dv(:,2), dv(:,1)) + pi;
[~,si] = sort(a);
sortedVertices = p(flip(si), :);

end