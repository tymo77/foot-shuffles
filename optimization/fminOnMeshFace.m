function [xstar,fstar]=fminOnMeshFace(fun,vertexPts)
p1=vertexPts(1);p2=vertexPts(2);p3=vertexPts(3);

%vectors along edges
v23=p3-p2;
v21=p2-p1;
v31=p3-p1;

%surface normal
n=cross(v31,v21);

%triangle width and height (orthogonal vectors)
vw=-v23;
vh=cross(n,v23);

vwHat=normc(vw);
vhHat=normc(vh);

h=v21'*vhHat;
w=norm(v23);

%basis for the face along width and height of triangle
vw=vwHat*w;
vh=vhHat*h;
M=[vh vw];
d=p1;

%vertices in 2d space after inverse transformation by basis
x2=M\(p2-d);
x3=M\(p3-d);

A=[x3(2) -x3(1);-x2(2) x2(1)];
b=[0;0];

%A and b are such that Ax<=b and M and d are such that u=Mx+d
ub=[1 1];
lb=[0,-1];

%function mapped to 2d domain
fmapped=@(x) fun(M*x+d);

%optimization
xstar=fmincon(fmapped,[0;0],A,b,[],[],lb,ub);
xstar=M*xstar+d;
fstar=fun(xstar);
end
