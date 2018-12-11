function plotBurstAmpDurScatter(R,BB)
for cond = 1:2
    sp(cond) = scatter(BB.segA_save{cond},BB.segL_t_save{cond},25,R.condcmap(cond,:),'filled'); hold on
    sp(cond).MarkerFaceAlpha = 0.7;
    plot(xCalc,yCalc,'color',R.condcmap(cond,:),'LineWidth',2); ylim(BB.plot.lims.Dur); xlim(BB.plot.lims.Amp)
end

legend(sp,R.condname,'Location','NorthEast'); ylabel('Duration (ms)'); xlabel('Amplitude'); xlim([BB.range.Amp(1) BB.range.Amp(end)]); %ylim([0 BB.range.segDur(end)]); box off
title('Burst Amplitude vs Duration ');
BB.stats.AmpCond = statvec(BB.segA_save,BB.segL_t_save,2);
