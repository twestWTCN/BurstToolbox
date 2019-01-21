function h = plotBurstDurationHistogram(R,BB)
% Plots Histogram of Burst Durations normalized by series duration
% (burst/s)
for cond = 1:size(BB.A,2)
    h(cond) = rateHistogram(BB.segL_t_save{cond},BB.range.segDur,diff(BB.DTvec{cond}([1 end]))/60,0); hold on
    h(cond).FaceColor = R.condcmap(cond,:);
    h(cond).FaceAlpha = 0.8;
    %         a = gca;
    %         a.XTick = round( a.XTick(1:2:end) / 10) * 10;
    
    if cond == 2
        statv =statvec((BB.segL_t_save{1}),(BB.segL_t_save{2}),1);
        txtlab = [sprintf('OFF-ON: %.1f [%0.1f %0.1f] ',statv(end-3:end-1)) ' (' textstar(statv(end),0.05) ')'];
        TS = text(35,13, txtlab); TS.FontWeight = 'bold'; TS.FontSize = 7; TS.FontWeight = 'bold';
    end
end
legend(R.condname,'Location','NorthEast'); ylabel('Frequency (min^{-1})'); xlabel('log_{10} Burst Duration (ms)'); xlim(BB.plot.lims.Dur); %ylim([0 15]); box off
title('Burst Duration Distribution'); ylim(BB.plot.lims.burfreq )
BB.stats.DurCond  = statvec(BB.segL_t_save{1},BB.segL_t_save{2},1);

