function loadM = var_load_yc_wdi2013(dataFn, yearV, cCodesV)
% Load one variable, by [year, country]
% Arbitrary years and country codes are allowed
%{
IN:
   dataFn
      e.g. 'gdp_percapita_current_usd'

Checked: 2014-jan-22
%}
% ----------------------------------------------

cS = const_wdi2013;
ny = length(yearV);
nc = length(cCodesV);

if nargin ~= 3
   error('Invalid nargin');
end
if cS.dbg > 10
   if ~v_check( yearV, 'i', [], 1700, 2020, [] );
      error('Invalid year');
   end
end


% Load matlab dataset
m = load([cS.xlsDir, dataFn, '.mat']);
m = m.st_dataset;
% Get country codes
mCCodeV = m.('Country Code');
% Get variables
varNameV = get(m, 'VarNames');


% Find each country's row number
countryRowV = zeros([nc, 1]);
for ic = 1 : nc
   cRow = find(strcmpi(mCCodeV, cCodesV{ic}));
   if ~isempty(cRow)
      countryRowV(ic) = cRow;
   end
end
% These countries have data
cIdxV = find(countryRowV >= 1);


% Output matrix
loadM = repmat(cS.missVal, [ny, nc]);

% Loop over years
for iy = 1 : ny
   yearStr = sprintf('x%i', yearV(iy));
   % Does this year exist?
   if any(strcmpi(varNameV, yearStr))
      % Data for this year
      yearDataV = m.(yearStr);
      % Replace missing value codes
      yearDataV(isnan(yearDataV)) = cS.missVal;
      % That missing value code should not be hard coded
      yearDataV(yearDataV == -99) = cS.missVal;
      loadM(iy, cIdxV) = yearDataV(countryRowV(cIdxV));
   end
end


%% Self test
if 1
   if ~v_check(loadM, 'f', [ny, nc], [], [], [])
      error('Invalid');
   end
end

end