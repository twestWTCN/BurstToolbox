function tstar = textstar(P,alpha)
if P>alpha
    tstar = 'n.s.';
elseif P<(alpha/5/10)
    tstar = '***';
elseif P<(alpha/5)
    tstar = '**';
elseif P<alpha
    tstar = '*';
end
