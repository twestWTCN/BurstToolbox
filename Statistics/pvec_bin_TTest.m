function pvec = pvec_bin_TTest(data)
for bs = 1:size(data{1},2)
    try
%         [dum pvec(bs)] = ttest2(data{1}{bs},data{2}{bs});
        [pvec(bs) dum] = ranksum(data{1}{bs},data{2}{bs});
    catch
        pvec(bs) = 1;
    end
end

% if mcomp == 1
%     pvec = pvec.*size(data{1},2);
% end