function hh_solve_test(calNo)
% ------------------------------

disp('Testing hh_solve');

cS = const_ogm(calNo);
paramS = param_derived_ogm([], cS);

paramS.beta = 0.95;

R = 1.05;
w = 2;
transferV = cS.transferEarn .* w .* ones([cS.aD, 1]);
transferV(1 : cS.aR) = 0;


% ********  Syntax test  **********
if 01
   tic
   [cPolM, kPolM] = hh_ogm.hh_solve(R, w, transferV, paramS, cS);
   toc

   disp(' ');
   disp('Checking properties of cPolM');
   hh_check_cpol_ogm(cPolM, kPolM, R, paramS, cS);
end

end