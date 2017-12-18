function displayRegions(regions)

figure
hold on
for n=1:4
trisurf(regions(n).mesh.tri,regions(n).mesh.points(:,1),regions(n).mesh.points(:,2),regions(n).mesh.points(:,3))
end
axis equal

end