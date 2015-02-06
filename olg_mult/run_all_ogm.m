function run_all_ogm(calNo)
% Run everything in sequence
% Stochastic multi-period OLG model
%{
%}
% ----------------------------------

cS = const_ogm(calNo);
saveFigures = 1;

% Make directories (just once)
if 0
   dirV = {cS.matDir, cS.outDir};
   for i1 = 1 : length(dirV)
      if exist(dirV{i1}, 'dir') <= 0
         disp('Creating output directory');
         mkdir(dirV{i1});
      end
   end
   return;
end


if 0
   % Solve household problem
   % (for purposes of illustration only)
   paramS = param_derived_ogm([], cS);
   cyV = hh_solve_ogm(cS.tgIntRate, cS.tgWage, ones([cS.aD,1]), paramS, cS);
   return;
end


%%  Calibration 
% Calibrate model parameters for one experiment.
if 01
   calibr_ogm(calNo);
   % Show bgp results
   bg_show_ogm(saveFigures, calNo);
end




%% Test functions
if 1
   t_misc_ogm(calNo);
   t_hh_optc_vfi_ogm(calNo);
   t_hh_solve_vfi_ogm(calNo);
   t_hh_ee_dev_ogm(calNo);
   t_hh_opt_c_ogm(calNo)
   t_hh_solve_age_ogm(calNo);
   t_hh_solve_ogm(calNo);
   t_bg_dev_ogm(calNo);
end

end
   
