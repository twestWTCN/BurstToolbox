function plot_BetaBursts_RP(R,BB)
subplot(2,3,3)
for cond = 1:length(R.condname)
    p(cond) = polarhistogram(BB.segRP{cond}(1,:),BB.range.RP); hold on
    p(cond).FaceColor = R.condcmap(cond,:);
    p(cond).FaceAlpha = 0.8;
    title([R.bandinits{3} ' Relative Phase']);
    pax = gca; pax.ThetaLim = [-180 180];
    pax.ThetaZeroLocation = 'Top';
    if cond == 3
        l = legend(p,R.condname);
        l.Position = [0.4702    0.8007    0.0826    0.0375];
    end
end

%Plot
subplot(2,3,2+3)
pcfg = [];
pcfg.cmap = R.condcmap;
pcfg.xlabel = [R.bandinits{3} ' Relative Phase']; 
pcfg.ylabel = '% Burst Anmplitude';
pcfg.title = ['% Amplitude by ' R.bandinits{3} ' Relative Phase'];
pcfg.lnames = R.condname;
pcfg.xlim = [-inf inf];
pcfg.ylim = [-inf inf]; %0.25*BB.plot.lims.wAmpPrc;
pcfg.compmat = [1 2];
pcfg.condplot = 1:3;

data{1} = BB.AmpPrc_binRP_data{1};
data{2} = BB.AmpPrc_binRP_data{2};
pvals = pvec_bin_TTest(data);
[HB,LEG] = plotGenBarPlot(pvals,BB.range.RP,squeeze(BB.AmpPrc_binRP),pcfg,1,1);

%Plot
subplot(2,3,3+3)
pcfg.xlabel = [R.bandinits{3} ' Relative Phase']; 
pcfg.ylabel = 'Burst PLV';
pcfg.title = ['% PLV by ' R.bandinits{3} ' Relative Phase'];
pcfg.ylim = [-inf inf]; %0.25*BB.plot.lims.PLV;

data{1} = BB.PLV_binRP_data{1};
data{2} = BB.PLV_binRP_data{2};
pvals = pvec_bin_TTest(data);
[HB,LEG] = plotGenBarPlot(pvals,BB.range.RP,squeeze(BB.PLV_binRP),pcfg,1,1);

set(gcf,'Position',[680  358  1048  622])
