function BB = getBurstPeakFrqs(R,CSD,BB)
% computes the frequencies for the burst frequencies
% CSD.frq = list of Hz; CSD.CSD = 2x2 cross spectra (symmetric)
if nargin<3
    BB = [];
end
bind = find(CSD.frq >= R.bandef(2,1) &  CSD.frq <= R.bandef(3,2)); % Find the beta range (B1 and B2)
[pm,pi] = max(CSD.normpow(2,bind)); % Find the peak in the STN power spectra
bind = find(CSD.frq >= R.bandef(2,1) &  CSD.frq <= R.bandef(3,2)); % Find the beta range (B1 and B2)
[cm,ci] = max(CSD.coh(1,bind));     % Find the peak in the STN/SMA coh spectra
BB.powfrq = CSD.frq(bind(pi));
BB.cohfrq = CSD.frq(bind(ci));