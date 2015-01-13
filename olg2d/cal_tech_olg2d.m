function [A, ddk] = cal_tech_olg2d(tgKY, tgIntRate, tgWageYoung, capShare, tauR, tauW, dbg);
% Calibrate technology parameters (A and ddk)
% to match interest rate and wage rate
% at target K/Y

% Depreciation is not tax deductible
%  r = (1 - tauR) * mpk - ddk
% -------------------------------------------


% f'(k)
mpk = capShare / tgKY;

% Depreciation rate matches after-tax interest rate
ddk = (1 - tauR) .* mpk - tgIntRate;

A = (tgWageYoung ./ (1 - capShare) ./ (1 - tauW)) .^ (1 - capShare) ...
   .*  tgKY .^ (-capShare);

% *** eof ***
