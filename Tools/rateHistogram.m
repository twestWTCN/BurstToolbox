function b = rateHistogram(data,edges,duration,logflag)
if nargin<4
    logflag = 0;
end
if logflag == 1
    data= log10(data);
    edges = log10(edges);
end
 ncount = histcounts(data,edges);
ncount = ncount/duration;
b = bar(edges(1:end-1),ncount,1);
