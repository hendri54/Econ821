function a = integ1(xV, fv, dbg)
% Integrate by simple linear interpolation 
%{
TASK:
   Given a set of x values with corresponding f(x)'s
   Compute the approximate area under the curve
   For each interval: Use width*(avg height) and add it all up.

IN:
   xV, fv   x and f(x) values
            xV must be increasing

OUT:
   a           approximate area

TEST:  t_integ1

CHANGE:   Use more sophisticated interpolation algorithm

AUTHOR: Lutz Hendricks, 1996
%}

%% Input check
if dbg > 10
   if any(diff(xV) <= 0)
      error('x must be increasing');
   end
end


%% Main

n = length( xV );

a = sum(diff(xV) .* (fv(2:n) + fv(1:(n-1))) ./ 2);

validateattributes(a, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar'})


end