function [bgDev, outS] = bg_dev_olg2s(k, inputS, paramS, cS)
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
    .wOld
       Transfer to the old

OUT:
 bgDev
    Deviation from steady state
 y
    Output (y = Y/N)
 r, w
    Prices faced by household
 aggrS
    Aggregate saving = k (1+n)
 cYV, sV
    Household policy functions, by ieY
%}

if nargin ~= 4
   error('Invalid nargin');
end

outS.k = k;

% Marginal products and output per young (y = Y/N)
% Aggregate K / N
outS.lPerYoung = sum(paramS.eYV .* paramS.eYProbV);
KN = k .* outS.lPerYoung;
[outS.y, mpk, mpl] = prod_fct_olg2s(KN, outS.lPerYoung, paramS.A, cS.capShare, cS.dbg);

% Household prices
[outS.r, outS.w] = hh_prices_olg2s(mpk, mpl, inputS.tauR, inputS.tauW, paramS.ddk, cS.dbg);


% Solve household problem for each labor endowment
[outS.cyV, outS.sV] = hh_solve_olg2s(outS.w, inputS.wOld, outS.r, paramS, cS);

% Compute aggregate saving (per capita young)
outS.aggrS = sum(paramS.eYProbV(:) .* outS.sV(:));

% Deviation from capital market clearing
bgDev = (KN .* (1 + cS.popGrowth) - outS.aggrS) ./ max(1, outS.aggrS);


end
