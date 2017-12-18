function regions=buildAllRegions(minAngles,maxAngles,N,surface,robot)

if all((surface~='wave')&(surface~='flat'))
    error('not valid surface')
end

regions=struct('no',{1,2,3,4});

mesh=generateMesh(1,deg2rad(minAngles(1,:)),deg2rad(maxAngles(1,:)),N,surface,...
    10,robot);
regions(1).mesh=mesh;

mesh=generateMesh(2,deg2rad(minAngles(2,:)),deg2rad(maxAngles(2,:)),N,surface,...
    10,robot);
regions(2).mesh=mesh;

mesh=generateMesh(3,deg2rad(minAngles(3,:)),deg2rad(maxAngles(3,:)),N,surface,...
    10,robot);
regions(3).mesh=mesh;

mesh=generateMesh(4,deg2rad(minAngles(4,:)),deg2rad(maxAngles(4,:)),N,surface,...
    10,robot);
regions(4).mesh=mesh;
end
