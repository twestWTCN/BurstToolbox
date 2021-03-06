function [p sc] = plotPRCSumStats(conStren,maxz,minz,ranz,NcS_sel,cmap)

p(1) = plot(conStren,maxz);
p(1).LineStyle = '--';
p(1).LineWidth = 2;
p(1).Color = [0 0 0]; %cmap(12,:);
hold on
sc(1) = scatter(conStren(NcS_sel),maxz(NcS_sel),75,cmap(NcS_sel,:),'filled');
sc(1).Marker = 'o';

p(2) = plot(conStren,minz);
p(2).Color = [0 0 0]; %cmap(12,:);
p(2).LineWidth = 2;
p(2).LineStyle = '-.';
hold on
sc(2) = scatter(conStren(NcS_sel),minz(NcS_sel),75,cmap(NcS_sel,:),'filled');
sc(2).Marker = 'square';

% p(3) = plot(conStren.*100,ranz);
% p(3).Color = cmap(12,:);
% p(3).LineWidth = 2;
% p(3).LineStyle = '-';
% hold on
% sc(3) = scatter(conStren(NcS_sel).*100,ranz(NcS_sel),50,cmap(NcS_sel,:),'filled');
% sc(3).Marker = 'o';

grid on
xlabel('% fitted connection strength')
ylabel('% Change in Beta Power')
ylim([-100 400])
