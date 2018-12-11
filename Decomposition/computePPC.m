function h = computePPC(X)
% X = remnan(X');
if size(X,1)>size(X,2)
    X = X';
end
if size(X,1)<2 || isempty(X)
    h = NaN;
    return
end

N = size(X,2);
for j = 1:N-1
    f = [];
    for k = j+1:N
        f(k) = cos(X(1,j))*cos(X(2,k)) + sin(X(1,j))*sin(X(2,k));
    end
    g(j) = sum(f);
end
h = (2*sum(g)) / (N*(N-1));
h = sqrt(abs(h));
% h = sqrt(h.^2);
% 
% % h = h.^2;
% 
% % h = sqrt(abs(h));