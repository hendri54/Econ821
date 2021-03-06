function calibr_ogm(calNo)
% Run calibration routine
% -------------------------------

cS = const_ogm(calNo);
% For speed: debugging only at random intervals
cS.dbg = 1;
expNo = cS.expBase;
startTime = clock;

% Load calibrated parameters
[paramS, success] = var_load_ogm(cS.vParams, calNo, expNo);
if success == 0
   paramS = param_set_ogm(calNo);
end
% Set derived params
paramS = param_derived_ogm(paramS, cS);


%% Precompute objects that do not require solution to hh problem

% Simulate earnings histories by [ind, age]
inputS.eIdxM = sim_lendow_ogm(paramS, cS);

% Labor supply histories and aggregate labor supply
[lsHistM, L] = ls_histories_ogm(inputS.eIdxM, paramS, cS);



%%  Run calibration routine

guessV = paramS.beta;
optS  = optimset('fsolve');

% Prepare inputs for cal_dev_ogm
inputS.L = L;
% After tax wage rate
inputS.wageNet = cS.tgWage .* (1 - cS.wageTax);
% After-tax interest rate
inputS.R = 1 + cS.tgIntRate;
% Set transfers to fraction of avg pre-tax earnings
inputS.transferEarn = cS.transferEarn;

% Try the wrapper
[devV, outS, paramS] = wrapper(guessV);

% Iterate over values of beta until K/Y matches calibration target
% Solution beta is stored in ogmS
[solnV, fVal, exitFlag] = fsolve(@wrapper, guessV, optS);

if exitFlag <= 0
   warning('No convergence');
   keyboard;
end



%% Save

% Save other steady state features
[~, outS, paramS] = wrapper(solnV);

% Save parameters
var_save_ogm(paramS, cS.vParams, calNo, expNo);

% Copy additional info to outS
fnV = fieldnames(inputS);
for i1 = 1 : length(fnV)
   outS.(fnV{i1}) = inputS.(fnV{i1});
end
outS.lsHistM = lsHistM;

var_save_ogm(outS, cS.vBgp, calNo, expNo);

% Compute additional stats
bg_stats_ogm(calNo);

% Check hh solution
% hh_check_cpol_ogm(outS.cPolM, outS.kPolM, outS.R, paramS, cS);


disp('Calibration complete');
fprintf('Time: %.1f minutes \n', etime(clock, startTime) ./ 60);


%% Nested: Deviation wrapper
   function [devV, outS, param2S] = wrapper(guessV)
      param2S = paramS;
      param2S.beta = guessV;
      [devV, outS] = cal_dev_ogm(inputS, param2S, cS);
   end

end