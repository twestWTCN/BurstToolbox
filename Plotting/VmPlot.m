function hl = VmPlot(xin,A,s,cmap,marktype)
    vm=  @(b,x) ((exp(b(1).*cos(x-b(2))))./(2*pi*besselj(0,b(1))) ) + b(3);
    x = linspace(-pi,pi,50);
    y = vm(mean(s,2),x); yhat = vm(std(s,[],2)./sqrt(size(s,2)),x);
    [hl,hp] = boundedline(x,y,yhat);
    hl.Color = cmap;
    hl.LineWidth = 2;
    hp.FaceColor = cmap;
    hp.FaceAlpha = 0.2;
    hp.EdgeColor = cmap;
    hp.LineStyle = '--';
    hold on
    sc = scatter(repmat(binEdge2Mid(xin),1,size(A,2)),A(:),15,cmap,'filled','Marker',marktype);
    sc.MarkerFaceAlpha =1;
    