function t_hh_solve_vfi_ogm(calNo)
% ------------------------------

cS = const_ogm(calNo);
cS.dbg = 111;
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
   [saveS.cPolM, saveS.kPolM, saveS.valueM] = hh_solve_vfi_ogm(R, w, transferV, paramS, cS);
   disp(sprintf('Time: %i seconds',  round(etime(clock, startTime)) ));
   
   var_save_ogm(saveS, cS.vHhPolFct, calNo, cS.expBase);

   disp(' ');
   disp('Checking properties of cPolM');
   hh_check_cpol_ogm(saveS.cPolM, saveS.kPolM, R, paramS, cS);
end

end