function fval=meshPenalty(f,xy,p,varargin)
Nregions=length(varargin);

if Nregions ~= size(xy,1)
    error('no. of mesh regions passed does not match no. of points');
end
xyzmesh=zeros(Nregions,3);
dists=zeros(Nregions,1);

for i=1:Nregions
    xyzint=xyMeshIntercept(xy(i,:), varargin{i}.vertPt1, varargin{i}.vertPt2, varargin{i}.vertPt3);
    if numel(xyzint)==0
        [dists(i),xyzmesh(i,:)]=distanceFromEdge(xy(i,:),varargin{i}.extEdges,varargin{i}.points);
    else
        xyzmesh(i,:)=xyzint;
    end
    

end

fval=sum(sum(f(xyzmesh)+dists.^p));

end