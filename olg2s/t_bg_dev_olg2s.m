function t_bg_dev_olg2s(calNo)

cS = const_olg2s(calNo);
expNo = cS.expBase;
paramS = param_set_olg2s(calNo);

inputS.wOld = 0.9;
inputS.tauW = 0.2;
inputS.tauR = 0.3;

k = 1.2;


[bgDev, outS] = bg_dev_olg2s(k, inputS, paramS, cS)


end