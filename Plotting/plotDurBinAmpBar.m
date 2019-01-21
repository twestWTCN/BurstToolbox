function plotDurBinAmpBar(R,BB)
data{1} = {BB.Seg_binAmpData{:,1}}; 
data{2} = {BB.Seg_binAmpData{:,2}}; 

pvec = pvec_bin_TTest(data);
barplot160818(R,BB.binAmp,squeeze(BB.Seg_binAmp(:,:,:)),pvec,0,1);
title('Burst Duration by Amplitude')
xlabel('Mean Amplitude'); ylabel('Wghtd. Duration (ms)'); ylim([0 200]); % ylim([BB.range.Amp(1) BB.range.Amp(end)]);
