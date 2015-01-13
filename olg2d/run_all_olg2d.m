function run_all_olg2d(calNo)
% Run everything in sequence
% Deterministic two-period OLG model

% Note:
%  Switch individual sections on and off by
%  changing "if 0" to "if 1"

% IN:
%  calNo
%     Determines which parameters to use

% ----------------------------------

cS = const_olg2d(calNo);
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


% % Set model parameters
% olg2dS = cal_set_olg2d(calNo, dbg);
% % Load calibrated parameters
% paramS = cal_load_olg2d(calNo, dbg);

% Show Euler deviation
show_ee_dev_olg2d(saveFigures, calNo);


if 01
   % Solve household problem
   % (for purposes of illustration only)
   saveGuesses = 1;
   paramS.beta = cS.beta;
   [cY, cO] = hh_solve_olg2d(cS.tgWageYoung, cS.tgWageOld, ...
      cS.tgIntRate, saveGuesses, paramS, cS);
   disp([cY, cO]);
   return;
end


% % ****  Calibration  ****
% % Calibrate model parameters for one experiment.
% if 01
%    expNo = 0;
%    cal_comp_olg2d(calNo, expNo, dbg);
%    %return;
% end
% 
% 
% % *** Compute the steady state ***
% % For illustration only. cal_comp_olg2d already did that
% if 0
%    expNo = 0;
%    bg_comp_olg2d(calNo, expNo, dbg);
% end
% 
% 
% % ****  Compute tax experiments  ****
% if 0
%    % Capital tax experiment
%    taxExpNo = 1;
%    tax_exper_olg2d(calNo, taxExpNo, dbg);
% end


end
