function t_hh_opt_c_ogm(calNo)
% ------------------------------

cS = const_ogm(calNo);
cS.dbg = 111;
paramS = param_derived_ogm([], cS);

y = 5;
R = 1.05;
cPrimeV = linspace(2, 8, cS.nk)';
emuV = ces_util_821(cPrimeV, paramS.sigma, cS.dbg);


% ********  Syntax test  **********
if 01
   a  = 1;

   [c, kPrime] = hh_opt_c_ogm(a, y, R, paramS.kGridV, emuV(:), paramS, cS);
   uPrime = ces_util_821(c, paramS.sigma, cS.dbg);
   RHS = paramS.beta .* R .* interp1(paramS.kGridV, emuV, kPrime, 'linear');

   disp(' ');
   disp(sprintf('c: %f    kPrime: %f', c, kPrime));
   fprintf('uPrime today: %.3f   RHS of EE: %.3f \n',  uPrime, RHS);

end

end
