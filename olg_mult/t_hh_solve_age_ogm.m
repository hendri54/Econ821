function t_hh_solve_age_ogm(calNo)
% ------------------------------

cS = const_ogm(calNo);
paramS = param_derived_ogm([], cS);

R = 1.05;
cPrimeM = linspace(0.1, 10, cS.nk)'  *  linspace(1, 2, cS.nw);
w = 2;
transfer = 0.4 * w;


%% Check that rising beta increases saving
if 1
   a = 5;
   n = 5;
   betaV = linspace(0.8, 1.2, n);
   ik = 2;
   ie = 4;
   
   
   for i1 = 1 : length(betaV)
      paramS.beta = betaV(i1);
   
      [cPolM, kPolM] = ...
         hh_solve_age_ogm(a, cPrimeM, R, w, transfer * (a > cS.aR), ...
         paramS, cS);
      
      fprintf('beta: %.3f    k: %.3f \n',  paramS.beta,  kPolM(ik, ie));
   end
   return;
end


%% Syntax test
if 01
   a  = 1;

   [cPolM, kPolM] = ...
      hh_solve_age_ogm(a, cPrimeM, R, w, transfer * (a > cS.aR), ...
      paramS, cS);
end

end
