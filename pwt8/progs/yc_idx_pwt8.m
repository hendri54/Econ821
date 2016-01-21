function [yrIdxV, cIdxV] = yc_idx_pwt8(yearV, wbCodeV, cS)
% Return year and country indices for saved matrices
%{
Empty yearV or wbCodeV means: return all values in the data
%}
% -----------------------------------------

% cS = const_pwt8;

cListS = var_load_pwt8(cS.vCountryList, cS);


%% Year indices

if isempty(yearV)
   yrIdxV = 1 : length(cListS.yearV);
else
   yrIdxV = zeros(size(yearV));
   for iy = 1 : length(yearV)
      yrIdx = find(cListS.yearV == yearV(iy));
      if ~isempty(yrIdx)
         yrIdxV(iy) = yrIdx;
      end
   end
end

%% Country indices

if isempty(wbCodeV)
   cIdxV = 1 : length(cListS.wbCodeV);
   
else
   cIdxV = zeros(size(wbCodeV));

   for ic = 1 : length(wbCodeV)
      cIdx = find(strcmpi(cListS.wbCodeV, wbCodeV{ic}));
      if ~isempty(cIdx)
         cIdxV(ic) = cIdx;
      end
   end
end


end