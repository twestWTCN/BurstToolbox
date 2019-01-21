function plotAmpBinDurBar(R,BB)
data{1} = {BB.Amp_binDurData{:,1}}; 
data{2} = {BB.Amp_binDurData{:,2}}; 
pvec = pvec_bin_TTest(data);
barplot160818(R,BB.binDur,squeeze(BB.Amp_binDur(:,:,:)),pvec,0,1)
title('Burst Amplitude by Duration')
xlabel('Duration (ms)'); ylabel('Wghtd. Amplitude'); ylim([0 5]); %ylim([BB.range.Amp(1) BB.range.Amp(end)]);
