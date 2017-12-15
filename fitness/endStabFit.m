function endstab=endStabFit(points,order,initialPos,pc,f,n)

[stability,~,~]=shuffleFitness(points,order,initialPos,pc,f,n);
endstab=stability(end);

end