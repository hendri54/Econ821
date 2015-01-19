function [k, y, r, wY, cY, cO] = bg_comp_olg2d(calNo, expNo)
% Compute steady state
%{
Assumes that parameters have been saved

IN:
 calNo
    Determines parameter set to use
 expNo
    Determines policy parameters to use

OUT:
 Solution of steady state conditions.

Test: in cal_comp_olg2d
%}
% ----------------------------------

% Set model parameters
cS = const_olg2d(calNo);

% Load parameters
paramS = var_load_olg2d(cS.vParams, calNo, cS.expBase);

% Set experiment variables
expS = exp_set_olg2d(expNo);


% Prepare input structure for bg_dev_olg2d
inputS.tauR = expS.tauR;
inputS.tauW = expS.tauW;
inputS.wOld = cS.tgWageOld;


% Prepare inputs for equation solver
optS = optimset('fzero');

% Set the range of k values to search
kLow  = 0.005;
% The bound should be set better +++
kHigh = 2;

% Make sure the search interval is wide enough
devLow = dev_wrapper(kLow);
devHigh = dev_wrapper(kHigh);
if sign(devLow) == sign(devHigh)
   warning('Signs do not differ');
   keyboard;
end

% Search for a zero of Euler equation deviation
[k, fVal, exitFlag] = fzero(@dev_wrapper, [kLow, kHigh], optS);

% Did fzero converge?
if exitFlag < 0
   warning('fzero failed to converge' );
   keyboard;
end


% Compute steady state characteristics
% We call bg_dev_olg2d again, with the solution k as the guess
% It returns other characteristics of the steady state.
[bgDev, y, r, wY, aggrS, cY, cO] = dev_wrapper(k);

disp(' ');
fprintf('Steady state. calNo = %i.  expNo = %i \n',  calNo, expNo);
fprintf('k = %5.3f.    y  = %5.3f \n', k, y);
fprintf('r = %5.3f.    wY = %5.3f \n', r, wY);
fprintf('cY/wY = %5.3f.    s/y = %5.3f \n', cY/wY, aggrS/y);
fprintf('Deviation = %f \n', bgDev);


%% Nested: deviation wrapper
   function [dev, y, r, wY, aggrS, cY, cO] = dev_wrapper(k)
      [dev, y, r, wY, aggrS, cY, cO] = bg_dev_olg2d(k, inputS, paramS, cS);
   end


end