function BB  = compute_WaveletSeries(R,BB,data,cond,shuff)
%% compute_WaveletSeries - Wavelet Decomposition for Amplitude/Phase/Phase Locking
% This function compute the preprocessing and continuous decomposition of
% the signal to bandlimited signal. Hilbert is used to recover phase and
% amplitude. We then use a sliding window to estimate time evolving PLV.
% 06/09/18

%% Preprocessing
for i = 1:size(data.trial{1},1)
    x = data.trial{1}(i,:);
    x(abs(x)>(4*std(x))) = NaN;
    x= fillmissing(x,'spline');
    data.trial{1}(i,:) = x;
end

if shuff == 1||2
    for i = 1:size(data.trial{1},1)
        x = data.trial{1}(i,:);
        if shuff == 1
            x = x(randperm(length(x)));
        elseif shuff == 2
            x = phaseran(x',1)';
        end
        data.trial{1}(i,:) = x;
    end
end

for i = 1:size(data.trial{1},1)
    x = data.trial{1}(i,:);
    x = (x-mean(x))./std(x);
    data.trial{1}(i,:) = x;
end

% % % Bandpass
% % % data.trial{1} = ft_preproc_bandpassfilter(data.trial{1}, data.fsample,[6 42], [], 'fir', 'twopass', 'reduce');

% % % cfg = []
% % % cfg.channel = 'STN_L01';
% % % cfg.zlim = [0 60]
% % % ft_singleplotTFR(cfg, TFRwave);

% Set up time vector
data_tvec = data.time{1};

%% Now do Wavelet
cfg = [];
cfg.method     = 'wavelet';
cfg.width      = 12;
cfg.gwidth     = 5;
cfg.output     = 'fourier';
cfg.foi        = 8:0.5:35;
cfg.toi        = data.time{1};
cfg.pad = 'nextpow2';
TFRwave = ft_freqanalysis(cfg, data);

for band = 3 % Optionally can do across predefined bands
    
    % Indices of foi for Power
    %%% fInd = find(TFRwave.freq>=R.bandef(2,1) & TFRwave.freq<=R.bandef(2,2)); % Take all of the indices
    % OR account for smoothing and dont stray outside band
    % % [dum fInd] = min(abs(TFRwave.freq-median(R.bandef(2,:)))); % Take middle!
    %%% OR use peak of spectral power
    [dum fIndAng] = min(abs(TFRwave.freq-BB.powfrq)); % Use closest frequency bin
    
    % Indices of foi for angle
    [dum fIndPhi] = min(abs(TFRwave.freq-BB.cohfrq)); % Take coh peak!
    
    % Display the Wavelet frq resolution
    fbwid = (median(R.bandef(2,:))/cfg.width)*2; %!
    disp([R.bandname{2} ' amp estimate at mid freq ' num2str(TFRwave.freq(fIndAng)) ' Hz +/- ' num2str(fbwid)]) %!
    
    % Display the Wavelet frq resolution
    fbwid = (median(R.bandef(band,:))/cfg.width)*2;
    disp([R.bandname{2} ' phase estimate at mid freq ' num2str(TFRwave.freq(fIndPhi)) ' Hz +/- ' num2str(fbwid)])
    
    % Now compute Amplitude
    P = squeeze(TFRwave.fourierspctrm(1,:,fIndAng,:));
    AmpTime = abs(P).^2;
    
    % Optionally you can normalize here- NOT USED - This is done later in
    % 'compute_BetaBurstsStats'
    AmpPrcTime = [];  %!
    for ci = 1:2; AmpPrcTime(ci,:) = ( (AmpTime(ci,:)-nanmean(AmpTime(ci,:),2))./nanmean(AmpTime(ci,:),2) )*100; end %!
    
    % Now compute phase
    P = squeeze(TFRwave.fourierspctrm(1,:,fIndPhi,:));
    PhiTime = angle(P);
    for ci = 1:size(PhiTime,1); PhiTime(ci,:) = unwrap(PhiTime(ci,:)); end
    
    % Sliding Window
    winsize = 0.25.*data.fsample; % Window Size
    overlap = 0.9; %
    RPdtime = diff(PhiTime(1:2,:),1,1)';
    [slide_dphi_12,sind] = slideWindow(RPdtime, floor(winsize), floor(winsize*overlap));
    if isequal(R.BB.PLmeth,'PLV')
        PLVTime(band,:) = abs(mean(exp(-1i*slide_dphi_12),1));
    elseif isequal(R.BB.PLmeth,'PPC')
        swPhi(:,:,1) = slideWindow(PhiTime(1,:), floor(winsize), floor(winsize*overlap));
        swPhi(:,:,2) = slideWindow(PhiTime(2,:), floor(winsize), floor(winsize*overlap));
        for i = 1:size(swPhi,2)
            PLVTime(band,i) = computePPC(remnan(squeeze(swPhi(:,i,:))));
        end
    end
    %     %     slide_dphi_12 = wrapToPi(slide_dphi_12);
    % PLV
    RPTime(band,:) = circ_mean(slide_dphi_12, [], 1);
    
    % Get indices of SW centres
    sw_tvec = (round(median(sind,1)));
    % Convert to data time
    sw_tvec = data.time{1}(sw_tvec);
end
BB.A{cond} = AmpTime;
BB.DTvec{cond} = data_tvec;
BB.PLV{cond} = PLVTime;
BB.SWTvec{cond} = sw_tvec;
BB.RP{cond} = RPTime;
BB.RP{cond} = RPTime;
BB.RPdtime{cond} = RPdtime;
BB.PhiTime{cond} = PhiTime;


BB.history.Origin = date;
try
    BB.history.git = getGitInfo();
catch
    warning('cannot get GIT info!')
end
%% SCRIPT GRAVEYARD
% % % Now Wavlet Coherence
% % cfg = [];
% % cfg.method     = 'wavelet';
% % cfg.width      = 6;
% % cfg.output     = 'fourier';
% % cfg.foi        = 4:0.5:35;
% % cfg.toi        = data.time{1};
% %  cfg.pad = 'nextpow2';
% % TFRwave = ft_freqanalysis(cfg, data);
% %
% %
% % P2 =squeeze(TFRwave.fourierspctrm(1,:,fIndPhi,:));
% % FX = squeeze(P2(1,:,:));
% % FY = squeeze(P2(2,:,:));
% % FXX = FX.*conj(FX);
% % FYY = FY.*conj(FY)
% % FXY = FY.*conj(FX);
% % CXY = (abs(FXY.*FXY).^2)./sqrt(FXX.*FYY);
% %
% %
% % P2 =squeeze(TFRwave.powspctrm(:,fInd,:));
% % FXX = squeeze(P2(1,:,:));
% % FYY = squeeze(P2(2,:,:));
% % FXY = squeeze(TFRwave.crsspctrm(1,fInd,:));
% %
% % CXY = (abs(FXY).^2)./(FXX.*FYY);
% %
% % wcoherence(data.trial{1}(1,:),data.trial{1}(2,:),data.fsample)
