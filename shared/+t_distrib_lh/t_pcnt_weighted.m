function t_pcnt_weighted
% -------------------------------


% Draw uniform RVs
rng(201);
n = 1e4;
xIn = rand([1,n]);

% Draw uniform weights
wIn = rand([1,n]);

if 0
   disp('Setting half of all observations to zero');
   xIn(2:2:n) = 0;
else
   disp(' ');
   disp('Upper bounds should equal percentiles');
end

clUbV = [0.2 0.5 0.9 1];

dbg = 111;

[pMeans, pUpper, pTotals] = distrib_lh.pcnt_weighted(xIn, wIn, clUbV, dbg);


disp(clUbV);
disp(pMeans);
disp(pUpper);
disp(pTotals);

end
