function [specstat] = spectralClusterStats(ON,OFF,fxA,labs,nrnd)
if size(fxA,1)>size(fxA,2)
    fxA = fxA';
end
freqON.label = {labs}; %R.subnames{1}';
freqON.dimord = 'subj_chan_freq';
% freqON.label = {['fEEG ' R.sourcenames{srcloc}]}
freqON.freq = fxA;
freqON.powspctrm = reshape(ON,size(ON,1),1,size(ON,2));

freqOFF.label = {labs}; %R.subnames{1}';
freqOFF.dimord = 'subj_chan_freq';
% freqON.label = {['fEEG ' R.sourcenames{srcloc}]}
freqOFF.freq = fxA;
freqOFF.powspctrm = reshape(OFF,size(OFF,1),1,size(OFF,2));

clear design
% design(1,:) = 1:size(OFF,1)+size(ON,1); 
% design(1,:) = repmat(1:size(ON,1),1,2);
% design(2,1:size(OFF,1)) = zeros(1,size(OFF,1));
% design(2,size(OFF,1)+1:size(OFF,1)+size(ON,1)) = repmat(1,1,size(ON,1));

design(1,:) = [1:size(OFF,1) 1:size(ON,1)] ;
design(2,1:size(OFF,1)) = ones(1,size(OFF,1));
design(2,size(OFF,1)+1:size(OFF,1)+size(ON,1)) = repmat(2,1,size(ON,1));

% powspctrm: [20x145 double]
cfg = [];
cfg.method = 'montecarlo';
cfg.design =design;
cfg.frequency = [4 48];
cfg.correctm         = 'cluster';
cfg.clusteralpha     = 0.2;
cfg.clusterstatistic = 'maxsum';
cfg.statistic        = 'ft_statfun_indepsamplesT';
cfg.alpha            = 0.05;
cfg.tail        = 0; % two-sided test
cfg.correcttail = 'alpha';
cfg.numrandomization = nrnd;
cfg.ivar     = 2;
cfg.design = design;
[specstat] = ft_freqstatistics(cfg, freqOFF, freqON);
