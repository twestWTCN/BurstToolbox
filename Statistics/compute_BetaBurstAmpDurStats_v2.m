function [BB] = compute_BetaBurstAmpDurStats_v2(R,BB,F,plotop)
% compute_BetaBurstAmpDurStats_v2 - This function will compute binned
% statistics from the thresholded amplitude series and plot here if
% desired
% Tim West- UCL, WTCN 11/12/2018
BB.guide = {...
    'segL_t_save = segment lengths in ms'
    'segA_save = seg amplitudes'
    'AmpBin = frequencies (occurence) of binned amps'
    'binSgEd = set of bin edges'
    'segTInds = start end of time'
    };

fsamp = R.fsamp;
for cond = 1:length(R.condname)
    X = BB.A{cond}; % Copy amplitude data
    Xcd = X>BB.epsAmp; % Threshold on eps
    Xcd = double(Xcd); % Convert from logical
    
    % Work first with lengths
    BB.period = (2/BB.powfrq)*fsamp;
    consecSegs = SplitVec(find(Xcd( R.BB.pairInd(2),:)),'consecutive');
    segL = cellfun('length',consecSegs);
    segInds = find(segL>(BB.period)); % segs exceeding min length
    
    % Work first with lengths
    BB.segL_t_save{cond} = (segL/fsamp)*1000; % Segment lengths in ms
    BB.segL_t_save{cond}(setdiff(1:length(segL),segInds)) = [];
    
    % Segment Time indexes
    BB.segInds{cond}{1} = NaN(1,2); BB.segTInds{cond}{1} = NaN(1,2);
    for ci = 1:numel(segInds);
        BB.segInds{cond}{ci} = consecSegs{segInds(ci)};
        BB.segTInds{cond}{ci} = (consecSegs{segInds(ci)}([1 end])/fsamp);
    end
    
    % Now do Amplitudes
    BB.segA_save{cond} = NaN;
    for ci = 1:numel(segInds)
        BB.segA_save{cond}(ci) = nanmean(X(2,consecSegs{segInds(ci)}));
        %         BB.segAPrc_save{cond}(ci) = nanmean(Xnorm(2,consecSegs{segInds(ci)})); % Uses the Normed Amplitudes
    end
    %%%
    X = BB.segA_save{cond};
    Xnorm = 100*(X-median(X))/median(X);
    %     Xnorm = Xnorm-median(Xnorm); % 2nd normalization brings conditions closer to zero mean
    BB.segAPrc_save{cond} = Xnorm; %nanmean(Xnorm(2,consecSegs{segInds(ci)})); % Uses the Normed Amplitudes
    %%%
    
    % Bin data by Amp and find Length
    BB.binAmp = [BB.range.Amp inf];
    if cond == 1; BB.Seg_binAmp = []; end
    for bs = 1:numel(BB.binAmp)-1
        s = find(BB.segA_save{cond}>=BB.binAmp(bs) & BB.segA_save{cond}<BB.binAmp(bs+1));
        x = nanmean(BB.segL_t_save{cond}(s));
        xv = nanstd(BB.segL_t_save{cond}(s))/sqrt(numel(s));
        w = (numel(s)/numel(BB.segA_save{cond}));
        %         if numel(s)<2; w = 0; end
        
        BB.Seg_binAmp(bs,cond,1) = x*w;
        BB.Seg_binAmp(bs,cond,2) = xv*w;
        BB.Seg_binAmpData{bs,cond} = BB.segL_t_save{cond}(s);
        Seg_binAmpDataLOC{cond}{bs} = BB.segL_t_save{cond}(s); % LOCAL (different formatting)
        
    end
    
    % Bin data by length and find amplitude
    BB.binDur = [BB.range.segDur inf];
    if cond == 1; BB.Amp_binDur = []; end
    for bs = 1:numel(BB.binDur)-1
        s = find(BB.segL_t_save{cond}>=BB.binDur(bs) & BB.segL_t_save{cond}<BB.binDur(bs+1));
        x = nanmean(BB.segA_save{cond}(s));
        xv = nanstd(BB.segA_save{cond}(s))/sqrt(numel(s));
        w =  (numel(s)/numel(BB.segA_save{cond}));
        %                     if numel(s)<2; w = 0; end
        BB.Amp_binDur(bs,cond,1) = x*w;
        BB.Amp_binDur(bs,cond,2) = xv*w;
        BB.Amp_binDurData{bs,cond} = BB.segA_save{cond}(s);
        Amp_binDurDataLOC{cond}{bs} = BB.segA_save{cond}(s);% LOCAL (different formatting)
    end
    
    % Do amplitude/length correlation stats
    if numel(BB.segA_save{cond})>2
        [Rho pval] = corr(BB.segA_save{cond}',BB.segL_t_save{cond}','type','Spearman');
        [xCalc yCalc b Rsq bHd RsqHd wPval] = linregress(BB.segA_save{cond}',BB.segL_t_save{cond}',1);
        BB.corrs.ampdur.spearman{cond} = [Rho pval];
        BB.corrs.ampdur.rest_regress{cond} = [Rsq b RsqHd wPval bHd'];
    else
        BB.corrs.ampdur.spearman{cond} = [NaN NaN];
        BB.corrs.ampdur.rest_regress{cond} = [NaN NaN];
    end
    
end
if plotop == 1
    figure(F(1))
    colormap(R.condcmap)
    subplot(3,3,1)
    plotBurstDurationHistogram(R,BB)
    
    subplot(3,3,2)
    plotBurstAmplitudeHistogram(R,BB)
    
    % Now do duration vs amplitude
    subplot(3,3,3)
    plotBurstAmpDurScatter(R,BB)
    
    subplot(3,1,2);
    plotAmpBinDurBar(R,BB)
    
    subplot(3,1,3);
    plotDurBinAmpBar(R,BB)
    %     BB.Seg_binAmpStats
end

% function binstats(XY)