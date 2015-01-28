function [yM, mpkM, mplM] = prod_fct_olg2s(kM, lM, pA, capShare, dbg)
% Production function
%{
IN
   kM, lM
      capital and labor inputs
   pA, capShare
      productivity and capital share parameters

OUT
   yM
      output
   mpkM, mplM
      marginal products
%}
% ------------------------------------------

if capShare > 0.99  ||  length(capShare) ~= 1
   error('Invalid capShare');
end

yM = pA .* kM .^ capShare .* lM .^ (1-capShare);
mpkM = capShare .* yM ./ kM;
mplM = (1-capShare) .* yM ./ lM;


%% Output check
if dbg > 10
   validateattributes(mpkM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', 'size', size(kM)})
   validateattributes(mplM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', 'size', size(kM)})
end

end