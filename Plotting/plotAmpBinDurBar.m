function plotAmpBinDurBar(R,BB)

barplot160818(R,BB.binDur,squeeze(BB.Amp_binDur(:,:,:)),pvec,0,1)
title('Burst Amplitude by Duration')
xlabel('Duration (ms)'); ylabel('Wghtd. Amplitude'); ylim([0 5]); %ylim([BB.range.Amp(1) BB.range.Amp(end)]);
