function [h,l] = plotBurstAmplitudeHistogram(R,BB,condsel)
if nargin<3
    condsel = 1:size(BB.A,2);
end
% Plots Histogram of Burst Amplitudes normalized by series duration
% (burst/s)
for cond = condsel
    h(cond) = rateLogHistogram(BB.segA_save{cond},BB.binAmp,diff(BB.DTvec{cond}([1 end]))/60); hold on
    h(cond).FaceColor = R.condcmap(cond,:);
    h(cond).FaceAlpha = 0.75;
    
%     if cond == 2
%         statv =statvec(BB.segA_save{1},BB.segA_save{2},1);
%         txtlab = [sprintf('OFF-ON: %.1f [%0.1f %0.1f] ',statv(end-3:end-1)) ' (' textstar(statv(end),0.05) ')'];
%         TS = text(5,9.5, txtlab); TS.FontWeight = 'bold'; TS.FontSize = 7; TS.FontWeight = 'bold';
%     end
end

l = legend({R.condname{condsel}},'Location','NorthEast'); ylabel('Frequency (min^{-1})'); xlabel('log_{10} Amplitude');  xlim(BB.plot.lims.Amp); ylim([0 15]); box off
title('Burst Amplitude Distribution'); 
BB.stats.AmpCond = statvec(BB.segA_save{1},BB.segA_save{2},1);
