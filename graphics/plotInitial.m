function plotInitial(init)

p=scatter3(init(:,1),init(:,2),init(:,3)+.07,100,'ko');
p.LineWidth=5;
p=scatter3(init(:,1),init(:,2),init(:,3)+.1,100,'wo');
p.LineWidth=2;

end