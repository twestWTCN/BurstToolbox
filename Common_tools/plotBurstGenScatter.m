function [sp,statV] = plotBurstGenScatter(Xcond,Ycond,pcfg)
colormap(pcfg.condcmap)



for cond = pcfg.condsel
    if ~isfield(pcfg,'szax')
        szax = 25;
    else
        szax =  pcfg.szax{cond}.*0.075;
    end
    if pcfg.logflag
        X = log10(Xcond{cond});
        Y = log10(Ycond{cond});
    else
        X = Xcond{cond};
        Y = Ycond{cond};
    end
    sp(cond) = scatter(X,Y,szax,pcfg.condcmap(cond,:),'filled'); hold on
    sp(cond).MarkerFaceAlpha = 0.7;
    [xCalc,yCalc,b,Rsq] = linregress(X',Y');
    plot(xCalc,yCalc,'color',pcfg.condcmap(cond,:),'LineWidth',2); ylim(pcfg.ylim); xlim(pcfg.xlim)
    statV{cond} = statvec(X',Y',2,pcfg.stat.zerointcpt);
end

legend(sp(pcfg.condsel),pcfg.legcont,'Location',pcfg.legloc);
ylabel(pcfg.ylabel);
xlabel(pcfg.xlabel);
xlim(pcfg.xlim); ylim(pcfg.ylim);
title(pcfg.title); %ylim(BB.plot.lims.burfreq )

