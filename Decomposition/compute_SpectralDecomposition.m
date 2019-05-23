function BB  = compute_SpectralDecomposition(R,BB,data,cond,shuff)
%% compute_WaveletSeries - Wavelet/Bandpass Decomposition for Amplitude/Phase/Phase Locking
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


% % % cfg = []
% % % cfg.channel = 'STN_L01';
% % % cfg.zlim = [0 60]
% % % ft_singleplotTFR(cfg, TFRwave);

% Set up time vector
data_tvec = data.time{1};

switch R.BB.decompmeth.type
    case 'wavelet'
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
    case 'filter'
        % Filter at frequency for power
        cfg = [];
        cfg.bandpass = [BB.powfrq-R.BB.decompmeth.filter.bwid BB.powfrq+R.BB.decompmeth.filter.bwid];
        dataAmp = ft_preprocessing(cfg,data);
        % Filter at frequency for connectivity
        cfg = [];
        cfg.bandpass = [BB.powfrq-R.BB.decompmeth.filter.bwid BB.powfrq+R.BB.decompmeth.filter.bwid];
        dataPhi = ft_preprocessing(cfg,data);
end

% Now compute the Amplitude and Phase Series
switch R.BB.decompmeth.type
    case 'wavelet'
        % Indices of foi for Power
        %%% fInd = find(TFRwave.freq>=R.bandef(2,1) & TFRwave.freq<=R.bandef(2,2)); % Take all of the indices
        % OR account for smoothing and dont stray outside band
        % % [dum fInd] = min(abs(TFRwave.freq-median(R.bandef(2,:)))); % Take middle!
        %%% OR use peak of spectral power
        [dum fIndAng] = min(abs(TFRwave.freq-BB.powfrq)); % Use closest frequency bin
        % Indices of foi for angle
        [dum fIndPhi] = min(abs(TFRwave.freq-BB.cohfrq)); % Take coh peak!
        
        % Display the Wavelet frq resolution
        fbwid = (BB.powfrq/cfg.width)*2; %!
        disp([R.bandinits{2} ' amp estimate at mid freq ' num2str(TFRwave.freq(fIndAng)) ' Hz +/- ' num2str(fbwid)]) %!
        
        % Display the Wavelet frq resolution
        fbwid = (BB.cohfrq/cfg.width)*2;
        disp([R.bandinits{2} ' phase estimate at mid freq ' num2str(TFRwave.freq(fIndPhi)) ' Hz +/- ' num2str(fbwid)])
        
        % Now compute Amplitude
        P = squeeze(TFRwave.fourierspctrm(1,:,fIndAng,:));
        AmpTime = abs(P).^2;
        PhiTime = angle(P);
        Z = AmpTime.*cos(PhiTime);
        
        % Now compute phase
        P = squeeze(TFRwave.fourierspctrm(1,:,fIndPhi,:));
        PhiTime = angle(P);
        
    case 'filter'
        P = squeeze(dataAmp.trial{1});
        AmpTime = abs(hilbert(P)).^2;
        PhiTime = angle(hilbert(P));
        Z = AmpTime.*cos(PhiTime);
        
        P = squeeze(dataPhi.trial{1});
        PhiTime = angle(hilbert(P));
end

% Unwrap the phi time series
for ci = 1:size(PhiTime,1); PhiTime(ci,:) = unwrap(PhiTime(ci,:)); end
RPtime = diff(PhiTime(R.BB.pairInd,:),1,1)';

%% (optional) normalize the amplitudes
% Optionally you can normalize the amplitude timeseries here- NOT USED - This is done later in
% the individual statistics routines to allow for both series to coexist
% in peaceful harmony.
% % AmpPrcTime = [];  %!
% % for ci = 1:2; AmpPrcTime(ci,:) = ( (AmpTime(ci,:)-nanmean(AmpTime(ci,:),2))./nanmean(AmpTime(ci,:),2) )*100; end %!

%% Now Compute the Sync Metric within Sliding Window
% Sliding Window parameters
winsize = R.BB.SW.winsize.*data.fsample; % Window Size
overlap = R.BB.SW.winover; %
% Run the sliding window over RP series
[slide_dphi_12,sind] = slideWindow(RPtime, floor(winsize), floor(winsize*overlap));
switch R.BB.PLmeth
    case 'PLV'
        PLVTime(1,:) = abs(mean(exp(-1i*slide_dphi_12),1));
    case 'PPC'
        swPhi(:,:,1) = slideWindow(PhiTime(R.BB.pairInd(1),:), floor(winsize), floor(winsize*overlap));
        swPhi(:,:,2) = slideWindow(PhiTime(R.BB.pairInd(2),:), floor(winsize), floor(winsize*overlap));
        for i = 1:size(swPhi,2)
            PLVTime(1,i) = computePPC(remnan(squeeze(swPhi(:,i,:))));
        end
end

% % % Normalize Amplitude Traces
% % for i = 1:size(AmpTime,1)
% %     AmpTime(i,:) = (AmpTime(i,:)-nanmean(AmpTime(i,:)))./nanstd(AmpTime(i,:));
% %     AmpTime(i,:) =  AmpTime(i,:)-min( AmpTime(i,:));
% % end
%     %     slide_dphi_12 = wrapToPi(slide_dphi_12);
% PLV
swRP(1,:) = circ_mean(slide_dphi_12, [], 1);

% Get indices of SW centres
sw_tvec = (round(median(sind,1)));
% Convert to data time
sw_tvec = data.time{1}(sw_tvec);

%% Save variables to master structure
BB.guide = {...
    'AEnv - amplitude env series';...
    'Tvec - data time vec';...
    'PLV - sliding window PLV';...
    'SWTvec - sliding window tvec';...
    'RP - relative phase';...
    'swRP - sliding window RP';...
    'dRP - diff RP';...
    'Phi - phase series';...
    'BP - bandpassed data';...
    'data - original data';...
    };
BB.AEnv{cond} = AmpTime;
BB.Tvec{cond} = data_tvec;
BB.PLV{cond} = PLVTime;
BB.SWTvec{cond} = sw_tvec;
BB.RP{cond} = RPtime;
BB.swRP{cond} = swRP;
BB.dRP{cond} = diff(RPtime);
BB.Phi{cond} = PhiTime;
BB.BP{cond} = Z;
BB.data{cond} = data.trial{1};

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
