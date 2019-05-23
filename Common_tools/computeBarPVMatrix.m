function [P,sigpnts] = computeBarPVMatrix(pvals,datdim,compmat,mcompflag)
sigpnts = [0.05, 0.01, 0.001, 0.0001];

for cmpi = 1:size(compmat,1)
    if mcompflag == 1
        sigpnts = sigpnts./sum(pvals(cmpi,:)>0); % bonferonni
    elseif mcompflag == 2
        [~, ~, ~, pvals(cmpi,:)] = fdr_bh(pvals(cmpi,:)); % false-discovery-rate
    end
end
% M groups of N vertical bars (i.e. 3 conditions by 8 bins MxN = 3x8
% P is a symmetric matrix sized (N*M)-by-(N*M) adds
rng = [1:datdim(1); datdim(1)+1:datdim(1)*2; datdim(1)*2+1:datdim(1)*3]';

if exist('pvals','var')
    P = nan(datdim(1)*datdim(2));
    for cmpi = 1:size(compmat,1)
        if size(pvals,2)~= size(pvals,1)
            for i = 1:size(pvals,2)
                if pvals(cmpi,i)<sigpnts(1)
                    P(rng(i,compmat(cmpi,1)),rng(i,compmat(cmpi,2))) = pvals(cmpi,i);
                    P(rng(i,compmat(cmpi,2)),rng(i,compmat(cmpi,1))) = pvals(cmpi,i);
                end
            end
        else
            P = pvals;
            P(P>sigpnts(1)) = NaN;
        end
    end
end