function [k, y, r, w] = bg_comp_olg2s(calNo, expNo, dbg);
% Compute steady state
% Assumes that parameters have been saved
% and are ready to be loaded with cal_load_olg2s

% IN:
%  calNo
%     Determines parameter set to use
%  expNo
%     Determines policy parameters to use

% OUT:
%  Solution of steady state conditions.

% ----------------------------------

% Set exogenous parameters
olg2sS = cal_set_olg2s(calNo, dbg);
% Load parameters
paramS = cal_load_olg2s(calNo, dbg);
% Set experiment variables
expS = exp_set_olg2s(expNo, dbg);


% Prepare input structure for bg_dev_olg2s
inputS.tauR = expS.tauR;
inputS.tauW = expS.tauW;
inputS.dbg  = dbg;
inputS.wOld = olg2sS.tgWageOld;


% Prepare inputs for equation solver
optS = optimset('fzero');

kLow  = 0.01;
kHigh = olg2sS.kGridV(end);

% Search for a zero of Euler equation deviation
% k = K/L
[k, fVal, exitFlag] = fzero('bg_dev_olg2s', [kLow, kHigh], optS, ...
   inputS, olg2sS, paramS);

if exitFlag < 0
   warnmsg([ mfilename, ':  fzero failed to converge' ]);
   keyboard;
end

% Compute steady state characteristics
[bgDev, y, r, w, aggrS, cYV, sV] = bg_dev_olg2s(k, inputS, olg2sS, paramS);

% Aggregate cY
aggrCY = sum( olg2sS.eYProbV .* cYV );
% Aggregate earnings of young
aggrWY = sum( olg2sS.eYProbV .* olg2sS.eYV ) .* w .* olg2sS.lPerYoung;

disp(' ');
disp(sprintf('Steady state. calNo = %i.  expNo = %i.',  calNo, expNo));
disp(sprintf('k = %5.3f.    y = %5.3f.', k, y));
disp(sprintf('r = %5.3f.    w = %5.3f.', r, w));
disp(sprintf('cY/wY = %5.3f.    s/y = %5.3f', aggrCY/aggrWY, aggrS/y));
disp(sprintf('Deviation = %f', bgDev));


% ********  eof  *******
