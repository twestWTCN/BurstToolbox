function [h,l] = plotBurstAmplitudeDurationHistogram(R,BB,condsel,cmap,cntlevs)
if ~isfield(R,'condcmap')
    R.condcmap = jet(max(condsel));
end
% if isfield(R,'condnames')
%     R.condname = R.condnames;
% end
if nargin<3
    condsel = 1:size(BB.A,2);
end
% Plots Histogram of Burst Amplitudes normalized by series duration
% (burst/s)
p = 0;
for cond = condsel
    p = p + 1;
    subplot(3,3,(3*p)-1)
    %     h = rateLogHistogram2D([BB.segAmp{cond};BB.segDur{cond}],[BB.range.Amplr; BB.range.Durlr],diff(BB.Tvec{cond}([1 end]))/60);
    h = rateContour2D([BB.segAmp{cond};BB.segDur{cond}],[BB.range.Amplr; BB.range.Durlr],diff(BB.Tvec{cond}([1 end]))/60,cntlevs,cmap);

    xlabel('Amplitude'); ylabel('log_{10} Duration (ms)')
    hold on
end
A_cell = cellstr(num2str(BB.range.Amplr,'%f.3'));

xlim(BB.plot.lims.Amp); box off
% title('Burst Amplitude Distribution');

l = [];
