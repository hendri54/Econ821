function t_cal_tech_olg2d
% Test function
% ------------------------------------

fprintf('\nTesting cal_tech_olg2d\n');

kM = 2.1;
lM = 3.2;
pA = 0.6;
capShare = 0.36;
dbg = 111;

[yM, mpkM, mplM] = prod_fct_olg2d(kM, lM, pA, capShare, dbg);

% Check that cal_tech_olg2d recovers the right pA
tgIntRate = 0.05;
tauW = 0.2;
tauR = 0.26;
tgWageYoung = mplM .* (1 - tauW);
[pA2, ddk] = cal_tech_olg2d(kM ./ yM, tgIntRate, tgWageYoung, capShare, tauR, tauW, dbg);

if abs(pA ./ pA2 - 1) > 1e-6
   warning('Invalid pA');
   keyboard;
else
   fprintf('A is good \n');
end

[r, w] = hh_prices_olg2d(mpkM, mplM, tauR, tauW, ddk, dbg);
if abs(tgIntRate - r) > 1e-6
   warning('Invalid int rate');
   keyboard;
else
   fprintf('Interest rate is good \n');
end

if abs(tgWageYoung - w) > 1e-6
   warning('Invalid wage rate');
   keyboard;
else
   fprintf('Wage rate is good \n');
end

end