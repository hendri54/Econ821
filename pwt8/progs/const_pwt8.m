function cS = const_pwt8(verNo)
% Set constants for one PWT version
%{
Works with versions >= 8.0 (that have same format at 8)
%}

cS.dbg = 111;

validateattributes(verNo, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar', '>=', 8})

% % First year with data
% cS.year1 = 1950;
% % Last year with data
% cS.year2 = 1950 + 61;

% List of oil countries that one would often drop
cS.oilCountryV = {'ARE', 'BHR', 'BRN', 'OMN', 'QAT', 'SAU'};


%% Directories

baseDir = '/users/lutz/documents/econ/data/pwt/';
if verNo == 8
   verStr = 'pwt8';
   % Data are a matlab dataset
   cS.dataFormat = 'mat';
   cS.dataFileName = 'pwt80.mat';
elseif verNo == 8.1
   verStr = 'pwt81';
   % Data are xlsx
   cS.dataFormat = 'xlsx'; 
   cS.dataFileName = 'pwt81.xlsx';
else
   error('Invalid');
end

cS.baseDir = fullfile(baseDir, verStr);
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

% Contains WB codes, country names, years in dataset
cS.vCountryList = 1;

end