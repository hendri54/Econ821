function import_pwt8(verNo)
% Import data from matlab dataset
%{
This code works for all pwt versions that have the same format at pwt 8
Can be a stata file or an xlsx

In the 8.1 dataset there are 3 discrepancies between the 2 ways I construct the data
Could be duplicate entries for the same country with different currencies?

IN:
   dataset file; generated from stat/transfer
%}
% --------------------------------------------

cS = const_pwt8(verNo);

fp = 1;
fprintf(fp, '\nImporting PWT\n');

% Load dataset
if strcmp(cS.dataFormat, 'mat')
   m = load(fullfile(cS.dataDir, cS.dataFileName));
   m = m.st_dataset;
   varNameV = m.Properties.VarNames;
elseif strcmp(cS.dataFormat, 'xlsx')
   m = readtable(fullfile(cS.dataDir, cS.dataFileName), 'Sheet', 'Data');
   varNameV = m.Properties.VariableNames;
else
   error('Invalid');
end
fprintf(fp, 'Dataset size: %i x %i \n',  size(m));

fprintf(fp, '%i variables \n',  length(varNameV));


%%  Make list of countries

% cNoV is the index of saveS.wbCodeV for each row
[saveS.wbCodeV, idxV, cNoV] = unique(m.countrycode);
nc = length(saveS.wbCodeV);

% Check cNoV
if ~isequal(saveS.wbCodeV(cNoV),  m.countrycode)
   error('Wrong indexing');
end

% Check idxV
if ~isequal(m.countrycode(idxV), saveS.wbCodeV)
   error('Wrong indexing');
end

% Matching names
saveS.countryNameV = m.country(idxV);

saveS.yearV = unique(m.year);
saveS.yearV = saveS.yearV(:);
ny = length(saveS.yearV);

var_save_pwt8(saveS, cS.vCountryList, cS);

fprintf(fp, '%i countries,  %i years \n', length(saveS.wbCodeV),  length(saveS.yearV));


%% Check that each country has exactly the right number of entries 
% all with the same currency unit

for ic = 1 : nc
   cIdxV = find(strcmp(m.countrycode, saveS.wbCodeV{ic}));
   validateattributes(cIdxV, {'double'}, {'finite', 'nonnan', 'nonempty', 'integer', '>=', 1, ...
      'size', [ny, 1]})
   assert(isequal(m.currency_unit(cIdxV), repmat(m.currency_unit(cIdxV(1)), [ny, 1])));
end


%%  Save each variable
% Some variables are character. Omit those (e.g. i_cig)

if ~isequal(saveS.yearV, (saveS.yearV(1) : saveS.yearV(end))')
   error('Years not sequential');
end

% Year index for each row
yrIdxV = m.year - saveS.yearV(1) + 1;


% Assume 4 columns with non-variable info
assert(strcmp(varNameV{4}, 'year'));
for iCol = 5 : size(m, 2)
   % Get one variable
   %  this is a vector for all countries and years
   dataV = m.(varNameV{iCol});
   
   % Skip is character variable
   if ~isnumeric(dataV)
      fprintf('Skipped non-numeric variable  %s \n',  varNameV{iCol});
   else
      % Reformat into a matrix by [year, country]
      %  Since the code is tricky, verify by example that it is correct
      %  There is also an automatic test below
      out_ycM = nan([ny, nc]);
      idxV = sub2ind([ny, nc], yrIdxV, cNoV);
      out_ycM(idxV) = double(dataV);
      validateattributes(out_ycM, {'double'}, {'nonempty', 'real', 'size', [ny, nc]})

      % Save the variable
      var_save_pwt8(out_ycM, varNameV{iCol}, cS);
   end
end


%%  Self-test
% Alternative ways of constructing the data

varStr = 'rgdpe';
dataV  = double(m.(varStr));

% The data we already constructed for this variable
data_ycM = var_load_pwt8(varStr, cS);

% First alternative way of constructing the data:
% Accumarray is very powerful
out_ycM = accumarray([yrIdxV, cNoV], double(dataV));

% Second alternative
% The direct way (much slower!)
out2_ycM = nan([ny, nc]);
for iRow = 1 : size(m, 1)
   yrIdx = find(m.year(iRow) == saveS.yearV);
   cNo   = find(strcmpi(m.countrycode{iRow}, saveS.wbCodeV));
   out2_ycM(yrIdx, cNo) = dataV(iRow);
end

maxDiff1 = max(abs(out_ycM(:) - data_ycM(:)));
maxDiff2 = max(abs(out2_ycM(:) - data_ycM(:)));

if any([maxDiff1, maxDiff2] > 1e-6)
   fprintf(fp, '\nSelf-test:\n');
   fprintf(fp, 'Deviations from loaded data: %f, %f \n',  maxDiff1, maxDiff2);
   idxV = find(abs(out_ycM(:) - data_ycM(:)) > 1e-6);
   fprintf('No of discrepancies: %i \n', length(idxV));
   % keyboard
end


end