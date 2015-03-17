function prGridV = cdf_lh(xV, xGridV, dbg)
% Cdf of data in xV
%{
No interpolation. Simply return the fraction of xV strictly below each xGridV point

IN:
 xV
    Some data
 xGridV
    Return cdf for this x grid

OUT:
 prGridV
    prGridV(j) = Pr(xV <= xGridV(j))
%}

% No of obs in each interval
%  Last point matches xGridV(end)
nGridV = histc(xV(:), [min(xV) - 1; xGridV(:)]);

prGridV = cumsum(nGridV(1 : (end-1))) ./ length(xV(:));

if dbg > 10
   validateattributes(prGridV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      '>=', 0, '<=', 1, 'size', [length(xGridV), 1]})
end


end