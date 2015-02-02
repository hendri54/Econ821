function t_norm_grid_lh
% --------------------------------------

mu = 2;
sig = 1.5;
dbg = 111;
nx = 10;
xV = linspace(mu - 3*sig, mu + 3*sig, nx);
xMin = mu - 4*sig;
xMax = mu + 4*sig;

[massV, lbV, ubV] = distrib_lh.norm_grid_lh(xV, xMin, xMax, mu, sig, dbg);
densityV = massV(:) ./ (ubV(:) - lbV(:));


% *****  Check moments  **********

midPointV = (lbV + ubV) ./ 2;
Ex = sum( massV .* midPointV );

% Check by simulation:
% Put the right mass on each grid point
% Compute mean and std dev
nSim = 1e4;
xSimV = zeros(1, nSim);
ubIdxV = round(cumsum(massV) .* nSim);
ubIdxV = ubIdxV(:);
lbIdxV = [1; ubIdxV(1:end-1)+1];
for i = 1 : length(massV)
   xSimV(lbIdxV(i) : ubIdxV(i)) = xV(i);
end
simMean = mean(xSimV);
simStd  = std(xSimV);

disp(sprintf('Mean:  %5.3f     mu: %5.3f   Simulated:  %5.3f', Ex, mu, simMean));
disp(sprintf('Std:            sig: %5.3f   Simulated:  %5.3f', sig, simStd));

% *****  Compute actual pdf  *****

ny = 100;
yV = linspace(xMin, xMax, ny);
yMassV = normpdf(yV, mu, sig);

plot( yV, yMassV, 'k.',   xV, densityV, 'ro' );
pause;
close

end