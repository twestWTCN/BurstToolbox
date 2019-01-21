function b = rateHistogram(data,edges,duration,logflag)
if nargin<4
    logflag = 0;
end
if logflag == 1
    ncount = histcounts(log10(data),log10(edges));
else
    ncount = histcounts((data),(edges));
end
ncount = ncount/duration;
b = bar(edges(1:end-1),ncount,1);