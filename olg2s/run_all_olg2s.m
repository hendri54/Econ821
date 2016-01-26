function run_all_olg2s(calNo)
% Run everything in sequence
% Stochastic two-period OLG model
%{
Note:
 Switch individual sections on and off by
 changing "if 0" to "if 1"

IN:
 calNo
    Determines which parameters to use
%}

cS = const_olg2s(calNo);


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
   paramS = param_set_olg2s(calNo);
   cyV = hh_solve_olg2s(cS.tgWageYoung, cS.tgWageOld, ...
      cS.tgIntRate, paramS, cS);
   return;
end


%%  Calibration 
% Calibrate model parameters for one experiment.
if 01
   % Very simple minded (inefficient) algorithm
   cal_comp_olg2s(calNo);
   % Show bgp results
   bgp_show_olg2s(calNo, cS.expBase);
   show_cons_fct_olg2s(calNo, cS.expBase);
end


% *** Compute the steady state ***
% For illustration only. cal_comp_olg2s already did that
if 0
   bg_comp_olg2s(calNo, cS.expBase);
end




%% Test functions
if 1
   test_all_olg2s(calNo)
end

end
   
