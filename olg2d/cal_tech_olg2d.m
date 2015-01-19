function [pA, ddk] = cal_tech_olg2d(tgKY, tgIntRate, tgWageYoung, capShare, tauR, tauW, dbg)
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

pA = (tgWageYoung ./ (1 - capShare) ./ (1 - tauW)) .^ (1 - capShare) ...
   .*  tgKY .^ (-capShare);


%% Self-test
if dbg > 10
   validateattributes(pA,  {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', 'scalar'})
   validateattributes(ddk, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', 'scalar'})
end


end
