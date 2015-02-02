function xAggr = aggr_hist_ogm(xHistM, ageMassV, dbg)
% Compute aggregate xAggr from individual
% histories xHistM(ind, age)
%{
Assumes each age has same mass and total mass
of households is 1
Then aggregate is simply unweighted average
across all simulated observations
%}
% --------------------------------------------

if nargin ~= 3
   error('Invalid nargin');
end

aD = length(ageMassV);

% Make sure assumptions are correct
if max(abs(ageMassV - 1 ./ aD)) < 1e-6
   xAggr = mean(xHistM(:));
else
   error('Not implemented for this age mass distribution');
end

if dbg > 10
   validateattributes(xAggr, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar'})
end

end