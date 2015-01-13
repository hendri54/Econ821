function matrix_yc_check_wdi821(data_ycM, yearV, wbCodeV, lb, ub, varNameStr, fp)
% Check a matrix by [year, country]
% ----------------------------------------

cS = const_wdi821;
if isempty(fp)
   % Write to screen
   fp = 1;
end
fprintf(fp, '\nChecking variable %s \n', varNameStr);
baseYear = 2000;

if isempty(wbCodeV)
   % All countries, years
   wdiS = var_load_wdi821(cS.vCountryList);
   yearV = cS.year1 : cS.year2;
   wbCodeV = wdiS.wbCodeV;
   clear wdiS;
end

validateattributes(data_ycM, {'double'}, {'nonempty', 'real', ...
   'size', [length(yearV), length(wbCodeV)]})


%% Check range
% also report countries with wide ranges

valid_ycM = ~isnan(data_ycM);

% Extract data near base year
[dataV, nearYearV] = extract_nearest_year_wdi821(data_ycM, yearV, baseYear);
% Only keep values that are reasonably close
dataV(abs(nearYearV - baseYear) > 10) = NaN;

% Report USA near 2000
usIdx = find(strcmp(wbCodeV, 'USA'));
if length(usIdx) == 1
   usValue = dataV(usIdx);
else
   usValue = -1;
end

% Cross-country mean / std
dStd  = std(dataV(~isnan(dataV)));
dMean = mean(dataV(~isnan(dataV)));
nNear = sum(~isnan(dataV));
fprintf(fp, '  N near year %i: %i    Mean: %.2f    Std: %.2f   USA: %.2f \n',  baseYear, nNear, dMean, dStd, usValue);


if any(data_ycM(:) < lb  &  valid_ycM(:) == 1)  ||  any(data_ycM(:) > ub  &  valid_ycM(:) == 1)
   %warning('Data out of range: %s', varNameStr);
   
   for ic = 1 : length(wbCodeV)
      yrIdxV = find(valid_ycM(:,ic) == 1  &  (data_ycM(:, ic) < lb  |  data_ycM(:, ic) > ub  |  ...
         data_ycM(:,ic) < dMean - 3*dStd  |  data_ycM(:,ic) > dMean + 3*dStd));
      if ~isempty(yrIdxV)
         fprintf(fp, '%8s: %.2f to %.2f  ', wbCodeV{ic}, min(data_ycM(yrIdxV, ic)),  max(data_ycM(yrIdxV, ic)));
         fprintf(fp, '%6i', yearV(yrIdxV));
         fprintf(fp, '\n');
      end
   end
end

end