function [emuOldV, muM, cM] = mu_old_olg2s(wOld, intRate, kGridV, paramS, cS)
% Compute marginal utility of the old
% as a function of old age "earnings" and wealth
%{
% IN:
%  wOld
%     old wage rate
%  kGridV
%     Possible wealth levels (1 x nk)
%  intRate
%     Interest rate
%  sig
%     Sigma. Curvature of utility function

OUT:
   emuOldV(k)
      Expected marginal utility when old
   muM(nk, nw)
      Marginal utility, by [wealth, old earnings state]
   cM
      consumption when old
%}
% -------------------------------------------

% Incomes of the old by state
yOldV = paramS.eOldV .* wOld;

% Number of old age wage states
ny = length(yOldV);
% Number of capital grid points
nk = length(kGridV);

% Household consumption = income
cM = (1 + intRate) .* (kGridV(:) * ones(1, ny))  +  ...
   (ones(nk,1) * yOldV(:)');
% Bound consumption away from 0
cM = max(cS.cFloor, cM);

muM = ces_util_821(cM, paramS.sigma, cS.dbg);


% Compute expected marginal utility on wealth grid
emuOldV = zeros([cS.nk, 1]);
for ik = 1 : cS.nk
   emuOldV(ik) = sum(paramS.eOldProbV .* muM(ik,:)');
end


end
