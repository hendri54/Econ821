function cS = const_wdi821

cS = const_821;


%% Constants

% First year to keep
cS.year1 = 1952;
% Last year to keep
cS.year2 = 2014;
cS.yearV = (cS.year1 : cS.year2)';
cS.ny = length(cS.yearV);



%% Directories

cS.progDir = cS.wdiDir;
cS.matDir = fullfile(cS.wdiDir, 'mat');
cS.outDir = fullfile(cS.wdiDir, 'out');
% For raw data files
cS.dataDir = fullfile(cS.wdiDir, 'data');


%% Saved variables

% List of wb codes and country names
cS.vCountryList = 1;

% Several WDI variables, by [year, country]
cS.vWdiData = 2;


end