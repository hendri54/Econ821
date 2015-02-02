function [pA, ddk] = cal_tech_ogm(tgKY, tgIntRate, tgWage, capShare, cS)
% Calibrate technology parameters (A and ddk)
% to match interest rate and wage rate (pre tax)
% at target K/Y
% -------------------------------------------


% f'(k)
mpk = capShare / tgKY;

% Depreciation rate matches pre-tax interest rate
ddk = mpk - tgIntRate;

pA = (tgWage ./ (1 - capShare)) .^ (1 - capShare) ...
   .*  tgKY .^ (-capShare);


%% Self-test
if cS.dbg > 10
   validateattributes(pA,  {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', 'scalar'})
   validateattributes(ddk, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', 'scalar'})
end


end
