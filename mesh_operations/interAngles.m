function angles=interAngles(points)
v21=points(2,:)'-points(1,:)';
v31=points(3,:)'-points(1,:)';
v32=points(3,:)'-points(2,:)';

angles=[acos(v21'*v31/(norm(v21)*norm(v31)))...
    acos(-v21'*v32/(norm(-v21)*norm(v32)))...
    acos(-v32'*-v31/(norm(-v32)*norm(-v31)))...
    ];


end