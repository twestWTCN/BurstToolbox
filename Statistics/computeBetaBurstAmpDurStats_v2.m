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
if isfield(R,'condnames')
    R.condname = R.condnames;
end

BB.Dur_binAmp = [];
BB.Amp_binDur = [];

for cond = 1:length(R.condname)
    % This is where the bursts are divided
    BB = defineBetaEvents(R,BB);
    
    % Bin data by Amp and find Length
    [BB.Dur_binAmp(:,:,cond),BB.Dur_binAmpData{cond}] = binDatabyRange(BB.segAmp{cond},BB.range.Amp,BB.segDur{cond});
    
    % Bin data by length and find amplitude
    [BB.Amp_binDur(:,:,cond),BB.Amp_binDurData{cond}] = binDatabyRange(BB.segDur{cond},BB.range.Dur,BB.segAmp{cond});
    
    % Do amplitude/length correlation stats
    if numel(BB.segAmp{cond})>2
        [Rho pval] = corr(BB.segAmp{cond}',BB.segDur{cond}','type','Spearman');
        [xCalc yCalc b Rsq bHd RsqHd wPval] = linregress(BB.segAmp{cond}',BB.segDur{cond}',1);
        BB.corrs.ampdur.spearman{cond} = [Rho pval];
        BB.corrs.ampdur.rest_regress{cond} = [Rsq b RsqHd wPval bHd'];
    else
        BB.corrs.ampdur.spearman{cond} = [NaN NaN];
        BB.corrs.ampdur.rest_regress{cond} = [NaN NaN];
    end
end

% Add definitions of variables
BB.guide = [BB.guide;{...
    'Dur_binAmp - burst durations bin by amp'
    'Dur_binAmpData - "" data'
    'Amp_binDur - burst amps bin by dur'
    'Seg_binAmpData - "" data'
    }];

