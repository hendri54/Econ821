function t_misc_ogm(calNo)
% Syntax test for various routines

cS = const_ogm(calNo);
cS.dbg = 111;
paramS = param_derived_ogm([], cS);

a = max(1, round(cS.aD * rand([1,1])));
kV = paramS.kGridV;
R = cS.tgIntRate;
w = cS.tgWage;
transfer = 0.4 .* w;

hh_income_ogm(kV, R, w, transfer, a, paramS, cS);

aggr_hist_ogm(rand([30, cS.aD]), cS.ageMassV, cS.dbg);

ie = round(cS.nw / 2);
a  = round(cS.aD / 2);
cPrimeV = linspace(1, 2, cS.nw)';
hh_emu_ogm(ie, a, cPrimeV, paramS, cS);

end