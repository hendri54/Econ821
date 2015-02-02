function [meanL, varL] = truncated_normal_lh(muL, sigmaL, lb, ub, dbg)
% Return mean and variance of truncated normal
%{
% IN:
%  mu, sigma
%  lb, ub
%     Interval of truncation
%     lb or ub can be empty for one-sided truncation

Scalar inputs only

No problem to set lb or ub to []
% Source: wikipedia entry
%}
% ------------------------------------------------------

%% Input check
if length(muL) ~= 1  ||  length(sigmaL) ~= 1  ||  length(lb) > 1  ||  length(ub) > 1
   error('Scalar inputs only');
end

if dbg > 10
   inputV = [muL; sigmaL; lb; ub];
   if any(isnan(inputV))  ||  any(isinf(inputV))
      error('Invalid inputs');
   end
end


%% Main

if ~isempty(lb)
   normLb = (lb - muL) ./ sigmaL;
   pdf1 = normpdf(normLb, 0, 1);
   cdf1 = normcdf(lb, muL, sigmaL);
end


if ~isempty(ub)
   normUb = (ub - muL) ./ sigmaL;
   pdf2 = normpdf(normUb, 0, 1);
   cdf2 = normcdf(ub, muL, sigmaL);
end


if isempty(lb)  &&  isempty(ub)
   meanL = muL;
   varL  = sigmaL .^ 2;


elseif isempty(lb)
   % One sided truncation: X < ub
   lambda = pdf2 ./ cdf2;
   meanL = muL - sigmaL .* lambda;
   varL  = (sigmaL .^ 2) .* (1 - normUb .* lambda - lambda .^ 2);


elseif isempty(ub)
   % One sided truncation: X > lb
   lambda = pdf1 ./ (1 - cdf1);
   %delta  = lambda .* (lambda - normLb);

   meanL = muL + sigmaL .* lambda;
   varL  = (sigmaL .^ 2) .* (1 + normLb .* lambda - lambda .^ 2);

else
   % Two sided truncation
   meanL = muL - sigmaL .* (pdf1 - pdf2)  ./  (cdf1 - cdf2);

   term1 = (normUb .* pdf2 - normLb .* pdf1) ./ (cdf2 - cdf1);
   term2 = (pdf2 - pdf1) ./ (cdf2 - cdf1);
   varL  = (sigmaL .^ 2) .* (1 - term1 - term2 .^ 2);
end


%% Output check
if varL < 0
   error('Negative varL');
end
if isnan(meanL)  ||  isinf(meanL)  ||  isnan(varL)
   error('Invalid meanL');
end

end