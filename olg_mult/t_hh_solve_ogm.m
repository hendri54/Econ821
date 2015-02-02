function t_hh_solve_ogm(calNo)
% ------------------------------

cS = const_ogm(calNo);
saveFigures = 0;
paramS = param_derived_ogm([], cS);

paramS.beta = 0.95;

R = 1.05;
w = 2;
transferV = cS.transferEarn .* w .* ones([cS.aD, 1]);
transferV(1 : cS.aR) = 0;


% ********  Syntax test  **********
if 01
   startTime = clock;
   [cPolM, kPolM] = hh_solve_ogm(R, w, transferV, paramS, cS);
   disp(sprintf('Time: %i seconds',  round(etime(clock, startTime)) ));

   disp(' ');
   disp('Checking properties of cPolM');
   hh_check_cpol_ogm(cPolM, kPolM, R, paramS, cS);
end

end