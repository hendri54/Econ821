function [cOld, saving] = hh_budget_olg2d(cY, wY, wOld, r)
% Household budget constraint
% ------------------------------------

saving = wY - cY;
cOld = (1 + r) .* saving + wOld;


end