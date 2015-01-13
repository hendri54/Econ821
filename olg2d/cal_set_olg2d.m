function outS = cal_set_olg2d(calNo, dbg);
% Set parameters for deterministic two period OLG model
% Econ604. Author: Lutz Hendricks

% IN:
%  calNo
%     Determines which parameters to use
%  inS
%     Structure to which new parameters will be added
%     (or existing ones will be overwritten)
%  setAll
%     Also set calibrated parameters?
%     Useful for creating new parameter sets

% OUT:
%  outS
%     Same as inS with additional parameters added

% -----------------------------------------------------

if nargin ~= 2
   error('Invalid nargin');
end



% ---------  DEFAULTS  ------------------------

% Period length
outS.pdLength = 30;



% *** Demographics ***

outS.popGrowth = 1.01 ^ outS.pdLength - 1;


% *** Calibration targets ***

% Interest rate per period, after tax
outS.tgIntRate = 1.05 ^ outS.pdLength - 1;
% Wage rate when young, after tax
outS.tgWageYoung = 1;
% Wage rate when old, after tax
outS.tgWageOld = 0.6;
% Capital-output ratio
outS.tgKY = 2.9 / outS.pdLength;


% *** Household ***

% Curvature of utility function
outS.sigma = 2;

% Consumption floor. Introduced for numerical reasons.
outS.cFloor = 1e-4;


% ***  Technology  ***

outS.capShare = 0.36;




% -----------  INDIVIDUAL CALIBRATIONS  ------------------

if calNo == 1
   % Keep defaults

elseif calNo == 2
   % Log utility
   outS.sigma = 1;

elseif calNo >= 50
   % Keep defaults
   % For additional experiments in uncertainty model

else
   error('Invalid calNo');
end


%disp(mfilename);
%keyboard;


% ******  eof  ******
