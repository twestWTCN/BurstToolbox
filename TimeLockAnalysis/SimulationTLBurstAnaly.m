function SimulationTLBurstAnaly(R,BB,xsimMod,AS)
addpath(R.BBA_path)

PLVcmp = 0;
close all
F(1) = figure; F(2) = figure; F(3) = figure; F(4) = figure; F(5) = figure;
BurstTimeLockAnalysis_SortByLength(R,1,BB,1,F);
for i = 1:4
figure(F(i));
title(R.condname{1});
end
%
BurstTimeLockAnalysis_SortByLength(R,2,BB,1,F);
for i = 1:4
figure(F(i));
title(R.condname{2});
end
%
% BurstTimeLockAnalysis_SortByLength(R,3,BB,1,F);
% for i = 1:4
% figure(F(i));
% title(R.condname{3});
% end
set(F(1),'Position',[374.0000  258.5000  894.5000  620.0000])
set(F(2),'Position',[374.0000  88.0000   894.5000  224.0000])
set(F(3),'Position',[374.0000  88.0000   894.5000  224.0000])
set(F(4),'Position',[374.0000  88.0000   894.5000  224.0000])
set(F(5),'Position',[374.0000  88.0000   894.5000  224.0000])

F(6) = figure;
for cond = 1:size(AS,2)
    subplot(1,3,cond)
    for struc = 1:4
        plot(R.frqz,AS{cond}(struc,:),'color',BB.struccmap(struc,:),'LineWidth',2); hold on
    end
    xlabel('Frequency (Hz)'); ylabel('Amplitude')
    title(R.condname{cond}); grid on
end
set(F(6),'Position',[374.0000  88.0000   894.5000  224.0000])
