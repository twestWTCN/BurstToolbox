function [b,cf] = rateContour2D(data,edges,duration,cntlevs,cmap)
if nargin<4
    logflag = 0;
end

ncount = histcounts2(data(1,:),log10(data(2,:)),edges(1,:),edges(2,:));
ncount = ncount/duration;

mids(1,:) = binEdge2Mid(edges(1,:));
mids(2,:) = binEdge2Mid(edges(2,:));

midsHR(1,:) = linspace(mids(1,1),mids(1,end),size(mids,2)*5);
midsHR(2,:) = linspace(mids(2,1),mids(2,end),size(mids,2)*5);

[Xq,Yq] = meshgrid(midsHR(1,:),midsHR(2,:));
map = interp2(mids(1,:),mids(2,:),ncount,Xq,Yq,'spline');
[dum,b,cf] = contourf(Xq,Yq,map,cntlevs);
colormap(cmap);

box off
