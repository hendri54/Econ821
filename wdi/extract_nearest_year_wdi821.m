function [data_cV, year_cV] = extract_nearest_year_wdi821(data_ycM, yearV, year1)
% For each country, get the entry with the nearest year
% ------------------------------------------------------

cS = const_wdi821;
[ny, nc] = size(data_ycM);

year_ycM = yearV(:) * ones(1, nc);
year_ycM(isnan(data_ycM)) = 1e6;

[~, minIdxV] = min(abs(year_ycM - year1));
validateattributes(minIdxV, {'numeric'}, {'finite', 'nonnan', 'nonempty', 'integer'})

% Extract the data for the nearest years
idxV = sub2ind([ny, nc],  minIdxV, (1:nc));
data_cV = data_ycM(idxV);
year_cV = yearV(minIdxV);


%% Self-test
if 1
   yrIdx = find(yearV == year1);
   for ic = 1 : nc
      if isnan(data_cV(ic))  &&  any(~isnan(data_ycM(:,ic)))
         error('Should not have missVal');
      elseif year_cV(ic) == year1
         if isnan(data_cV(ic))
            error('Should have pulled a year with data');
         elseif  data_cV(ic) ~= data_ycM(yrIdx,ic)
            error('Invalid entry');
         end
      else
         % Not year1
         if ~isnan(data_ycM(yrIdx,ic))
            error('Should have taken year1');
         end
         % Did we pull the right number
         %  NaN == NaN evals to false, so we need to rule that out
         if (data_ycM(find(year_cV(ic) == yearV), ic) ~= data_cV(ic))  &&  ~isnan(data_cV(ic))
            error('Wrong pull');
         end
      end
   end
end


end