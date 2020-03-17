function [p sc] = plotPRC_phases(conStren,Sphasez,PSphasez,NcS_sel,cmap)

p(1) = plot(conStren.*100,Sphasez );
p(1).Color = [0 0 0];
p(1).LineWidth = 2;
p(1).LineStyle = '-';
hold on
sc(1) = scatter(conStren(NcS_sel).*100,Sphasez(NcS_sel),75,cmap(NcS_sel,:),'filled');
sc(1).Marker = '^';

p(2) = plot(conStren.*100,PSphasez );
p(2).Color = [0 0 0];
p(2).LineWidth = 2;
p(2).LineStyle = '-.';
hold on
sc(2) = scatter(conStren(NcS_sel).*100,PSphasez(NcS_sel),75,cmap(NcS_sel,:),'filled');
sc(2).Marker = 'v';

grid on
a = gca;
a.YTick = ([0 pi/2 pi 3*pi/2 2*pi]);
ylim([0 2*pi])
ylabel('Phase')
xlabel('Connection Strength (K)')

