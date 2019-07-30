function BB = getBurstStatsXConds(BB)
% This function gets statistics of burst samples for each condition
for cond = 1:size(BB.segAmp,2)
    BB.condstat.ssAmp(:,cond) = [median(BB.segAmp{cond}) iqr(BB.segAmp{cond})];
    BB.condstat.ssDur(:,cond) = [median(BB.segDur{cond}) iqr(BB.segDur{cond})];
    BB.condstat.ssPLV(:,cond) = [median(BB.segPLV{cond}) iqr(BB.segPLV{cond})];
end