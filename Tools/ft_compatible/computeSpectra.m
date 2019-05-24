function TFRSpectra = computeSpectra(data)

cfg = [];
cfg.method ='mtmfft';
cfg.taper = 'dpss';
cfg.foil    = [4:98];
cfg.tapsmofrq  =2;
cfg.pad='nextpow2';
freq = ft_freqanalysis(cfg,data);

figure
for i =1:numel(data.label)
    plot(freq.freq,freq.powspctrm(i,:));
    hold on
end
legend(data.label)
    

cfg              = [];
cfg.output       = 'pow';
cfg.channel      = 'all';
cfg.method       = 'wavelet';
cfg.width      = 5;
cfg.output     = 'pow';
cfg.foi          = 4:0.5:40;                         % analysis 2 to 30 Hz in steps of 2 Hz
cfg.t_ftimwin    = ones(length(cfg.foi),1).*0.8;   % length of time window = 0.5 sec
cfg.toi          = 'all';
TFRSpectra = ft_freqanalysis(cfg, data); 

figure
for i = 1:numel(data.label)
    a(i) = subplot(numel(data.label),1,i)
    imagesc(TFRSpectra.time,TFRSpectra.freq,squeeze(TFRSpectra.powspctrm(i,:,:)));
    xlabel('Time (s)'); ylabel('Frequency')
    title(data.label(i))
    ax = gca;
    ax.YDir = 'normal'
end

linkaxes(a)