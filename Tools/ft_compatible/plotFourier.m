data.trial = data.xsims_gl;
close all
X = [data.trial{:}];
shift = std(X(:))*6;
for  i =1:size(data.labels,2)
    plot(data.time,data.trial{1}(i,:) - ((i-1).*shift))
    hold on    
end

legend(data.labels)