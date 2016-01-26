function run_all_olg2d(calNo)
% Run everything in sequence
% Deterministic two-period OLG model
%{
Note:
   Switch individual sections on and off by
   changing "if 0" to "if 1"

IN:
   calNo
      Determines which parameters to use

%}

% Set parameters / constants
cS = const_olg2d(calNo);


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
   saveGuesses = 1;
   paramS.beta = cS.beta;
   [cY, cO] = hh_solve_olg2d(cS.tgWageYoung, cS.tgWageOld, ...
      cS.tgIntRate, saveGuesses, paramS, cS);
   disp([cY, cO]);
   return;
end


%%  Calibration 
% Calibrate model parameters for one experiment.
if 01
   cal_comp_olg2d(calNo);
   % Alternative, simple minded implementation
   cal_simple_olg2d(calNo);
   %return;
end


% *** Compute the steady state ***
% For illustration only. cal_comp_olg2d already did that
if 0
   bg_comp_olg2d(calNo, cS.expBase);
   
   % Show Euler deviation
   show_ee_dev_olg2d(saveFigures, calNo);
end


% ****  Compute tax experiments  ****
if 0
   tax_exper_olg2d(calNo);
end


%% Test functions
% There should be more, of course
if 1
   t_var_save_olg2d;
   t_cal_tech_olg2d;
   cal_technology_test_olg2d(calNo);
end

end
   
