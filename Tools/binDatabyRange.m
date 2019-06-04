function [binStats, binData] = binDatabyRange(dataX,binXEdges,dataY,wtype)
if nargin<4
    wtype = 'number';
end
% function to bind 'dataY' by bins set by dataX with edges defined by 'binXEdges'.
% outputs
binXEdges = [binXEdges inf];
for bs = 1:numel(binXEdges)-1
    s = find(dataX>=binXEdges(bs) & dataX<binXEdges(bs+1));
    x = nanmean(dataY(s)); % mean of bin
%     xv = nanstd(dataY(s))/sqrt(numel(s)); % SEM of bin
    xv = nanstd(dataY(s))/nanmean(dataY(s)); % CoV of bin
    switch wtype
        case 'number'
    w = (numel(s)/numel(dataY)); % weighting
        case 'minSize'
            w = 1;
            if numel(s)<3; w = NaN; end
    end
    
    binStats(bs,1) = x*w;
    binStats(bs,2) = xv*w;
    binStats(bs,3) = x;
    binStats(bs,4) = xv;
    
    binData{bs} = dataY(s);
end
a = 1;