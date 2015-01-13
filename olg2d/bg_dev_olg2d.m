function [bgDev, y, r, wY, aggrS, cY, cO] = bg_dev_olg2s(k, inputS, olg2dS, paramS);
% Deviation from steady state conditions

% IN:
%  k = K/L  Guess
%  inputS
%     Structure with other input arguments
%     Tax rates
%     .tauR
%     .tauW
%     Other
%     .dbg
%     .wOld
%        Transfer to the old

% OUT:
%  bgDev
%     Deviation from steady state
%  y
%     Output (y = Y/N)
%  r, wY
%     Prices faced by household
%  aggrS
%     Aggregate saving = k (1+n)
%  cY, cO
%     Consumption when young/old

% --------------------------------------------

if nargin ~= 4
   error('Invalid nargin');
end

dbg = inputS.dbg;

% Marginal products
[y, mpk, mpl] = cobb_douglas_604(k, 1, olg2dS.capShare, paramS.A, dbg);

% Household prices
r  = (1 - inputS.tauR) .* mpk - paramS.ddk;
wY = (1 - inputS.tauW) .* mpl;


% Solve household problem for each type
[cY, cO] = hh_solve_olg2d(wY, inputS.wOld, r, 0, olg2dS, paramS, dbg);

% Compute aggregate saving (per capita young)
aggrS = (wY - cY) ./ (1 + olg2dS.popGrowth);

% Deviation from capital market clearing
bgDev = k ./ aggrS - 1;

% *****  eof  *******
