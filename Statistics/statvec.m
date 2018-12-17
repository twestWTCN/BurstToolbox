function stvec = statvec(x,y,type)
if type == 1
    x(isnan(x)) = []; y(isnan(y)) = [];
    [dum npt(1) ci] = ttest2(x,y);
    [npt(2) dum stats] = ranksum(x,y);
    xbar = mean(x); xhat = std(x)/sqrt(length(x));
    ybar = mean(y); yhat = std(y)/sqrt(length(y));
    xybar = xbar-ybar;
    
    stvec = [xbar xhat ybar yhat xybar ci npt(2)];
    
elseif type == 2
    for i = 1:size(x,2)
        x1 = x{i};
        y1 = y{i};
        [x1 y1] = remnan(x1,y1);
        [R P] = corr(x1',y1','type','Spearman');
        [xCalc yCalc b Rsq] = linregress(x1',y1',1);
        stvec(:,i) = [b Rsq R P];
    end
    
end

