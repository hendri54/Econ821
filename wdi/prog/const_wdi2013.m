function cS = const_wdi2013

cS.dbg = 111;
cS.missVal = -919191;

% Start year with data
cS.year1 = 1960;


%% Directories

fs = filesep;
cS.baseDir = ['~/Documents', fs, 'econ', fs, 'data', fs, 'worldbank', fs, 'wdi2013', fs];
cS.progDir = [cS.baseDir, 'prog', fs];
% Downloaded datafiles are here. XLS and mat formats
cS.xlsDir  = [cS.baseDir, 'excel', fs];


end