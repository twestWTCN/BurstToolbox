function clustat = plotFreqCluster(stat)
alpha = 0.05;
a = gca;
linelist = findobj(a.Children,'type','Patch');
    hz = stat.freq;
for i = 1:numel(linelist); sigpow(i) = max(linelist(i).YData); end
    sigpow = max(sigpow)*1.1; sigpow = repmat(sigpow,size(hz));
clustat = [];
if sum(stat.mask)>0
    for i = 1:size(stat.posclusters,2)
        if stat.posclusters(i).prob<alpha
            labs = stat.posclusterslabelmat;
            group = find(labs==i);
            hold on
            if length(group)<2
                scatter(hz(group),sigpow(group),'ks','filled');
            else
                plot(hz(group),sigpow(group),'k','linewidth',6);
            end
            freqcen = hz(fix(mean(group)));
            if min(hz(group))<6
                shift = 3;
            else
                shift = 5;
            end
            
            [figx figy] = dsxy2figxy(gca, freqcen-shift, (max(sigpow)*1.15));
            if ~isnan(figx)
                h = annotation('textbox',[figx figy .01 .01],'String',{['(+) P = ' num2str(stat.posclusters(i).prob,'%.3f')]},'FitBoxToText','on','LineStyle','none','fontsize',8,'fontweight','bold');
                clustat = [clustat; min(stat.freq(1,group)) max(stat.freq(1,group)) stat.posclusters(i).clusterstat stat.posclusters(i).prob];
            end
        end
    end
    for i = 1:size(stat.negclusters,2)
        if stat.negclusters(i).prob<alpha
            labs = stat.negclusterslabelmat;
            group = find(labs==i);
            hold on
            if length(group)<2
                scatter(hz(group),sigpow(group),'ks','filled');
            else
                plot(hz(group),sigpow(group),'k','linewidth',6);
            end
            freqcen = hz(fix(mean(group)));
            if min(hz(group))<6
                shift = 3;
            else
                shift = 5;
            end
            
            [figx figy] = dsxy2figxy(gca, freqcen-shift, (max(sigpow)*1.15));
            if ~isnan(figx)
                h = annotation('textbox',[figx figy .01 .01],'String',{['(-) P = ' num2str(stat.negclusters(i).prob,'%.3f')]},'FitBoxToText','on','LineStyle','none','fontsize',8,'fontweight','bold');
                clustat = [clustat; min(stat.freq(1,group)) max(stat.freq(1,group)) stat.negclusters(i).clusterstat stat.negclusters(i).prob];
            end
        end
    end
end
