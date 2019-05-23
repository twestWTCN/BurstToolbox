function [binStats, binData] = binDatabyRange(dataX,binXEdges,dataY)
% function to bind 'dataY' by bins set by dataX with edges defined by 'binXEdges'.
% outputs
binXEdges = [binXEdges inf];
for bs = 1:numel(binXEdges)-1
    s = find(dataX>=binXEdges(bs) & dataX<binXEdges(bs+1));
    x = nanmean(dataY(s)); % mean of bin
%     xv = nanstd(dataY(s))/sqrt(numel(s)); % SEM of bin
    xv = nanstd(dataY(s))/nanmean(dataY(s)); % CoV of bin
    w = (numel(s)/numel(dataY)); % weighting
    %         if numel(s)<2; w = 0; end
    
    binStats(bs,1) = x*w;
    binStats(bs,2) = xv*w;
    binStats(bs,3) = x;
    binStats(bs,4) = xv;
    
    binData{bs} = dataY(s);
end
