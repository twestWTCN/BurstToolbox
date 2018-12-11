function BB = AlignedBursts_analysis(R,cond,BB,data,AS,PLVcmp,F)
% Tool for conducting the aligned bursts
ftdata = [];
ftdata.label = R.chsim_name;
ftdata.trial{1} = data{1};
ftdata.fsample = 1/R.IntP.dt;

if isfield(R.IntP,'tvec_obs')
    ftdata.time{1} = R.IntP.tvec_obs;
else
    ftdata.time{1} = linspace(0,size(ftdata.trial{1},2)/ftdata.fsample,size(ftdata.trial{1},2));
end

% cfg = [];
% cfg.length = 1;
% ftdata_tr = ft_redefinetrial(cfg,ftdata);

banddef = [19 22]; % define band
frq_peak = getMaxBandFrq(AS,banddef,R.frqz);

% Compute Wavelet Amplitude
% cfg = [];
% cfg.method     = 'wavelet';
% cfg.width      = 10; % spectral bandwidth at frequency F: (F/width)*2
% cfg.gwidth     = 2;
% cfg.output     = 'pow';
% cfg.foi        = 14:0.5:35;
% cfg.toi        = ftdata.time{1};
% cfg.pad = 100;
% TFRwave = ft_freqanalysis(cfg, ftdata);
% fbwid = (median(banddef(1,:))/cfg.width)*2;
% disp(['Beta amp estimate at mid freq ' num2str(TFRwave.freq(fInd)) ' Hz +/- ' num2str(fbwid)])
%

% Optional Plots
% cfg = []
% cfg.channel = 'MMC';
% % cfg.zlim = [0 60]
% ft_singleplotTFR(cfg, TFRwave)


% Define TimeSeries
% % BB.Time = TFRwave.time;
BB.Time = ftdata.time{1};
BB.fsamp = 1/diff(BB.Time(end-1:end));
% [dum fInd] = min(abs(TFRwave.freq-frq_peak(1,4))); % Take middle!
% fbwid = (median(banddef(1,:))/cfg.width)*2;
% disp(['Beta amp estimate at mid freq ' num2str(TFRwave.freq(fInd)) ' Hz +/- ' num2str(fbwid)])


% % BB.Amp = squeeze(TFRwave.powspctrm(:,fInd,:));
% % BB.epsAmp = prctile(BB.Amp(4,:),75,2);

% interpolate original series to new sample
BB.RawInt = [];  BB.Amp = [];
for i = 1:size(ftdata.trial{1},1)
    bdata = ft_preproc_bandpassfilter(ftdata.trial{1}(i,:),ftdata.fsample,[frq_peak(1,4)-1 frq_peak(1,4)+1],[],'fir');
    BB.RawInt(i,:) = bdata;
    % %     BB.RawInt(i,:) = interp1(ftdata.time{1},bdata,BB.Time);
    BB.Amp(i,:) = abs(hilbert(BB.RawInt(i,:)));
    BB.Phi(i,:) = angle(hilbert(BB.RawInt(i,:)));
end
BB.epsAmp = prctile(BB.Amp(4,:),85,2);


X = BB.Amp(4,:);
Xcd = X>BB.epsAmp;
Xcd = double(Xcd);

period = (2/banddef(1,1))*BB.fsamp;
consecSegs = SplitVec(find(Xcd(1,:)),'consecutive');

% Work first with lengths
segL = cellfun('length',consecSegs);
segInds = find(segL>(period)); % segs exceeding min length
segL_t = (segL/BB.fsamp)*1000; % Segment lengths in ms
segL_t(setdiff(1:length(segL),segInds)) = [];

% Segment Time indexes
segT_ind = [];
for ci = 1:numel(segInds); segT_ind{ci} = (consecSegs{segInds(ci)}([1 end])/BB.fsamp); end

% Now do Amplitudes
segA = [];
for ci = 1:numel(segInds); segA(ci) = nanmean(X(consecSegs{segInds(ci)})); end

cmap = linspecer(4); %brewermap(4,'Set1');
cmap = cmap(end:-1:1,:);
if PLVcmp == 0
    onsetT = [-600 600];
else
    onsetT = [-200 500];
end
BEpoch = []; REpoch = [];
for i = 1:numel(segInds)
    Bo = consecSegs{segInds(i)};
    preBo = [Bo(1)+ floor((onsetT(1)/1e3)*BB.fsamp):Bo(1)]; %pre burst onset
    postBo = [Bo(1): Bo(1) + floor((onsetT(2)/1e3)*BB.fsamp)]; % post burst onset
    epochdef = [preBo(1):postBo(end)];
    % Convert from full time to SW time
    if preBo(1)>0
        [dum T(1)] = min(abs(BB.SWTvec{cond}-BB.Time(epochdef(1))));
        T(2) = T(1) + floor(sum(abs(onsetT/1000))/diff(BB.SWTvec{1}(1:2)));
        if epochdef(end)<size(BB.Amp,2) && epochdef(1) > 0 && T(2)<=size(BB.PLV{cond},2)
            BEpoch(:,:,i) = BB.Amp(:,epochdef);
            REpoch(:,:,i) = BB.RawInt(:,epochdef);
            PLVpoch(:,:,i) = BB.PLV{cond}(2,T(1):T(2));
            meanPLV(i) = computePPC(squeeze(BB.Phi([1 4],Bo)));
            maxAmp(i) = max(BB.Amp(4,Bo));
            minAmp(i) = min(BB.Amp(4,preBo));
        end
    end
end
pinds{1} = 1:size(meanPLV,2);
pinds{2} = find(meanPLV>=prctile(meanPLV,85));
pinds{3} = find(meanPLV<=prctile(meanPLV,15));

if PLVcmp == 0
    plvcond = 1;
    ls = {'-'};
elseif PLVcmp == 1
    plvcond = 2:3;
    ls = {'','--',':'};
end

for pc = plvcond
    
    TEpoch = linspace(onsetT(1),onsetT(2),size(epochdef,2));
    SWEpoch = linspace(onsetT(1),onsetT(2),size(PLVpoch,2));
    indtmp = pinds{pc};
    meanEnv = squeeze(mean(BEpoch(:,:,indtmp),3)); stdEnv = squeeze(std(BEpoch(:,:,indtmp),[],3));%./sqrt(size(BEpoch(:,:,indtmp),3));
    meanRaw = squeeze(mean(REpoch(:,:,indtmp),3));
    meanPLV = squeeze(mean(PLVpoch(:,:,indtmp),3)); stdPLV = squeeze(std(PLVpoch(:,:,indtmp),[],3))./sqrt(size(PLVpoch(:,:,indtmp),3));
    [x ind] = max(meanEnv,[],2)
    figure(F(1)); subplot(1,3,cond)
    for i = 1:size(BEpoch,1)
        XY = 3.5*meanEnv(i,:);
        XYp = XY-mean(XY);
        XY = 10 + ((XYp)-(i*2));
        [lp hp] = boundedline(TEpoch,XY',stdEnv(i,:)');
        hold on
        lp.Color = cmap(i,:);
        lp.LineStyle = ls{pc};
        lp.LineWidth = 2;
        hp.FaceColor = cmap(i,:); hp.FaceAlpha = 0.5;
        
        if PLVcmp == 0
            XY = 1*(10.^XYp).*meanRaw(i,:);
            %     XY = 3.5*meanRaw(i,:);
            XY = XY - mean(XY);
            XY = 10 + ((XY)-(i*2));
            plot(TEpoch,XY','color',cmap(i,:),'LineWidth',1.5,'LineStyle',ls{pc})
            
            % Plot Peak Times as Text
            
            lhan(2*i) = plot(repmat(TEpoch(ind(i)),2,1),[1.5 500],'LineStyle','--','color',cmap(i,:),'LineWidth',1);
            splay = TEpoch(ind(i))+(10*(TEpoch(ind(i))-median(TEpoch(ind))));
            plot([splay TEpoch(ind(i))],[0.5 1.5],'LineStyle','--','color',cmap(i,:),'LineWidth',1)
            text(splay,0.4,sprintf('%0.1f ms',TEpoch(ind(i))),'color',cmap(i,:))
            
            legn{(2*i)-1} = R.chsim_name{i};
            legn{2*i} = [R.chsim_name{i} ' max'];
        end
    end
    % legend(lhan(1:2:8),legn(1:2:8))
    xlabel('STN Beta Onset Time (ms)'); ylabel('Average Amplitude (a.u.)'); ylim([0 10]); xlim(onsetT)
    set(gca,'YTickLabel',[]); grid on; grid minor
    
    
figure(F(2));
    subplot(1,3,cond)
    [lp(pc) hp] = boundedline(SWEpoch,meanPLV',stdPLV');
    lp(pc).Color = cmap(i,:);
    lp(pc).LineStyle = ls{pc};
    lp(pc).LineWidth = 2;
    hp.FaceColor = cmap(i,:); hp.FaceAlpha = 0.5;
    xlabel('STN Beta Onset Time (ms)'); ylabel('STN/M1 PLV'); ylim([0.08 0.12]); xlim(onsetT); grid on
    
end

figure(F(2));legend({'High PLV','Low PLV'})
