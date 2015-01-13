function [k, y, r, wY, cY, cO] = bg_comp_olg2d(calNo, expNo, dbg);
% Compute steady state
% Assumes that parameters have been saved
% and are ready to be loaded with cal_load_olg2d

% IN:
%  calNo
%     Determines parameter set to use
%  expNo
%     Determines policy parameters to use

% OUT:
%  Solution of steady state conditions.

% ----------------------------------

% Set model parameters
olg2dS = cal_set_olg2d(calNo, dbg);

% Load parameters
paramS = cal_load_olg2d(calNo, dbg);

% Set experiment variables
expS = exp_set_olg2d(expNo, dbg);


% Prepare input structure for bg_dev_olg2d
inputS.tauR = expS.tauR;
inputS.tauW = expS.tauW;
inputS.dbg  = dbg;
inputS.wOld = olg2dS.tgWageOld;


% Prepare inputs for equation solver
optS = optimset('fzero');

% Set the range of k values to search
kLow  = 0.01;
% The bound should be set better +++
kHigh = 2;

% Search for a zero of Euler equation deviation
% Note that fzero calls
%     bg_dev_olg2d(kGuess, inputS, olg2dS, paramS)
% Therefore, bg_dev_olg2d knows that fixed and the calibrated
% parameters
[k, fVal, exitFlag] = fzero('bg_dev_olg2d', [kLow, kHigh], optS, ...
   inputS, olg2dS, paramS);

% Did fzero converge?
if exitFlag < 0
   warnmsg([ mfilename, ':  fzero failed to converge' ]);
   keyboard;
end


% Compute steady state characteristics
% We call bg_dev_olg2d again, with the solution k as the guess
% It returns other characteristics of the steady state.
[bgDev, y, r, wY, aggrS, cY, cO] = bg_dev_olg2d(k, inputS, olg2dS, paramS);

disp(' ');
disp(sprintf('Steady state. calNo = %i.  expNo = %i.',  calNo, expNo));
disp(sprintf('k = %5.3f.    y  = %5.3f.', k, y));
disp(sprintf('r = %5.3f.    wY = %5.3f.', r, wY));
disp(sprintf('cY/wY = %5.3f.    s/y = %5.3f', cY/wY, aggrS/y));
disp(sprintf('Deviation = %f', bgDev));


% ********  eof  *******
