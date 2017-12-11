function [xstar,fstar,activeEdges]=fminOnMeshFace(fun,startPoint,vertexPts)
p1=vertexPts(1,:)';p2=vertexPts(2,:)';p3=vertexPts(3,:)';
warning('off','MATLAB:rankDeficientMatrix');

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
maxy=max([x2(2) x3(2) 0]);
miny=min([x2(2) x3(2) 0]);

A=[-x2(2) x2(1);x3(2) -x3(1)];
b=[0;0];

%A and b are such that Ax<=b and M and d are such that u=Mx+d
ub=[1 maxy];
lb=[0 miny];

%function mapped to 2d domain
fmapped=@(x) fun(M*x+d);

%optimization
opts = optimoptions(@fmincon,'Display','off');
ystar=fmincon(fmapped,M\(startPoint'-d),A,b,[],[],lb,ub,[],opts);
xstar=M*ystar+d;
fstar=fun(xstar);

%check if any vertices are better

 for i=1:size(vertexPts,1)
     if fun(vertexPts(i,:))<fstar
        xstar=vertexPts(i,:)';
        fstar=fun(vertexPts(i,:));
        ystar=M\(xstar-d);
     end
 end

%check boundary
edgDist13=-A*ystar;
edgDist2=(1-ystar(1));
edgDists=[edgDist13(1) edgDist2 edgDist13(2)];
activeEdges=edgDists < 1*10^-5;
end
