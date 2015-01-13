function cS = const_growth821
% Set constants
% ----------------------------

cS = const_821;

%% Constants

% years for cc growth regressions
cS.yearV = 1960 : 2010;

cS.refYear = 2000;


%% Directories

cS.progDir = cS.growthDir;
cS.matDir = fullfile(cS.growthDir, 'mat');
cS.outDir = fullfile(cS.growthDir, 'out');

end