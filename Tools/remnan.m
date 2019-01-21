function [x y] = remnan(x,y)
if nargin<2
    x(isnan(x)) = [];
else
    x(isnan(y)) = []; y(isnan(y)) = [];
    y(isnan(x)) = []; x(isnan(x)) = [];
end