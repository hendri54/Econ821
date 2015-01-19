function [bgDev, y, r, wY, aggrS, cY, cO] = bg_dev_olg2d(k, inputS, paramS, cS)
% Deviation from steady state conditions
%{
IN:
 k = K/L  Guess
 inputS
    Structure with other input arguments
    Tax rates
    .tauR
    .tauW
    Other
    .dbg
    .wOld
       Transfer to the old

OUT:
 bgDev
    Deviation from steady state
 y
    Output (y = Y/N)
 r, wY
    Prices faced by household
 aggrS
    Aggregate saving = k (1+n)
 cY, cO
    Consumption when young/old
%}
% --------------------------------------------

if nargin ~= 4
   error('Invalid nargin');
end

% Marginal products
[y, mpk, mpl] = prod_fct_olg2d(k, 1, paramS.A, cS.capShare, cS.dbg);

% Household prices
[r, wY] = hh_prices_olg2d(mpk, mpl, inputS.tauR, inputS.tauW, paramS.ddk, cS.dbg);


% Solve household problem for each type
[cY, cO, saving] = hh_solve_olg2d(wY, inputS.wOld, r, 0, paramS, cS);

% Compute aggregate saving (per capita young)
aggrS = saving ./ (1 + cS.popGrowth);

% Deviation from capital market clearing
bgDev = aggrS - k;

end
