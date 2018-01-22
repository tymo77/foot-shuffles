function plotStability(interstability,stability)
allstab=[];
for i=1:2*length(stability)-1
    if mod(i,2)==1
        allstab=[allstab stability(floor(i/2)+1)];
    else
        allstab=[allstab interstability(floor(i/2))];
    end
end

figure
hold on
p1=plot(0:.5:length(interstability),allstab,'k--');
p2=plot(0:1:length(stability)-1,stability,'kx');
p3=plot(.5:1:length(interstability)-.5,interstability,'ko');
p2.MarkerSize=12;
p3.MarkerSize=9;
p1.LineWidth=2;
p2.LineWidth=2;
p3.LineWidth=2;
grid on
xticks(0:length(stability)-1)
xlabel('Step Number')
ylabel('Angular stability margin')

legend([p2 p3],'Stability after step','Stability during step','Location','northwest')
end