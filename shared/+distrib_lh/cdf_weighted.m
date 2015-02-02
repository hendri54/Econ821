function  [cumPctV, xSortV, cumTotalV] = cdf_weighted(xIn, wtIn, dbg)
% CDF for weighted data
%{
Returns the cdf for weighted data
Given n observations with values xIn and weights wtIn

cumPctV(1) is the wtIn of the smallest value
xSortV(1) is the smallest value
xSortV(i) is the i-th smallest value
cumPctV(i) is the cumulative weight of the i smallest values

IN:
  xIn     matrix of values
  wtIn
    matrix of weights for x-values
    Maybe scalar for unweighted data
    Handles zero weights

OUT:   (Row vectors)
 cumPctV
    Cumulative weights. 0 to 1
 xSortV
    Values for cumulative weights
    Really just sorted xIn
 cumTotalV
    Cumulative total values (mass * x)
    Where total mass is normalized to 1.

Change
   code is not efficient

TEST:     t_cdf_weighted.m
AUTHOR: Lutz Hendricks
%}

%%  Input check

x  = double(xIn(:));

if length(wtIn) == 1
   % Unweighted data
   wt = ones(size(x));

else
   wt = double(wtIn(:));

   % Round small weights to 0. Otherwise numerical problems arise
   wt(wt < 1e-10) = 0;
   
   % Drop 0 weights
   idxV = find( wt > 0 );
   if isempty(idxV)
      error('Zero weights');
   end
   wt = wt(idxV);
   x  = x(idxV);
end

if dbg > 10
   validateattributes(x,  {'double'}, {'finite', 'nonnan', 'nonempty', 'real'})
   validateattributes(wt, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
      'size', size(x)})
end


%%  Main

totalMass = sum(wt(:));

% Sort observations by x
tmp = sortrows([x(:), wt(:)], 1);

% cumulative weights
cumPctV = cumsum(tmp(:,2)');
% Scale so that weights sum to 1
cumPctV = cumPctV ./ cumPctV(end);

xSortV = tmp(:,1)';

% Cumulative totals
if nargout > 2
   cumTotalV = cumsum(tmp(:,2)' .* xSortV) ./ totalMass;
else
   cumTotalV = [];
end


%% Output check
if dbg > 10
   n = length(x);
   validateattributes(cumPctV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, ...
      '<=', 1, 'size', [1, n], 'increasing'})
   validateattributes(xSortV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      'size', [1, n], 'nondecreasing'})
end

end 
