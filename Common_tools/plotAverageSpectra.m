function ax = plotAverageSpectra(frq,fx,cmap,xl)
ax = plot(frq,mean(fx,2),'color',cmap);
ax.LineWidth = 1.5;
xlim(xl)
hold on