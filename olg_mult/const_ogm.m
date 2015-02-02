function cS = const_ogm(calNo)
% Return value of constants
%{
Argument order
   k, e, a
%}
% ---------------------------------------------

cS = const_821;

cS.dbg = 111;
cS.calNo = calNo;
% Baseline experiment
cS.expBase = 1;


%%  Fixed model params

% *** Demographics ***

% Age equal to model age 1
cS.age1 = 20;
% Last age of life
cS.ageLast = 79;
cS.ageRetire = 65;

cS.popGrowth = 0.01;


% *** Household ***

% Curvature of utility function
cS.sigma = 2;

% Default value for discount factor
cS.beta = 0.98;

% Consumption floor. Introduced for numerical reasons.
cS.cFloor = 0.05;


% ***  Technology  ***

cS.capShare = 0.36;
cS.ddk = 0.05;


% *****  Labor endowments

cS.leSigma1 = 0.38 ^ 0.5;
cS.leShockStd = 0.045 .^ 0.5;
cS.lePersistence = 0.96;
% No of std deviations the grid is wide
cS.leWidth = 4;
% Size of labor endowment grids
cS.nw = 18;

% No of individuals to simulate 
cS.nSim = 5e4;

% ***  Government

% Huggett 1996
cS.wageTax = 0.195 / (1 - 0.06 * 3);
% Old age transfers / average earnings
cS.transferEarn = 0.4;


%%  Calibration targets 

% Interest rate per period, pre tax
cS.tgIntRate = 0.05;

% Wage rate, pre tax 
cS.tgWage = 1;

% Capital-output ratio
cS.tgKY = 3;


% Size of k grid
cS.nk = 100;
cS.kMin = 0;
cS.kMax = 100 * cS.tgWage;



%%  Cases

if calNo == 1
   % Keep defaults

elseif calNo == 2
   % Log utility
   cS.sigma = 1;
   
elseif calNo == 10
   % Test case
   cS.nw = 5;
   cS.leWidth = 0.1;
   cS.kMax = 25 * cS.tgWage;
   cS.nk = 100;

elseif calNo >= 50
   % Keep defaults
   % For additional experiments in uncertainty model

else
   error('Invalid calNo');
end



%% Derived parameters

% Demographics
cS.aD = cS.ageLast - cS.age1 + 1;
cS.aR = cS.ageRetire - cS.age1 + 1;

% Mass of households by age
cS.ageMassV = ones(1, cS.aD) ./ cS.aD;

% Physical age for each model age
cS.physAgeV = (cS.age1 : cS.ageLast)';


%% Directories

cS.baseDir = cS.ogmDir;
cS.progDir = cS.baseDir;
cS.outDir  = fullfile(cS.baseDir, 'out');
cS.matDir  = fullfile(cS.baseDir, 'mat');

% Prefixes for file names
cS.calPrefix = sprintf('c%03i_', calNo);


%% Variable names

% Calibrated parameters
cS.vParams = 1;

% BGP solution
cS.vBgp = 2;

% Hh policy functions
cS.vHhPolFct = 3;

cS.vBgpStats = 4;

end