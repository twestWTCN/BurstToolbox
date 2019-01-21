function plotBurstAmpDurScatter(R,BB,condsel)
if nargin<3
    condsel = 1:2;
end
for cond = condsel
    sp(cond) = scatter(log10(BB.segA_save{cond}),log10(BB.segL_t_save{cond}),25,R.condcmap(cond,:),'filled'); hold on
    sp(cond).MarkerFaceAlpha = 0.7;
    [xCalc yCalc b Rsq] = linregress(log10(BB.segA_save{cond})',log10(BB.segL_t_save{cond})',0);
    plot(xCalc,yCalc,'color',R.condcmap(cond,:),'LineWidth',2); %ylim(BB.plot.lims.Dur); xlim(BB.plot.lims.Amp)
end

legend(sp(condsel),{R.condname{condsel}},'Location','NorthEast'); xlabel('log_{10} Burst Amplitude'); ylabel('log_{10} Burst Duration (ms)');
% xlim(BB.plot.lims.Amp); ylim([BB.plot.lims.Dur]);
box off
title('Burst Amplitude vs Duration ');
BB.stats.AmpCond = statvec(BB.segA_save,BB.segL_t_save,2);
