function [r, w] = hh_prices_olg2d(mpk, mpl, tauR, tauW, ddk, dbg)
% Compute prices faced by household from marginal products
% --------------------------------------------------------

r = mpk .* (1 - tauR) - ddk;
w = mpl .* (1 - tauW);

end