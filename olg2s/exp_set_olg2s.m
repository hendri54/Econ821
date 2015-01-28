function expS = exp_set_olg2s(expNo)
% Set parameters for policy experiments
% ----------------------------------------

expS.expNo = expNo;
expS.tauR = 0;
expS.tauW = 0;

% Capital tax experiments
expS.capTaxExperV = 2 : 11;

if expNo == 1
   expS.descrStr = 'Default';

elseif ismember(expNo, expS.capTaxExperV)
   % Capital tax experiments
   tauV = linspace(0.1, 0.8, length(expS.capTaxExperV));
   expS.tauR = tauV(find(expNo == expS.capTaxExperV));
   expS.descrStr = sprintf('Capital tax %5.1f pct', expS.tauR * 100);
   expS.tauW = 0;

else
   error('Invalid expNo');
end

end