function b = rateLogHistogram2D(data,edges,duration,logflag)
if nargin<4
    logflag = 0;
end
if logflag == 1
    data = log10(data);
end

ncount = histcounts2(data(1,:),log10(data(2,:)),edges(1,:),edges(2,:));
ncount = ncount/duration;
b = bar3(ncount); 

