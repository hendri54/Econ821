function cS = const_821
% Return value of constants
% that do not depend on the model computed
%{
PWT: use general purpose code
%}
% ---------------------------------------------

% How much debugging code to run?
cS.dbg = 111;


%%  Directories

% Base program directory
cS.baseDir = fullfile('/users/lutz', 'dropbox', 's2015', 'econ821', 'progs');
cS.sharedDir = fullfile(cS.baseDir, 'shared');
cS.olg2dDir  = fullfile(cS.baseDir, 'olg2d');
cS.olg2sDir  = fullfile(cS.baseDir, 'olg2s');
cS.ogmDir    = fullfile(cS.baseDir, 'olg_mult');
cS.growthDir = fullfile(cS.baseDir, 'growth');
cS.exampleDir = fullfile(cS.baseDir, 'matlab_examples');

% Data (reside in special locations on my computer)
% cS.pwtDir = fullfile(cS.baseDir, 'pwt');
cS.wdiDir = fullfile(cS.baseDir, 'wdi');
cS.barroLeeDir = fullfile(cS.baseDir, 'barro_lee');


%%  Figures

cS.figOptS = struct('preview', 'tiff', 'height', 4, 'width', 6, 'color', 'rgb');
cS.figOpt4S = cS.figOptS;
cS.figOpt4S.height = 6;
cS.figOpt4S.width = 8;

cS.figFontSize = 12;
cS.figFontName = 'Times';
cS.legendFontSize = 12;

cS.lineStyleV = {'-', '--', '-.', '-', '--', '-.'};


end