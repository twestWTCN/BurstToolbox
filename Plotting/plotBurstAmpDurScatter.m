function plotBurstAmpDurScatter(R,BB,condsel)
if ~isfield(R,'condcmap')
    R.condcmap = jet(numel(condsel));
end
% if isfield(R,'condnames')
%     R.condname = R.condnames;
% end
if nargin<3
    condsel = 1:size(BB.AEnv,2);
end
if nargin<3
    condsel = 1:2;
end
for cond = condsel
    if BB.plot.durlogflag 
        A = (BB.segAmp{cond});
        B = log10(BB.segDur{cond});
    else
        A = (BB.segAmp{cond});
        B = (BB.segDur{cond});
    end
    sp(cond) = scatter(A,B,25,R.condcmap(cond,:),'filled'); hold on
    sp(cond).MarkerFaceAlpha = 0.7;
    [xCalc yCalc b Rsq] = linregress(BB.segAmp{cond}',BB.segDur{cond}');
    plot(xCalc,yCalc,'color',R.condcmap(cond,:),'LineWidth',2); ylim(BB.plot.lims.Dur); xlim(BB.plot.lims.Amp)
end

legend(sp(condsel),{R.condname{condsel}},'Location','NorthEast'); 
xlabel('log_{10} Burst Amplitude'); ylabel('log_{10} Burst Duration (ms)');
% xlim(BB.plot.lims.Amp); ylim([BB.plot.lims.Dur]);
box off
title('Burst Amplitude vs Duration ');
BB.stats.AmpCond = statvec(BB.segAmp{cond}',BB.segDur{cond}',2);
