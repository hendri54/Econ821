function wealth_distrib_ogm(calNo, expNo)

% Load solution
cS = const_ogm(calNo);
bgpS = var_load_ogm(cS.vBgp, calNo, expNo);

[cumWtV, cumXV, gini] = lorenz821(bgpS.kHistM(:), ...
   ones(size(bgpS.kHistM(:))), cS.dbg);

fprintf('Gini: %.2f \n', gini);

plot(cumWtV, cumXV);


end