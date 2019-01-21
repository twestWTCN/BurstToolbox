function [xq yq R2 s stdeqv] = VMfit(x,y,xn,plotop)

k = 1; % dispersion (1/k ~ std)
mu = 0; % centre
yofs = 2; % y ofset
vmfun = @(b,x) ((exp(b(1).*cos(x-b(2))))./(2*pi*besselj(0,b(1))) ) + b(3);    % Function to fit

fcn = @(b) sum((vmfun(b,x) - y).^2);                              % Least-Squares cost function
options = optimset('MaxFunEvals',1e6);
[s] = fminsearchcon(fcn, [k,mu,yofs],[-1e3 -pi -100],[1e3,pi,100],[],[],[],options)       ;                % Minimise Least-Squares
yfit = vmfun(s,x);
xq = linspace(min(x),max(x),xn);
yq = vmfun(s,xq);

if plotop == 1
    plot(x,y,'b',  xq,yq, 'r')
    grid
end
SSres = (y-yfit).^2;
SStot = (y-mean(y)).^2; % total sum of squares (variance)
R2 = sum(SSres)/sum(SStot);

stdeqv = sqrt(abs(1/s(1))); % Equivalent to the standard deviation

