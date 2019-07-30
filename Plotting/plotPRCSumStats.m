function [p sc] = plotPRCSumStats(conStren,maxz,minz,ranz,NcS_sel,cmap)

p(1) = plot(conStren.*100,maxz);
p(1).LineStyle = '-.';
hold on
sc(1) = scatter(conStren(NcS_sel).*100,maxz(NcS_sel),50,cmap(NcS_sel,:),'filled');
sc(1).Marker = 'diamond';
p(2) = plot(conStren.*100,minz);
p(2).LineStyle = '--';
hold on
sc(2) = scatter(conStren(NcS_sel).*100,minz(NcS_sel),50,cmap(NcS_sel,:),'filled');
sc(2).Marker = 'square';

p(3) = plot(conStren.*100,ranz);
p(3).LineStyle = '-';
hold on
sc(3) = scatter(conStren(NcS_sel).*100,ranz(NcS_sel),50,cmap(NcS_sel,:),'filled');
sc(3).Marker = 'o';

