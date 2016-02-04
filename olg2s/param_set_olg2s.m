function paramS = param_set_olg2s(calNo)
% Make a struct with possibly calibrated parameters
%{
Used for defaults
Calibrated params are overwritten by calibration algorithm
Better: use pvectorLH object
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

validateattributes(paramS.eOldV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, 'size', [cS.nw, 1]})
checkLH.prob_check(paramS.eOldProbV, 1e-6);

% Young
paramS.eYV = paramS.eOldV;
paramS.eYProbV = paramS.eOldProbV;

validateattributes(paramS.eYV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, 'size', [cS.nw, 1]})
checkLH.prob_check(paramS.eYProbV, 1e-6);


%% Capital grid

budgetS = hh_budget_olg2s(cS.tgWageYoung, cS.tgWageOld, cS.tgIntRate, paramS, cS);

kMin = 1e-2;
kMax = max(budgetS.sMaxV) * 20;
paramS.kGridV = linspace(kMin, kMax, cS.nk);



end