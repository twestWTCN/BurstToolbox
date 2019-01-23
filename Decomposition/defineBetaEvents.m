function BB = defineBetaEvents(R,BB)
% Function defines beta events by threshold crossing
BB.guide = [BB.guide;{...
    'segInds = seg indices of original data'
    'segL = seg durations'
    'AmpBin = frequencies (occurence) of binned amps'
    'binSgEd = set of bin edges'
    'segTInds =start end of time'
    }];
for cond = 1:length(R.condname)
    % Threshold Envelopes to get bursts
    BB.epsAmp = prctile([BB.AEnv{:}],R.BB.thresh_prctile,2);
    BB.epsPLV = prctile([BB.PLV{:}],R.BB.thresh_prctile,2);
    
    X = BB.AEnv{cond}; % Copy amplitude data
    Xcd = X>BB.epsAmp; % Threshold on eps
    Xcd = double(Xcd); % Convert from logical
    
    % Set a threshold on the shortest lengths
    BB.period = (R.BB.minBBlength/BB.powfrq)*BB.fsamp;
    % Get Bursts
    betaBurstInds = SplitVec(find(Xcd(R.BB.pairInd(2),:)),'consecutive');
    segL = cellfun('length',betaBurstInds);
    % Now crop using minimum
    betaBurstInds = {betaBurstInds{segL>BB.period}}; % segs exceeding min length
    BB.segInds{cond} = betaBurstInds;
    
    segL = segL(segL>(BB.period));
    BB.segL{cond} = (segL/BB.fsamp)*1000; % convert to ms
    
    % Segment Time indexes
    BB.segInds{cond}{1} = NaN(1,2); BB.segTInds{cond}{1} = NaN(1,2);
    for ci = 1:numel(betaBurstInds)
        BB.segInds{cond}{ci} = betaBurstInds{betaBurstInds(ci)};
        BB.segTInds{cond}{ci} = (betaBurstInds{betaBurstInds(ci)}([1 end])/BB.fsamp);
    end
    
    % Now do Amplitudes
    BB.segA_save{cond} = NaN;
    for ci = 1:numel(betaBurstInds)
        BB.segA_save{cond}(ci) = nanmean(X(2,betaBurstInds{betaBurstInds(ci)}));
        %         BB.segAPrc_save{cond}(ci) = nanmean(Xnorm(2,consecSegs{segInds(ci)})); % Uses the Normed Amplitudes
    end
    %%%
    X = BB.segA_save{cond};
    Xnorm = 100*(X-median(X))/median(X);
    %     Xnorm = Xnorm-median(Xnorm); % 2nd normalization brings conditions closer to zero mean
    BB.segAPrc_save{cond} = Xnorm; %nanmean(Xnorm(2,consecSegs{segInds(ci)})); % Uses the Normed Amplitudes
end