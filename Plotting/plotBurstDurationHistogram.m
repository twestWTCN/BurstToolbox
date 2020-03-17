function h = plotBurstDurationHistogram(R,BB,condsel)
if ~isfield(R,'condcmap')
    R.condcmap = jet(max(condsel));
end
% if isfield(R,'condnames')
%     R.condname = R.condnames;
% end
if nargin<3
    condsel = 1:size(BB.AEnv,2);
end
% Plots Histogram of Burst Durations normalized by series duration
% (burst/s)

for cond = condsel
    h(cond) = rateLogHistogram(BB.segDur{cond},BB.range.Dur,diff(BB.Tvec{cond}([1 end]))/60,0); hold on
    h(cond).FaceColor = R.condcmap(cond,:);
    h(cond).FaceAlpha = 0.75;
    %         a = gca;
    %         a.XTick = round( a.XTick(1:2:end) / 10) * 10;
    
%     if cond == 2
%         statv =statvec((BB.segDur{1}),(BB.segDur{2}),1);
%         txtlab = [sprintf('OFF-ON: %.1f [%0.1f %0.1f] ',statv(end-3:end-1)) ' (' textstar(statv(end),0.05) ')'];
%         TS = text(35,13, txtlab); TS.FontWeight = 'bold'; TS.FontSize = 7; TS.FontWeight = 'bold';
%     end
end
legend({R.condname{condsel}},'Location','NorthEast');
 ylabel('Frequency (min^{-1})'); xlabel('log_{10} Burst Duration (ms)');
 xlim(BB.plot.lims.Dur); ylim(BB.plot.lims.burfreq(1,:)); box off
title('Burst Duration Distribution'); %ylim(BB.plot.lims.burfreq )
% BB.stats.DurCond  = statvec(BB.segDur{1},BB.segDur{1},1);

