function BB = defineBetaEvents(R,BB,memflag,syncflag)
if nargin<3
    memflag = 0; % memflag crops the long (time series) elements of BB for size reasons
end
if nargin<4
    syncflag = 1;
end
% Function defines beta events by threshold crossing
if ~any(strncmp(BB.guide,'segInds',7))
    BB.guide = [BB.guide;{...
        'segInds - seg indices of original data'
        'segT - seg time vector'
        'segDur - segment duration (ms)'
        'segAmp - segment amplitudes'
        'segAmpPrc - prctile normed amplitudes'
        }];
end
for cond = 1:numel(BB.data)
    
    Amp = BB.AEnv{cond}; % Copy amplitude data
    switch R.BB.threshold_type
        case 'localThresh'
            ThreshX = double(Amp>BB.epsAmpfull(R.BB.pairInd(2),cond)); % Threshold on eps
        case 'baseModelThresh'
            ThreshX = double(Amp>BB.epsAmpfull(R.BB.pairInd(2),1)); % Threshold on eps
    end
    % Set a threshold on the shortest lengths
    BB.period = (R.BB.minBBlength/BB.powfrq)*BB.fsamp;
    % Get Bursts
    betaBurstInds = SplitVec(find(ThreshX(R.BB.pairInd(2),:)),'consecutive'); % Split up data based upon the target threshold
    segL = cellfun('length',betaBurstInds);
    % Now crop using minimum
    burstSelection = segL>BB.period;
    % %     segL = segL(burstSelection);
    % %     BB.segL{cond} = (segL/BB.fsamp)*1000; % convert to ms
    
    betaBurstInds = {betaBurstInds{burstSelection}}; % segs exceeding min length
    BB.segInds{cond} = betaBurstInds;
    BB.segRate{cond} = numel(BB.segInds{cond})./(diff(BB.T([1 end]))/60); % burst rate (min^-1)
    % Segment Time indexes
    BB.segT{cond}{1} = NaN(1,2); BB.segDur{cond} = NaN(1,2); BB.segAmp{cond} = NaN(1,2); BB.segPLV{cond} = NaN(1,2); BB.segInterval{cond} = NaN(1,3);
    for ci = 3:numel(betaBurstInds)-1
        BB.segT{cond}{ci} = BB.Tvec{cond}(betaBurstInds{ci}); % segment time vectors
        BB.segDur{cond}(ci) = diff(BB.segT{cond}{ci}([1 end]))*1000; % segment duration (ms)
        BB.segAmp{cond}(ci) = nanmean(Amp(R.BB.pairInd(2),betaBurstInds{ci}));
        BB.segAmpMid{cond}(ci) = Amp(R.BB.pairInd(2),floor(median(betaBurstInds{ci}))); %
        if (betaBurstInds{ci}(1)-150)> 0 && (betaBurstInds{ci}(1)+150)<size(Amp,2)
            BB.segEnv{cond}(:,:,ci) = Amp(:,betaBurstInds{ci}(1)-150:betaBurstInds{ci}(1)+150);
        else
            BB.segEnv{cond}(:,:,ci) = nan(4,501);
        end
        BB.segPow{cond} = BB.segAmp{cond}(ci).*BB.segDur{cond}(ci);
        
        if ci>4
            BB.segInterval{cond}(ci)  =  BB.segT{cond}{ci}(1)-BB.segT{cond}{ci-1}(end);
        end
        if syncflag == 1
            Xcmb = nchoosek(1:size(BB.epsAmpfull,1), 2);
            for i = 1:size(Xcmb,1)
                BB.segRP{cond}(ci,Xcmb(i,1),Xcmb(i,2)) = circ_median(BB.RP{cond}(betaBurstInds{ci}(1)-floor(BB.period):betaBurstInds{ci}(1)+floor(BB.period),Xcmb(i,1),Xcmb(i,2)));
                %             BB.segRP{cond}(ci,Xcmb(i,1),Xcmb(i,2)) = circ_median(BB.RP{cond}(betaBurstInds{ci},Xcmb(i,1),Xcmb(i,2)));
            end
            BB.sPPC{cond}(ci) = NaN; %computePPC(BB.Phi{cond}([1 4],betaBurstInds{ci}),1);
            %         RP = diff(BB.Phi{cond}([1 4],betaBurstInds{ci}),1,1);  % V
            try
                RP = diff(BB.Phi{cond}([1 4],betaBurstInds{ci}(1):betaBurstInds{ci}(1)+500),1,1); %Fixed Time Windows!
            catch
                RP = NaN;
            end
            BB.segPLV{cond}(ci) = abs(mean(exp(-1i*RP'),1));
        end
    end
    
    %%% Normalization
    A = BB.segAmp{cond};
    Xnorm = 100*(A-nanmedian(A))/nanmedian(A);
    %     Xnorm = Xnorm-median(Xnorm); % 2nd normalization brings conditions closer to zero mean
    BB.segAmpPrc{cond} = Xnorm; %nanmean(Xnorm(2,consecSegs{segInds(ci)})); % Uses the Normed Amplitudes
    
end

if memflag == 1
    BB = rmfield(BB,{'AEnv','PLV','SWTvec','RP','swRP','dRP','Phi','BP'});
end