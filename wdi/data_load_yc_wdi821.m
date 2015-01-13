function outM = data_load_yc_wdi821(wbCodeV, yearV, doInterpolate, wdiFn)
% Load a WDI file. Reformat by [year, country]
%{
doInterpolate
   for missing values, and extrapolate
%}
% ---------------------------------------------

cS = const_wdi821;
nc = length(wbCodeV);
ny = length(yearV);


%% Load wdi data

m = load(fullfile(cS.dataDir, [wdiFn, '.mat']));
m = m.st_dataset;
varNameV = m.Properties.VarNames;

% Find countries
cIdxV = zeros([nc, 1]);
for i1 = 1 : nc
   cIdx = find(strcmpi(m.('Country Code'), wbCodeV{i1}));
   if ~isempty(cIdx)
      cIdxV(i1) = cIdx;
   end
end

% Find years
yrIdxV = zeros([ny, 1]);
for i1 = 1 : ny
   yrIdx = find(strcmpi(varNameV, sprintf('YR%i', yearV(i1)))  |  ...
      strcmpi(varNameV, sprintf('D%i', yearV(i1))));
   if ~isempty(yrIdx)
      yrIdxV(i1) = yrIdx;
   end
end

%% Populate the table

outM = nan([ny, nc]);

for ic = find(cIdxV(:)' > 0)
   for iy = find(yrIdxV(:)' > 0)
      outM(iy, ic) = m{cIdxV(ic), yrIdxV(iy)};
   end
end

outM(outM == -99) = NaN;



%% Interpolate missing values
if doInterpolate == 1
   outM = extrapolate_wdi821(outM);
end

validateattributes(outM, {'double'}, {'nonempty', 'real', 'size', [ny,nc]})

end