function eeDev = hh_ee_direct_ogm(cY, cPrime_eV, ie, R, paramS, cS)
% Direct deviation from Euler equation
%{
eeDev > 0 means
   MU(t+1) > MU(t)
   borrowing constrained
%}
% --------------------------------------------

% Marginal utility today
% uPrime = ces_util_821(cY, paramS.sigma, cS.dbg);

% Marginal utility tomorrow by e'
muPrimeV = ces_util_821(cPrime_eV, paramS.sigma, cS.dbg);
% E(u') tomorrow
emuOld = paramS.leTrProbM(ie,:) * muPrimeV(:);
% RHS of EE
rhs = paramS.beta .* R .* emuOld;
% EE dev
eeDev = ces_inv_util_821(rhs, paramS.sigma, cS.dbg) - cY;
   

end