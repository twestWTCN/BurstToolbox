function BB = getBurstStatsXConds(BB)
% This function gets statistics of burst samples for each condition
for cond = 1:size(BB.segAmp,2)
    BB.condstat.ssAmp(:,cond) = [nanmedian(BB.segAmp{cond}) iqr(BB.segAmp{cond}) npCI(BB.segAmp{cond})];
    BB.condstat.ssDur(:,cond) = [nanmedian(BB.segDur{cond}) iqr(BB.segDur{cond}) npCI(BB.segDur{cond})];
    BB.condstat.ssPLV(:,cond) = [nanmedian(BB.segPLV{cond}) iqr(BB.segPLV{cond}) npCI(BB.segPLV{cond})];
    BB.condstat.ssPPC(:,cond) = [nanmedian(BB.sPPC{cond}) iqr(BB.sPPC{cond}) npCI(BB.sPPC{cond})];
    
end


function ci = npCI(X)
N = numel(X);
lb = (N/2) - ((1.96*sqrt(N))/2);
ub = 1+ (N/2) + ((1.96*sqrt(N))/2);

X = sort(X);
ub = fix(ub); lb = fix(lb);
if (ub>0) & (lb>0)
    ub = X(fix(ub));
    lb = X(fix(lb));
    ci = ub-lb;
else
    ci = nan;
end