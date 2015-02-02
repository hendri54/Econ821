function [massV, lbV, ubV] = norm_grid_lh(xV, xMin, xMax, mu, sig, dbg)
% Approximate a Normal distribution on a given grid
%{
Given:
   A Normal distribution with parameters mu, sig
   A grid of points (xV)
Return the mass in the interval around each xV
implied by N(mu, sig)
where the Normal is truncated at [xMin, xMax]

This only works well if the grid is sufficiently tight

IN:
   xMin, xMax
      Lower bound of smallest interval and
      upper bound of largest  interval

OUT:
    massV
      Mass on each grid point
      Not a density. DensityV(i) = massV(i) / (ubV(i) - lbV(i));
   lbV, ubV
      Interval lower / upper bounds

% checked: 2011-oct-13
%}

%% Input check

if nargin ~= 6
   error([ mfilename, ': Invalid nargin' ]);
end

n = length(xV);
if dbg > 10
   if any( xV(2:n) < xV(1:n-1) )
      warnmsg([ mfilename, ':  xV not increasing' ]);
      keyboard;
   end
   if xMin > xV(1)  ||  xMax < xV(n)
      warnmsg([ mfilename, ':  Invalid xMin or xMax' ]);
      keyboard;
   end
   if mu < xMin  ||  mu > xMax
      warnmsg([ mfilename, ':  Invalid mu' ]);
      keyboard;
   end
end


%% Main

% Construct interval boundaries
% Symmetric around xV
xMidV = 0.5 .* (xV(1:n-1) + xV(2:n));
lbV = [xMin; xMidV(:)];
ubV = [xMidV(:); xMax];

% Find mass in each interval
cdfV = normcdf( [xMin; ubV], mu, sig );

massV = cdfV(2:(n+1)) - cdfV(1:n);
massV = massV(:) ./ sum(massV);


%% Output check
if dbg > 10
   validateattributes(massV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [n,1], ...
      '>=', 0, '<=', 1})
   validateattributes(lbV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [n,1], ...
      '>=', xMin, '<=', xMax})
   validateattributes(ubV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [n,1], ...
      '>=', xMin, '<=', xMax})
   if any(ubV < lbV)
      error('ubV < lbV');
   end
end


end