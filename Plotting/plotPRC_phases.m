function [p sc] = plotPRC_phases(conStren,Sphasez,PSphasez,NcS_sel,cmap)

p(1) = plot(conStren,Sphasez );
p(1).Color = [0 0 0];
p(1).LineWidth = 2;
p(1).LineStyle = '-';
hold on
sc(1) = scatter(conStren(NcS_sel),Sphasez(NcS_sel),75,cmap(NcS_sel,:),'filled');
sc(1).Marker = '^';

p(2) = plot(conStren,PSphasez );
p(2).Color = [0 0 0];
p(2).LineWidth = 2;
p(2).LineStyle = '-.';
hold on
sc(2) = scatter(conStren(NcS_sel),PSphasez(NcS_sel),75,cmap(NcS_sel,:),'filled');
sc(2).Marker = 'v';

grid on
a = gca;
a.YTick = rad2deg(([0 pi/2 pi 3*pi/2 2*pi]));
ylim([0 360])
ylabel('Phase')
xlabel('% fitted connection strength')

