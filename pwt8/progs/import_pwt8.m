function import_pwt8
% Import data from matlab dataset
%{
IN:
   dataset file; generated from stat/transfer
%}
% --------------------------------------------

cS = const_pwt8;

fp = 1;
fprintf(fp, '\nImporting PWT\n');

% Load dataset
m = load(fullfile(cS.dataDir, 'pwt80.mat'));
m = m.st_dataset;
fprintf(fp, 'Dataset size: %i x %i \n',  size(m));

varNameV = m.Properties.VarNames;
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

var_save_pwt8(saveS, cS.vCountryList);

fprintf(fp, '%i countries,  %i years \n', length(saveS.wbCodeV),  length(saveS.yearV));



%%  Save each variable

if ~isequal(saveS.yearV, (saveS.yearV(1) : saveS.yearV(end))')
   error('Years not sequential');
end

% Year index for each row
yrIdxV = m.year - saveS.yearV(1) + 1;


% Assume 4 columns with non-variable info
for iCol = 5 : size(m, 2)
   dataV = m.(varNameV{iCol});
   out_ycM = nan([ny, nc]);
   idxV = sub2ind([ny, nc], yrIdxV, cNoV);
   out_ycM(idxV) = dataV;
   validateattributes(out_ycM, {'double'}, {'nonempty', 'real', 'size', [ny, nc]})
   var_save_pwt8(out_ycM, varNameV{iCol});
end


%%  Self-test
% Alternative ways of constructing the data

varStr = 'rgdpe';
dataV  = double(m.(varStr));

data_ycM = var_load_pwt8(varStr);

% Accumarray is very powerful
out_ycM = accumarray([yrIdxV, cNoV], double(dataV));

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
end


end