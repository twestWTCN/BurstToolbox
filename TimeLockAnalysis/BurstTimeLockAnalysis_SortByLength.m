function BB = BurstTimeLockAnalysis_SortByLength(R,cond,spcondind,BB,PLVcmp,F)
% Tool for conducting the aligned bursts
if PLVcmp == 0
    periodT = [-400 400];
else
    periodT = [-800 800];
end

BEpoch = []; REpoch = [];
cmap = BB.struccmap;
% Threshold Amplitude Data
X = BB.AEnv{cond}; % Copy amplitude data
Xcd = X>BB.epsAmp; % Threshold on eps
Xcd = double(Xcd); % Convert from logical

% Smooth the dRP Time Series (??)
dRPdt =  BB.dRP{cond};
w = gausswin(0.1*BB.fsamp);
dRPdt = filter(w,1,dRPdt);

% LocalEps
localeps = prctile(BB.AEnv{cond},85,2);

% Work first with lengths
BB.period = (2/BB.powfrq)*BB.fsamp; % A.C.
consecSegs = SplitVec(find(Xcd(R.BB.pairInd(2),:)),'consecutive');
segL = cellfun('length',consecSegs);
segInds = find(segL>(BB.period)); % segs exceeding min length
clear BEpoch REpoch PLVpoch dRPdEpoch meanPLV maxAmp minAmp epsCross usedinds
for i = 1:numel(segInds)
    Bo = consecSegs{segInds(i)};
    preBo = [Bo(1)+ ceil((periodT(1)/1e3)*BB.fsamp):Bo(1)]; %pre burst onset
    postBo = [Bo(1): Bo(1) + floor((periodT(2)/1e3)*BB.fsamp)]; % post burst onset
    epochdef = [preBo(1):postBo(end)];
    % Convert from full time to SW time
    if preBo(1)>0 && postBo(end)<size(BB.AEnv{cond},2)
        % Find onset Time aligned to beta onset
        X = BB.AEnv{cond}(:,epochdef).*hanning(numel(epochdef))';
        Amps(i) = max(X(4,:));
        
        for L = 1:size(BB.AEnv{cond},1)
            if any(X(L,:)>localeps(L)) % For finding maximums locally
                [dum epsCross(i,L)] = find(X(L,:)==max(X(L,:)),1,'first');
            else
                epsCross(i,L) = 1;
            end
        end
        PLVbase = nanmedian(BB.PLV{cond});
     [dum T(1)] = min(abs(BB.SWTvec{cond}-BB.TSw(epochdef(1))));
        T(2) = T(1) + floor(sum(abs(periodT/1000))/diff(BB.TSw(1:2)));
        if epochdef(end)<size(BB.AEnv{cond},2) && epochdef(1) > 0 && T(2)<=size(BB.PLV{cond},2)
            BEpoch(:,:,i) = 1*zscore(BB.AEnv{cond}(:,epochdef),0,2).*hanning(numel(epochdef))'; % ch x time x burstN
            REpoch(:,:,i) = 1*zscore(BB.Tvec{cond}(:,epochdef),0,2).*hanning(numel(epochdef))';
%             BEpoch(:,:,i) = 0.2*BB.A{cond}(:,epochdef); %.*hanning(numel(epochdef))'; % ch x time x burstN
%             REpoch(:,:,i) = 0.5*BB.rawTime{cond}(:,epochdef).*hanning(numel(epochdef))';
            PLVpoch(:,i) = 100*(BB.PLV{cond}(1,T(1):T(2))-PLVbase)/PLVbase ;
            dRPdEpoch(:,i) = dRPdt(epochdef)';
            meanPLV(i) = mean(PLVpoch(:,i)); %computePPC(squeeze(BB.Phi([1 4],Bo)));
            maxAmp(i) = max(BB.AEnv{cond}(4,Bo));
            minAmp(i) = min(BB.AEnv{cond}(4,preBo));
            Segpoch(i) = segL(segInds(i));
        end
    end
end

% Sort by Length

segLengths = (Segpoch/BB.fsamp*1000);
if PLVcmp == 1
pinds{1} = find(segLengths<200);
pinds{2} = find(segLengths>=200 & segLengths<400);
pinds{3} = find(segLengths>=400);
else
    pinds{1} = 1:size(BEpoch,3);
end
% Sort by Amp
% pinds{1} = find(Amps<prctile(Amps,25));
% pinds{2} = find(Amps>=prctile(Amps,25) & Amps<prctile(Amps,75));
% pinds{3} = find(Amps>=prctile(Amps,75));



% Define Epoch Time Vectors
TEpoch = linspace(periodT(1),periodT(2),size(epochdef,2));
SWEpoch = linspace(periodT(1),periodT(2),size(PLVpoch,1));

if PLVcmp == 0
    plvcond = 1;
    ls = {'-'};
elseif PLVcmp == 1
    plvcond = 1:3;
    ls = {'-','--',':'};
end
for pc = plvcond
    indtmp = pinds{pc};
    meanEnv = squeeze(nanmean(BEpoch(:,:,indtmp),3)); stdEnv = squeeze(nanstd(BEpoch(:,:,indtmp),[],3));%./sqrt(size(BEpoch(:,:,indtmp),3));
    meanRaw = squeeze(nanmean(REpoch(:,:,indtmp),3));
    meanPLV = squeeze(nanmean(PLVpoch(:,indtmp),2)); stdPLV = squeeze(nanstd(PLVpoch(:,indtmp),[],2))./sqrt(size(PLVpoch(:,indtmp),2));
    meandRPd = squeeze(nanmean(dRPdEpoch(:,indtmp),2)); stdRPd = squeeze(nanstd(dRPdEpoch(:,indtmp),[],2))./sqrt(size(dRPdEpoch(:,indtmp),2));
    
    [x ind] = max(meanEnv,[],2);
    figure(F(1));
    subplot(1,3,spcondind)
    for i = 1:size(BEpoch,1)
        XY = meanEnv(i,:);
        XY = XY-mean(XY);
        XY = (XY)-(i-1)*3;
        [lp(i) hp] = boundedline(TEpoch,XY',stdEnv(i,:)');
        hold on
        lp(i).Color = cmap(i,:);
        lp(i).LineStyle = ls{pc};
        lp(i).LineWidth = 2;
        hp.FaceColor = cmap(i,:); hp.FaceAlpha = 0.5;
        
            XY = meanRaw(i,:);
            %     XY = 3.5*meanRaw(i,:);
            XY = XY-mean(XY);
            XY = (XY)-(i-1)*3;
            plot(TEpoch,XY','color',cmap(i,:),'LineWidth',1.5,'LineStyle',ls{pc})
        if PLVcmp == 0
            % Plot Peak Times as Text
            lhan(2*i) = plot(repmat(TEpoch(ind(i)),2,1),[-10 80],'LineStyle','--','color',cmap(i,:),'LineWidth',1);
            splay = TEpoch(ind(i))+(4*(TEpoch(ind(i))-median(TEpoch(ind))));
            plot([splay TEpoch(ind(i))],[-10.2 -10],'LineStyle','--','color',cmap(i,:),'LineWidth',1)
            text(splay,-10.3,sprintf('%0.1f ms',TEpoch(ind(i))),'color',cmap(i,:))
            legn{(2*i)-1} = R.chsim_name{i};
            legn{2*i} = [R.chsim_name{i} ' max'];
        end
    end
%     legend(lp,R.chsim_name)
    xlabel('Onset Time (ms)'); ylabel('Average Amplitude (a.u.)'); ylim([-11 2]); xlim(periodT)
    
    %     set(gca,'YTickLabel',[]); grid on; grid minor
    
    % Plot Timelocked STN/M1 PLV
    figure(F(2));
    subplot(1,3,spcondind)
    [lp(pc),hp] = boundedline(SWEpoch,meanPLV',stdPLV');
    hp.FaceAlpha = 0;
    lp(pc).Color = cmap(i,:);
    lp(pc).LineStyle = ls{pc};
    lp(pc).LineWidth = 2;
    hp.FaceColor = cmap(i,:); hp.FaceAlpha = 0.5;
    xlabel('Onset Time (ms)'); ylabel('STN/M1 PLV (\Delta%)');  xlim(periodT); grid on
    ylim([-20 2.5]);
    
    % Plot Timelocked dRPdt
    figure(F(3));
    subplot(1,3,spcondind)
    [lp(pc),hp] = boundedline(TEpoch,meandRPd',stdRPd');
    lp(pc).Color = cmap(2,:);
    lp(pc).LineStyle = ls{pc};
    lp(pc).LineWidth = 2;
    hp.FaceColor = cmap(2,:); hp.FaceAlpha = 0.5;
    xlabel('Onset Time (ms)'); ylabel('STN/M1 dRP/dt');  xlim(periodT); grid on
    %ylim([0.08 0.12]);
    
    % Plot Onset Times (violin plots)
    figure(F(4));
    subplot(1,3,spcondind)
    epsCross = epsCross(2:end,end:-1:1);
    Z = TEpoch(epsCross);
    Z(Z==periodT(1)) = NaN;
    h = violin(Z,'facecolor',cmap(end:-1:1,:),'facealpha',1,'mc','k:','medc','k-');
    a = gca;
    a.XTick = 1:4;
    a.XTickLabel = R.chsim_name(end:-1:1);
    ylabel('Onset Time (ms)'); ylim([-200 200]); grid on
    view([90 -90])
    %ylim([0.08 0.12]);
    
   
    
end

% figure(F(2));legend({'High PLV','Low PLV'})
