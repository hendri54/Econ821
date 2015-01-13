function gdp_gaps_growth821(saveFigures)

cS = const_growth821;
wdiS = const_wdi821;
minPop = 1e6;

countryS = var_load_wdi821(wdiS.vCountryList);
wdiDataS = var_load_wdi821(wdiS.vWdiData);
idxUSA = find(strcmpi(countryS.wbCodeV, 'USA'));

% GDP per capita; USD
yrIdx = find(wdiS.yearV == cS.refYear);
gdpUsdV = wdiDataS.gdpPerCapitaUsdM(yrIdx, :)';

% GDP per capita; PPP
gdpPppV = wdiDataS.gdpPerCapitaConstPppM(yrIdx, :)';

popV = wdiDataS.popM(yrIdx, :)';

idxV  = find(gdpUsdV > 0  &  popV >= minPop  &  gdpPppV > 0);
fprintf('No of countries with population > 1m: %i \n',  length(idxV))
nObs = length(idxV);

gdpUsdV = gdpUsdV(idxV);
gdpPppV = gdpPppV(idxV);
popV    = popV(idxV);
wbCodeV = countryS.wbCodeV(idxV);
nameV   = countryS.nameV(idxV);


%% Show top / bottom 5 countries

n = 5;


for iPrice = 1 : 2
   if iPrice == 1
      gdpV = gdpUsdV;
      fprintf('\nCurrent USD\n');
   else
      gdpV = gdpPppV;
      fprintf('\nPPP\n');
   end

   sortM = sortrows([gdpV, (1 : nObs)']);

   gdpSortV = sortM(:, 1);
   cNoSortV = sortM(:, 2);


   avgGdpV = nan([2,1]);
   for iShow = 1 : 2
      if iShow == 1
         fprintf('Poorest %i countries: \n', n);
         cIdxV = 1 : n;
      else
         fprintf('Richest %i countries: \n', n);
         cIdxV = (length(idxV) - n) + (1 : n);
      end

      for i1 = 1 : n
         fprintf('  %s', nameV{cNoSortV(cIdxV(i1))});
      end

      avgGdpV(iShow) = mean(gdpSortV(cIdxV));
      fprintf('\n  Mean gdp: %.0f \n',  avgGdpV(iShow));
   end

   gdpRatio = avgGdpV(2) / avgGdpV(1);
   fprintf('Ratio: %.0f \n',  gdpRatio);

end


%% Plot PPP price against GDP (USD)
if 1
   relPriceV = gdpUsdV ./ gdpPppV;
   gdpV = gdpUsdV;
   
   fh = figures_lh.new(cS.figOptS, 1);
   plot(log(gdpV), relPriceV, 'o');
   xlabel('GDP per capita (USD)');
   ylabel('PPP prices');
   figure_format_821(fh, 'line');
   figFn = fullfile(cS.outDir, 'prices_gdp');
   figures_lh.fig_save_lh(figFn, saveFigures, 0, cS.figOptS);
end


end