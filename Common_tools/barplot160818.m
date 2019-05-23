function [HB,LEG] = barplot160818(R,binedge,bindata,pvals,degflag,mcompflag,baroffset)
if nargin<5
    degflag = 0;
end
if nargin<6
    mcompflag = 0;
end
if nargin<7
    baroffset = 0;
end

X =  binEdge2Mid(binedge);
for m = 1:size(bindata,2);for n = 1:length(X);  cmn(n,m,:) = R.condcmap(m,:); end;  end
if size(bindata,1) ==1
    cmn = R.condcmap;
end

sigpnts = [0.05, 0.01, 0.001, 0.0001];

if mcompflag == 1
    sigpnts = sigpnts./sum(pvals>0);
elseif mcompflag == 2
    [~, ~, ~, pvals] = fdr_bh(pvals);
end

rng = [1:size(bindata,1); size(bindata,1)+1:size(bindata,1)*2; size(bindata,1)*2+1:size(bindata,1)*3]';

if exist('pvals','var')
    if size(pvals,2)~= size(pvals,1)
            P = nan(size(bindata,1)*size(bindata,2));
        for i = 1:size(pvals,2)
            if pvals(i)<sigpnts(1)
                P(rng(i,1),rng(i,2)) = pvals(i);
                P(rng(i,2),rng(i,1)) = pvals(i);
            end
        end
    else
        P = pvals;
        P(P>sigpnts(1)) = NaN;
    end
end


if exist('P','var')
    HB = superbar(1:length(X),bindata(:,:,1),'E',bindata(:,:,2),'P',P,...
        'PStarShowNS',0,'PStarLatex','off','PStarIcon','*','BarFaceColor',cmn,...
        'PStarThreshold',sigpnts,...
        'PStarBackgroundColor','none',...
        'PLineOffset',baroffset); %m-by-n-by-3
else
    HB = superbar(1:length(X),bindata(:,:,1),'E',bindata(:,:,2),...
        'BarFaceColor',cmn);
end

a  = gca;
a.XTick = 1:1:length(X);
if degflag == 0
    a.XTickLabel = sprintfc('%4.0f',X(1:1:end));
elseif degflag == 1
    a.XTickLabel =  sprintfc('%.f',rad2deg(X(1:1:end)));
end
a.XTickLabelRotation = 45;
LEG = legend(HB(1,:),R.condname);
xlim([0 length(X)+1]); %ylim([0 inf])
box off

