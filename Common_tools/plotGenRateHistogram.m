function [h,statV] = plotGenRateHistogram(binY,binX,Tvec,pcfg)
% Plots Histogram of Burst Durations normalized by series duration
% (burst/s)
colormap(pcfg.condcmap)

for cond = pcfg.condsel
    if numel(Tvec{cond})>1
        tottime = diff(Tvec{cond}([1 end]))/60;
    else
        tottime = Tvec{cond};
    end
    h(cond) = rateHistogram(binY{cond},binX,tottime,pcfg.logflag);
    hold on
    h(cond).FaceColor = pcfg.condcmap(cond,:);
    h(cond).FaceAlpha = 0.75;
    %         a = gca;
    %         a.XTick = round( a.XTick(1:2:end) / 10) * 10;
end
statV =statvec(binY{1},binY{2},1);
txtlab = [sprintf('OFF-ON: %.1f [%0.1f %0.1f] ',statV(end-3:end-1)) ' (' textstar(statV(end),0.05) ')'];
TS = text(35,13, txtlab); TS.FontWeight = 'bold'; TS.FontSize = 7; TS.FontWeight = 'bold';


legend(pcfg.legcont,'Location',pcfg.legloc);
ylabel(pcfg.ylabel);
xlabel(pcfg.xlabel);
xlim(pcfg.xlim); ylim(pcfg.ylim);
title(pcfg.title); %ylim(BB.plot.lims.burfreq )
box off


