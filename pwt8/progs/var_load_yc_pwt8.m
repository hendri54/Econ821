function [out_ycM, wbCodeV] = var_load_yc_pwt8(varName, yearV, wbCodeV, cS)
% Return a variable for selected years, countries
%{
IN
   wbCodeV
      may be []; then return all countries
      in sort order defined by cS.vCountryList

OUT
   out_ycM(year, country)

Change
   Write a test function. Or test by spot checking 
%}
% -----------------------------------------------

% cS = const_pwt8;

if isempty(wbCodeV)
   % All countries
   cListS = var_load_pwt8(cS.vCountryList, cS);
   wbCodeV = cListS.wbCodeV;
end

% Find year and country indices
%  some missing
[yrIdxV, cIdxV] = yc_idx_pwt8(yearV, wbCodeV, cS);
ny = length(yrIdxV);
nc = length(cIdxV);

% Load data matrix for all [y,c]
dataM  = var_load_pwt8(varName, cS);


%% Extract data

out_ycM = dataM(max(1, yrIdxV), max(1, cIdxV));

% Data without valid countries or years are set to NaN
out_ycM(yrIdxV < 1,:) = NaN;
out_ycM(:, cIdxV < 1) = NaN;

validateattributes(out_ycM, {'double'}, {'nonempty', 'real', 'size', [ny, nc]})


end