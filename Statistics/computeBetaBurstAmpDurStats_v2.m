function [BB] = computeBetaBurstAmpDurStats_v2(R,BB)
% compute_BetaBurstAmpDurStats_v2 - This function will compute binned
% statistics from the thresholded amplitude series and plot here if
% desired
% Tim West- UCL, WTCN 11/12/2018
% BB.guide = {...
%     'segL_t_save = segment lengths in ms'
%     'segA_save = seg amplitudes'
%     'AmpBin = frequencies (occurence) of binned amps'
%     'binSgEd = set of bin edges'
%     'segTInds = start end of time'
%     };

for cond = 1:length(R.condname)
    BB = defineBetaEvents(R,BB);
    
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


% function binstats(XY)