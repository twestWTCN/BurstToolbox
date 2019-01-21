function a3WayBarPlot(R,X,ofs)
% assumes X has dimensions 1 x N x cond
p = [];
p(1) = ranksum(squeeze(X(1,:,1)),squeeze(X(1,:,2)));
p(2) = ranksum(squeeze(X(1,:,1)),squeeze(X(1,:,3)));
statv = statvec(squeeze(X(1,:,1)),squeeze(X(1,:,2)),1);

P = nan(3);
P(1,2) = p(1);
P(2,1) = p(1);
P(1,3) = p(2);
P(3,1) = p(2);

bptmp(:,:,1) = nanmean(squeeze(X(1,:,:)));
bptmp(:,:,2) = nanstd(squeeze(X(1,:,:)))/sqrt(sum(~isnan(squeeze(X))));

[HB,LEG] = barplot160818(R,1:4,bptmp,P,0,2,ofs);
a = gca;
a.XTickLabel = R.condname; a.XTickLabelRotation = 0;
delete(LEG);