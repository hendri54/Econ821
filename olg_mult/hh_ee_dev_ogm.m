function [eeDevV, cV] = ...
   hh_ee_dev_ogm(kPrimeV, a,  y, R, emuV, paramS, cS)
% Compute EE deviation for given state
% for a vector of k'
%{
If k' not feasible, return NaN

IN:
 kPrimeV
    Values of k' to consider
    Need not be on capital grid
 y
    Income
 R = (1+r)
 emuV
    Marginal utility tomorrow; by kPrimeV

OUT:
   cV
      Today's c for each k'
   eeDevV
      (u')^(-1) (beta * R * E u'(c')) - c
      This is the EE deviation scaled nicely
      eeDevV < 0  means  u'(c) > beta * R * E u'(c')  or  c too low
      eeDev is increasing in k' and decreasing in c

Not an efficient algorithm
%}

%% Input check

if cS.dbg > 10
   validateattributes(emuV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', size(kPrimeV)})
end

if a >= cS.aD
   error('Cannot compute EE dev for last period');
end

nkPrime = length(kPrimeV);


%% Main

% Today's c  for all k'
cV = y - kPrimeV;
cV(cV < cS.cFloor) = nan;

% Find feasible k'
kpIdxV = find(~isnan(cV));   

% Euler equation deviation for each kPrime
eeDevV = nan([nkPrime, 1]);
if ~isempty(kpIdxV)
   eeDevV(kpIdxV) = ces_inv_util_821(paramS.beta .* R .* emuV(kpIdxV), paramS.sigma, cS.dbg) ...
      - cV(kpIdxV);
end


%% Output check
if cS.dbg > 10
   if ~isempty(kpIdxV)
      validateattributes(cV(kpIdxV), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
         '<=', y})
      validateattributes(emuV(kpIdxV), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
         'positive'})
      validateattributes(eeDevV(kpIdxV), {'double'}, {'finite', 'nonnan', 'nonempty', 'real'})
   end
end


end
