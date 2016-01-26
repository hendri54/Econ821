function [k, y, r, wY, paramS] = cal_technology_olg2d(expS, cS)
% Calibrate technology parameters to match
%  interest rate and wage rate
%{
IN
   expS
      experiment settings (e.g. tax rates)
   cS
      constants
OUT
   k
      K/L (steady state)
   y
      output per worker
   r, wY
      household prices after tax
   paramS
      struct with calibrated (technology) parameters
%}

[paramS.A, paramS.ddk] = cal_tech_olg2d(cS.tgKY, cS.tgIntRate, ...
   cS.tgWageYoung, cS.capShare, expS.tauR, expS.tauW, cS.dbg);


% Fix k = K/L at level consistent with target K/Y
k = (paramS.A * cS.tgKY) ^ (1 / (1-cS.capShare));


% ***  Check that inputs are recovered
% Compute factor prices as faced by household
% Also check K/Y

[y, mpk, mpl] = prod_fct_olg2d(k, 1, paramS.A, cS.capShare, cS.dbg);
[r, wY] = hh_prices_olg2d(mpk, mpl, expS.tauR, expS.tauW, paramS.ddk, cS.dbg);
% Verify that calibration replicates targets
devV = [r, wY, k/y] ./ [cS.tgIntRate, cS.tgWageYoung, cS.tgKY] - 1;
if max(abs(devV)) > 1e-5
   warning('Large deviations from targets for (r, wY, k/y)');
   keyboard;
end


end