function paramS = param_set_olg2s(calNo)
% Make a struct with possibly calibrated parameters
%{
Used for defaults
Calibrated params are overwritten
%}
% ---------------------------------------

cS = const_olg2s(calNo);

paramS.A = 3;
paramS.ddk = 0.3;
paramS.beta = 1.1;
paramS.sigma = 2;


%% Labor endowments (arbitrary)

paramS.eOldProbV = linspace(1, 2, cS.nw);
paramS.eOldProbV = paramS.eOldProbV(:) ./ sum(paramS.eOldProbV);
paramS.eOldV = linspace(1, 2, cS.nw)';
% Set mean to 1
eMean = sum(paramS.eOldV .* paramS.eOldProbV);
paramS.eOldV = paramS.eOldV ./ eMean;

paramS.eYV = paramS.eOldV;
paramS.eYProbV = paramS.eOldProbV;


%% Capital grid

budgetS = hh_budget_olg2s(cS.tgWageYoung, cS.tgWageOld, cS.tgIntRate, paramS, cS);

kMin = 1e-2;
kMax = max(budgetS.sMaxV) * 20;
paramS.kGridV = linspace(kMin, kMax, cS.nk);



end