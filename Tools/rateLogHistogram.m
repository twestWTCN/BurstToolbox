function b = rateLogHistogram(data,edges,duration,logflag)
if nargin<4
    logflag = 0;
end
if logflag == 1
    data = log10(data);
end
ncount = histcounts((data),(edges));

ncount = ncount/duration;
b = bar(edges(1:end-1),ncount,1);

if logflag == 1
    a = gca;
    a.XTickLabel = sprintfc('%4.0f',10.^(a.XTick));
end