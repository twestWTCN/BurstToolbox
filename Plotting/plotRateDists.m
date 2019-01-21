function h = plotRateDists(edges,y,dur,cmap,histscat)
if histscat == 1
    h = rateHistogram(y,edges,dur); hold on
    h.FaceColor = cmap;
    h.FaceAlpha = 0.85;
    %     if cond == 3; h.FaceAlpha = 0.85; end
elseif histscat == 2
    h = rateScatter(y,edges,dur,cmap); hold on
end