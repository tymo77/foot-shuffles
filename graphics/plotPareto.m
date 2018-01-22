function plotPareto(paretoFront)

figure
hold on
p=scatter(paretoFront(:,1),paretoFront(:,2),150,'kx');
p.LineWidth=3;
p=plot(paretoFront(:,1),paretoFront(:,2),'k--');
p.LineWidth=2;
xlim([0 4]);
xlabel('Number of steps in shuffle')
ylabel('Optimum final stability')
xticks([0 1 2 3 4]);
grid on;

end