function BB = computeBetaBurstRPStats(R,BB,F,plotop)
cnt = 0;
for band = 3
    cnt = cnt +1;
    for cond = 1:length(R.condname)
        
        if isequal([3 1],[band cond]); BB.Seg_binRP = []; BB.PLV_binRP = []; end
        for bs = 1:numel(BB.range.RP)-1
            if size(BB.segRP{cond}(:),1)>1
            s = find(BB.segRP{cond}(band,:)>=BB.range.RP(bs) & BB.segRP{cond}(band,:)<BB.range.RP(bs+1));
            else
                s = 1; band = 1;
            end
            % Unnormalized
            w = (numel(s)/numel(BB.segA_save{cond}));
            if numel(s)<2; w = 0; end
            x  = nanmean(BB.segA_save{cond}(s));
            xv = nanstd(BB.segA_save{cond}(s))/sqrt(numel(s));
            
            BB.Amp_binRP(bs,band,cond,1) = w*x;
            BB.Amp_binRP(bs,band,cond,2) = w*xv;
            BB.Amp_binRP_data{cond}{bs} = BB.segA_save{cond}(s);
            
            % Percentage Deviation
            w = numel(s)/numel(BB.segAPrc_save{cond});
            if numel(s)<2; w = 0; end
            x  = nanmean(BB.segAPrc_save{cond}(s));
            xv = nanstd(BB.segAPrc_save{cond}(s))/sqrt(numel(s));
            
            BB.AmpPrc_binRP(bs,band,cond,1) = w*x;
            BB.AmpPrc_binRP(bs,band,cond,2) = w*xv;
            BB.AmpPrc_binRP_data{cond}{bs} = BB.segAPrc_save{cond}(s);
            
            x = nanmean(BB.segPLV{cond}(:,band,s));
            xv = nanstd(BB.segPLV{cond}(:,band,s))/sqrt(numel(s));
            BB.PLV_binRP(bs,band,cond,1)  = w*x;
            BB.PLV_binRP(bs,band,cond,2) = w*xv;
            BB.PLV_binRP_data{cond}{bs} = BB.segPLV{cond}(s);
        end       
    end
end
