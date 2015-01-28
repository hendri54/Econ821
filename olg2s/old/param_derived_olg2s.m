function paramS = param_derived_olg2s(paramS, calNo, expNo)
% Derived model params
% ---------------------------------------

cS = const_olg2s(calNo);


%% Capital grid

budgetS = hh_budget_olg2s(cS.tgWageYoung, cS.tgWageOld, cS.tgIntRate, paramS, cS);

kMin = 1e-2;
kMax = max(budgetS.sMaxV) * 20;
paramS.kGridV = linspace(kMin, kMax, cS.nk);

end