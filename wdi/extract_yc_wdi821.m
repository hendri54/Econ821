function outM = extract_yc_wdi821(data_ycM, dataWbCodeV, dataYearV, wbCodeV, yearV)
% Extract country year columns from a data matrix
% -----------------------------------------------------

cS = const_wdi821;
nc = length(wbCodeV);
ny = length(yearV);


% Find countries
cIdxV = zeros([nc, 1]);
for i1 = 1 : nc
   cIdx = find(strcmpi(dataWbCodeV, wbCodeV{i1}));
   if ~isempty(cIdx)
      cIdxV(i1) = cIdx;
   end
end

% Find years
yrIdxV = zeros([ny, 1]);
for i1 = 1 : ny
   yrIdx = find(dataYearV == yearV(i1));
   if ~isempty(yrIdx)
      yrIdxV(i1) = yrIdx;
   end
end


%% Populate the table

outM = nan([ny, nc]);

for ic = find(cIdxV(:)' > 0)
   for iy = find(yrIdxV(:)' > 0)
      outM(iy, ic) = data_ycM(yrIdxV(iy), cIdxV(ic));
   end
end


validateattributes(outM, {'double'}, {'nonempty', 'real', 'size', [ny, nc]})



end