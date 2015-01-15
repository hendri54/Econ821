function [pMeanV, pUpperV, pTotalV] = pcnt_weighted(xIn, wIn, clUbV, dbg)
% Returns means and upper bounds of percentile classes defined by
% upper bounds in clUbV
%{
KEY: A single observation is partly attributed to multiple
classes, if its weight crosses class boundaries.
We basically interpolate the cdf

xIn
 matrix of values
wIn
 matrix of weights for x-values
 may be scalar for unweighted data
 Note: Total mass matters for pTotalV
clUbV
 vector of percentiles (upper bounds); e.g. 0.20,0.40,0.60,0.80 for quintiles
 last one (1) can be ignored and will be added automatically

OUT: (row vectors)
 pUpperV
    Values of xIn at upper bounds of percentile classes
 pMeanV
    Means of percentile classes
 pTotalV
    Mass (wt * x) in each class

TEST:  t_pcnt_weighted
%}
% ----------------------------------------------


%% Input check

clUbV = clUbV(:)';

if dbg > 10
   if length(wIn) ~= 1
      if ~isequal(size(xIn), size(wIn))
         disp( size(xIn) );
         disp( size(wIn) );
         error([ mfilename, ':  Size mismatch' ]);
      end
   end
   % Make sure pcnt has the right scale
   validateattributes(clUbV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', '<=', 1})
end


% Add the 100 percentile
N = length(clUbV);
if clUbV(N) < 0.9999
   N = N + 1;
end
clUbV(N) = 1;


%%  Compute cdf

% Outputs row vectors
[cumPctV, xSortV, cumTotalV] = distrib_lh.cdf_weighted(double(xIn), double(wIn), dbg);

% Interpolate cdf: percentile upper bounds
if cumPctV(1) > clUbV(1)
   % Assume that lowest obs goes all the way to 0 mass
   cumPctV = [0, cumPctV];
   xSortV  = [xSortV(1), xSortV];
   cumTotalV = [0, cumTotalV];
end
pUpperV = interp1(cumPctV, xSortV, clUbV, 'linear');

% Total in each class
pCumTotalV = interp1(cumPctV, cumTotalV, clUbV, 'linear');
pTotalV = diff([0, pCumTotalV]);

% Mass in each class
pMassV = diff([0, clUbV]);

% Class means
pMeanV = pTotalV ./ pMassV;





%%  Self test
if dbg > 10
   validateattributes(pUpperV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', size(clUbV)})
   validateattributes(pMeanV,  {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', size(clUbV)})
end


end