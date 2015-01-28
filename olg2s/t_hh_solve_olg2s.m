function t_hh_solve_olg2s(calNo)
% Syntax test

cS = const_olg2s(calNo);
% expNo = cS.expBase;
paramS = param_set_olg2s(calNo);


wY = 1.2;
wOld = 0.9;
r = 0.2;

[cyV, sV] = hh_solve_olg2s(wY, wOld, r, paramS, cS)


end