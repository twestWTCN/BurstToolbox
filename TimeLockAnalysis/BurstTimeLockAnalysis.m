function BB = BurstTimeLockAnalysis(R,cond,BB,PLVcmp,F)
% Tool for conducting the aligned bursts
if PLVcmp == 0
    periodT = [-400 400];
else
    periodT = [-200 500];
end

BEpoch = []; REpoch = [];

% Threshold Amplitude Data
X = BB.A{cond}; % Copy amplitude data
Xcd = X>BB.epsAmp; % Threshold on eps
Xcd = double(Xcd); % Convert from logical

% LocalEps
localeps = prctile(BB.A{cond},75,2);

% Work first with lengths
BB.period = (2/BB.powfrq)*BB.fsamp;
consecSegs = SplitVec(find(Xcd(R.BB.pairInd(2),:)),'consecutive');
segL = cellfun('length',consecSegs);
segInds = find(segL>(BB.period)); % segs exceeding min length

for i = 1:numel(segInds)
    Bo = consecSegs{segInds(i)};
    preBo = [Bo(1)+ floor((periodT(1)/1e3)*BB.fsamp):Bo(1)]; %pre burst onset
    postBo = [Bo(1): Bo(1) + floor((periodT(2)/1e3)*BB.fsamp)]; % post burst onset
    epochdef = [preBo(1):postBo(end)];
    % Convert from full time to SW time
    if preBo(1)>0
        % Find onset Time aligned to beta onset
        X = BB.A{cond}(:,epochdef).*hanning(numel(epochdef))';
        for L = 1:size(BB.A{cond},1)
            if any(X(L,:)>localeps(L))
             [dum epsCross(i,L)] = find(X(L,:)>localeps(L),1,'first');
            else 
                epsCross(i,L) = 1;
            end
        end
        
        [dum T(1)] = min(abs(BB.SWTvec{cond}-BB.T(epochdef(1))));
        T(2) = T(1) + floor(sum(abs(periodT/1000))/diff(BB.TSw(1:2)));
        if epochdef(end)<size(BB.A{cond},2) && epochdef(1) > 0 && T(2)<=size(BB.PLV{cond},2)
            BEpoch(:,:,i) = 1*zscore(BB.A{cond}(:,epochdef),0,2).*hanning(numel(epochdef))'; % ch x time x burstN
            REpoch(:,:,i) = 3*zscore(BB.BPTime{cond}(:,epochdef),0,2).*hanning(numel(epochdef))';
            PLVpoch(:,i) = BB.PLV{cond}(1,T(1):T(2));
            dRPdEpoch(:,i) = BB.dRPdtime{cond}(epochdef)';
            meanPLV(i) = mean(PLVpoch(:,i)); %computePPC(squeeze(BB.Phi([1 4],Bo)));
            maxAmp(i) = max(BB.A{cond}(4,Bo));
            minAmp(i) = min(BB.A{cond}(4,preBo));
        end
    end
end
pinds{1} = 1:size(meanPLV,2);
pinds{2} = find(meanPLV>=prctile(meanPLV,85));
pinds{3} = find(meanPLV<=prctile(meanPLV,15));

% Define Epoch Time Vectors
TEpoch = linspace(periodT(1),periodT(2),size(epochdef,2));
SWEpoch = linspace(periodT(1),periodT(2),size(PLVpoch,1));

if PLVcmp == 0
    plvcond = 1;
    ls = {'-'};
elseif PLVcmp == 1
    plvcond = 2:3;
    ls = {'','--',':'};
end
cmap = linspecer(4);
for pc = plvcond
    indtmp = pinds{pc};
    meanEnv = squeeze(nanmean(BEpoch(:,:,indtmp),3)); stdEnv = squeeze(nanstd(BEpoch(:,:,indtmp),[],3));%./sqrt(size(BEpoch(:,:,indtmp),3));
    meanRaw = squeeze(nanmean(REpoch(:,:,indtmp),3));
    meanPLV = squeeze(nanmean(PLVpoch(:,indtmp),2)); stdPLV = squeeze(nanstd(PLVpoch(:,indtmp),[],2))./sqrt(size(PLVpoch(:,indtmp),2));
    meandRPd = squeeze(nanmean(dRPdEpoch(:,indtmp),2)); stdRPd = squeeze(nanstd(dRPdEpoch(:,indtmp),[],2))./sqrt(size(dRPdEpoch(:,indtmp),2));
    
    [x ind] = max(meanEnv,[],2);
    figure(F(1));
    subplot(1,3,cond)
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
        
        if PLVcmp == 0
            XY = meanRaw(i,:);
            %     XY = 3.5*meanRaw(i,:);
            XY = XY-mean(XY);
            XY = (XY)-(i-1)*3;
            plot(TEpoch,XY','color',cmap(i,:),'LineWidth',1.5,'LineStyle',ls{pc})
            % Plot Peak Times as Text
            lhan(2*i) = plot(repmat(TEpoch(ind(i)),2,1),[-10 80],'LineStyle','--','color',cmap(i,:),'LineWidth',1);
            splay = TEpoch(ind(i))+(4*(TEpoch(ind(i))-median(TEpoch(ind))));
            plot([splay TEpoch(ind(i))],[-10.2 -10],'LineStyle','--','color',cmap(i,:),'LineWidth',1)
            text(splay,-10.3,sprintf('%0.1f ms',TEpoch(ind(i))),'color',cmap(i,:))
            legn{(2*i)-1} = R.chsim_name{i};
            legn{2*i} = [R.chsim_name{i} ' max'];
        end
    end
    legend(lp,R.chsim_name)
    xlabel('Onset Time (ms)'); ylabel('Average Amplitude (a.u.)'); ylim([-11 2]); xlim(periodT)
    
%     set(gca,'YTickLabel',[]); grid on; grid minor
    
    
    figure(F(2));
    subplot(1,3,cond)
    [lp(pc),hp] = boundedline(SWEpoch,meanPLV',stdPLV');
    lp(pc).Color = cmap(i,:);
    lp(pc).LineStyle = ls{pc};
    lp(pc).LineWidth = 2;
    hp.FaceColor = cmap(i,:); hp.FaceAlpha = 0.5;
    xlabel('Onset Time (ms)'); ylabel('STN/M1 PLV');  xlim(periodT); grid on
    %ylim([0.08 0.12]);
    
    figure(F(3));
    subplot(1,3,cond)
    [lp(pc),hp] = boundedline(TEpoch,meandRPd',stdRPd');
    lp(pc).Color = cmap(2,:);
    lp(pc).LineStyle = ls{pc};
    lp(pc).LineWidth = 2;
    hp.FaceColor = cmap(2,:); hp.FaceAlpha = 0.5;
    xlabel('Onset Time (ms)'); ylabel('STN/M1 dRP/dt');  xlim(periodT); grid on
    %ylim([0.08 0.12]);
    
    % Plot Onset Times
    figure(F(4));
    subplot(1,3,cond)
    epsCross = epsCross(:,end:-1:1);
    Z = TEpoch(epsCross);
    Z(Z==-400) = NaN;
    h = violin(Z,'facecolor',cmap(end:-1:1,:),'facealpha',0.8,'mc','k:','medc','k-');
    a = gca;
    a.XTick = 1:4;
    a.XTickLabel = R.chsim_name(end:-1:1);
    ylabel('Onset Time (ms)'); ylim(periodT); grid on
    view([90 -90])
    %ylim([0.08 0.12]);
    
end

% figure(F(2));legend({'High PLV','Low PLV'})
