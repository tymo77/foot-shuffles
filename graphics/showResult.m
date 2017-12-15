function showResult(xstar,order,init,regions,robot,fResult,nResult)

figure
hold on
for n=1:4
    trisurf(regions(n).mesh.tri,regions(n).mesh.points(:,1),regions(n).mesh.points(:,2),regions(n).mesh.points(:,3))
end
axis equal

xyzstar=postProcess(xstar,regions);
[stability,interstability,~]=shuffleFitness(xyzstar,order,init,robot.bodyPos,fResult,nResult);
N=length(stability);
n=(0:N-1)';

fprintf(['\tStep No.' '  Stab.' '\t  Inter. Stab.\n']);
disp([n stability [interstability; NaN]]);

p=scatter3(xyzstar(:,1),xyzstar(:,2),xyzstar(:,3)+.1,100,'rx');
p.LineWidth=2;

end