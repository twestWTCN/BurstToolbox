function binmid = binEdge2Mid(binedge)
binmid = binedge(1:end-1) + ((binedge(2)-binedge(1))/2);
