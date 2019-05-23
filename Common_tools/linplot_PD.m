function [A stat] = linplot_PD(a,b,xlab,ylabl,cmapr)
a(isnan(b)) = []; b(isnan(b)) = [];
b(isnan(a)) = []; a(isnan(a)) = [];

[R p] = corr(a,b,'Type','Pearson');
A = scatter(a,b,30,'o','filled','MarkerFaceColor',cmapr); hold on
[cof,stats] = robustfit(a,b);
% R_rob = corr(b,cof(1)+cof(2)*a)
if stats.p(2)<0.05
    [xCalc yCalc ba Rsq] = linregress(a,b);
    %     [b1 stats] = robustfit(a,b)
    hold on; plot(xCalc,yCalc,'-','LineWidth',1.5,'color',cmapr)
    %     annotation(gcf,'textbox',...
    %         [0.4100    0.7310    0.4810    0.1900],...
    %         'String',{sprintf('y = %0.3f + %0.3fx',ba),sprintf('R^2 = %0.2f',Rsq),sprintf('P = %0.3f',p(1))},...
    %         'HorizontalAlignment','right',...
    %         'LineStyle','none',...
    %         'FontWeight','bold',...
    %         'FontSize',12,...
    %         'FitBoxToText','off');
else
    A = [];
    p = 1;
    r = 0;
    ba = [0 0];
    Rsq = 0;
end
    xlabel(xlab,'FontSize',13); ylabel(ylabl,'FontSize',16)

stat.p = p;
stat.Rcoeff = R;

stat.p_rob = stats.p(2);
sse = stats.dfe * stats.robust_s^2;
phat = cof(1)+cof(2)*a;
ssr = norm(phat-mean(phat))^2;
stat.R_rob = sqrt(1- sse/(sse+ssr));


stat.modcoef = ba;
stat.Rsq = Rsq;


grid on
set(gcf,'Position',[733   678   451   420])
