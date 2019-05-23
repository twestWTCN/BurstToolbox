function [ax,hp] = plotAverageBoundedSpectra(frq,fx,cmap,xl)
[ax,hp] = boundedline(frq,mean(fx,2),std(fx,0,2)./sqrt(size(fx,2)),'cmap',cmap,'alpha','transparency',0.8); %std(ON,0,2)/sqrt(size(ON,2))
ax(1).LineWidth = 1.5;
xlim(xl)
hold on