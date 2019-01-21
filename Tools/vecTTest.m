function p = vecTTest(A)
for i = 1:size(A,1)
    try
        p(1,i) = ranksum(A(i,:,1),A(i,:,2));
        statv = statvec(squeeze(A(i,:,1)),squeeze(A(i,:,2)),1);
        [dum,p(2,i)] = ttest(A(i,:,1),A(i,:,2));
    catch
        p(1,i) = NaN;
    end
    %     [dum p(2,i)] = ttest(A(i,:,1),A(i,:,2));
end