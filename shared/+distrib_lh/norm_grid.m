function [xGridV, ubV] = norm_grid(xMean, xStd, probV, dbg)
% Approximate a Normal distribution on a grid
% such that grid point i has probability probV(i)
%{
OUT
   xGridV
      E(x) given x in interval of a grid point
%}
% -------------------------------------------

n = length(probV);

cumProbV = cumsum(probV);
if abs(cumProbV(n) - 1) > 1e-6
   error('Probabilities must sum to 1');
end


% Get grid bounds from Normal cdf
ubV = norminv(cumProbV(1 : (n-1)), xMean, xStd);

% Compute mean of truncated normal within each grid point
xGridV = zeros(size(probV));
for i1 = 1 : n
   if i1 == 1
      lb = [];
   else
      lb = ubV(i1-1);
   end
   if i1 == n
      ub = [];
   else
      ub = ubV(i1);
   end
   xGridV(i1) = distrib_lh.truncated_normal_lh(xMean, xStd, lb, ub, 0);
end


%% Output check
if dbg > 10
   validateattributes(xGridV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', size(probV)})
   validateattributes(ubV(:), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [n-1,1]})
end


end