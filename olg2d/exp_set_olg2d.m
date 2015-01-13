function expS = exp_set_olg2d(expNo, dbg);
% Set parameters for policy experiments
% ----------------------------------------

expS.tauR = 0;
expS.tauW = 0;

if expNo == 0
   expS.descrStr = 'Default';

elseif expNo >= 1  &  expNo < 10
   % Capital tax experiments
   expS.descrStr = sprintf('Capital tax %5.1f pct', expS.tauR * 100);
   expS.tauR = 0.1 * expNo;
   expS.tauW = 0;

else
   error('Invalid expNo');
end


% *** eof ***
