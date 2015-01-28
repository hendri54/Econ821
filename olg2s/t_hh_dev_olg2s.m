function t_hh_dev_olg2s(calNo)

cS = const_olg2s(calNo);
%expNo = cS.expBase;
paramS = param_set_olg2s(calNo);


inputS.yY = 1;
inputS.r = 0.2;
inputS.kGridV = linspace(-1, 5, cS.nk);
inputS.emuOldV = linspace(2, 1, cS.nk);

cY = 0.5 * inputS.yY;

hhDev = hh_dev_olg2s(cY, inputS, paramS, cS)

end