function plotTimeSeries(data)
figure
X = [data.trial{:}];
shift = std(X(:))*6;
for  i =1:size(data.label,2)
   plot(data.time{1},data.trial{1}(i,:) - ((i-1).*shift))
    hold on    
end

legend(data.label)
