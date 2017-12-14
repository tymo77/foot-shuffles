function fitness=fitnessWeighting(points,order,initialPos,pc,f,n)

[stability,interstability,~]=shuffleFitness(points,order,initialPos,pc,f,n);

fitness=min(stability)+min(interstability)+mean(stability)+mean(interstability);

end

