function [xCalc yCalc b Rsq bHd RsqHd WhitePval ] = linregress(X,Y,zerocept)
if nargin<3
    zerocept = 0;
end
Y(isnan(X)) = []; X(isnan(X)) = [];
X(isnan(Y)) = []; Y(isnan(Y)) = [];

if zerocept ==1
    X = X;
else
    X = [ones(length(X),1) X];
end
b = X\Y;
yCalc = X*b;
Rsq = 1 - sum((Y - yCalc).^2)/sum((Y - mean(Y)).^2);

% test for heteroscedasticity of residuals
if nargout>4
    res = abs(Y - yCalc);
    [dum dum bHd RsqHd] = linregress(X,res,0);
    
    adjRsqHd = ((1-RsqHd)*(size(X,1)-1))/(size(X,1)-1-1);
    adjRsqHd = 1-adjRsqHd;
    RsqHd = adjRsqHd;
    WhitePval = 1-chi2cdf(adjRsqHd*size(X,1),2);
    
%     Rhd = Bhd(2);
%     Rhd = size(X,2)*Rhd;
%     [dum dum stat] = archtest(Y - yCalc);
end
if zerocept ==1
    xCalc = X(:,1);
else
    xCalc = X(:,2);
end