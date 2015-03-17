function cS = const_pwt8
% -----------------------------

% % First year with data
% cS.year1 = 1950;
% % Last year with data
% cS.year2 = 1950 + 61;


%% Directories

cS.baseDir = '/users/lutz/documents/econ/data/pwt/pwt8/';
cS.outDir  = fullfile(cS.baseDir, 'out');
cS.matDir  = fullfile(cS.baseDir, 'mat');
cS.progDir  = fullfile(cS.baseDir, 'progs');
cS.dataDir  = fullfile(cS.baseDir, 'data');


%%  Figures

cS.figOptS = struct('preview', 'tiff', 'height', 4, 'width', 6, 'color', 'rgb');
cS.figOpt4S = cS.figOptS;
cS.figOpt4S.height = 6;
cS.figOpt4S.width = 8;

cS.figFontSize = 16;
cS.figFontName = 'Times';
cS.legendFontSize = 12;



%% Variables

cS.vCountryList = 1;

end