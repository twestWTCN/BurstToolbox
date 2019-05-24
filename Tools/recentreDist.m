function [A K] = recentreDist(A)
A = reshape(A,size(A,1),[]);

for i = 1:size(A,2)
    Acol = A(:,i);
    % %     if cond==3; Acol =Acol(randperm(size(Acol,1))); end
    [dum,m] = max(Acol); % Max
    K = (median(1:size(A,1)))-m;
    A(:,i) = circshift(Acol,K,1);
end