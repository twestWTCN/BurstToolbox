function [HB,LEG] = plotGenBarPlot(pvals,binedge,bindata,pcfg,degflag,mcompflag,baroffset)
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
for m = 1:size(bindata,3);for n = 1:length(X);  cmn(n,m,:) = pcfg.cmap(m,:); end;  end

if size(bindata,1) ==1
    cmn = pcfg.cmap;
end
bindata = permute(bindata,[1 3 2]);
bindata = bindata(:,pcfg.condplot,:);

[P,sigpnts] = computeBarPVMatrix(pvals,size(bindata),pcfg.compmat,mcompflag);

if exist('P','var')
    HB = superbar(1:length(X)+1,bindata(:,:,1),'E',bindata(:,:,2),'P',P,...
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
    a.XTickLabel = sprintfc('%4.1f',X(1:1:end));
elseif degflag == 1
    a.XTickLabel =  sprintfc('%.f',rad2deg(X(1:1:end)));
end
a.XTickLabelRotation = 45;
LEG = legend(HB(1,:),pcfg.lnames);
xlim([0 length(X)+1]); %ylim([0 inf])
box off

title(pcfg.title);
ylabel(pcfg.ylabel);
xlabel(pcfg.xlabel)
xlim(pcfg.xlim)
ylim(pcfg.ylim)
