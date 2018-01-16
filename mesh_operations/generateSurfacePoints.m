function pts=generateSurfacePoints(N,xbnds,ybnds,type)

x=linspace(xbnds(1),xbnds(2),N);
y=linspace(ybnds(1),ybnds(2),N);

[X,Y]=meshgrid(x,y);

if type=='wave'
    Z=1/3*sin(2*X).*sin(2*Y+pi);
elseif type=='flat'
    Z=0*X;
else
    error('must specify a valid surface type')
end

sx=reshape(X,[N*N,1]);
sy=reshape(Y,[N*N,1]);
sz=reshape(Z,[N*N,1]);

pts=[sx sy sz];

end