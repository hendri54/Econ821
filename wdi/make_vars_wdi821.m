function make_vars_wdi821
% Save WDI variables
%{
For all countries / years in WDI
%}
% -------------------------------------------------

cS = const_wdi821;

% Open log file
logFn = fullfile(cS.outDir, 'wdi_save.log');
fp = fopen(logFn, 'w');
fprintf(fp, '\nSaving WDI data\n');


%% Get countries and years

wdiS = var_load_wdi821(cS.vCountryList);
outS.yearV = cS.year1 : cS.year2;
outS.wbCodeV = wdiS.wbCodeV;
ny = length(outS.yearV);
nc = length(outS.wbCodeV);
sizeV = [ny, nc];


%% Read dataset files

% Population (no interpolation)
loadM = data_load_yc_wdi821(outS.wbCodeV, outS.yearV, 0, 'population');
loadM(loadM <= 0) = NaN;
outS.popM = loadM;

% Fraction age 15-64 (pct)
%  interpolate
loadM = data_load_yc_wdi821(outS.wbCodeV, outS.yearV, 1, 'population_age1564') ./ 100;
loadM(loadM <= 0) = NaN;
popFrac1564M = loadM;
matrix_yc_check_wdi821(popFrac1564M, [], [], 0.4, 0.75, 'popFrac1564', fp);

% Fraction age 65+ (pct)
%  interpolate
loadM = data_load_yc_wdi821(outS.wbCodeV, outS.yearV, 1, 'population_age65plus') ./ 100;
loadM(loadM <= 0) = NaN;
popFrac65M = loadM;
matrix_yc_check_wdi821(popFrac65M, [], [], 0.01, 0.4, 'popFrac65plus', fp);


% Employment / population (pct)
% Use ILO series. Starts in 1991. 
%  interpolate
loadM = data_load_yc_wdi821(outS.wbCodeV, outS.yearV, 1, 'employ_pop_age15plus_ilo') ./ 100;
loadM(loadM <= 0) = NaN;
empPop15plusM = loadM;
matrix_yc_check_wdi821(empPop15plusM, [], [], 0.25, 0.9, 'empPop15plus', fp);


% Female fraction in labor force (interpolate)
loadM = data_load_yc_wdi821(outS.wbCodeV, outS.yearV, 1, 'laborforce_female_frac') ./ 100;
loadM(loadM <= 0) = NaN;
outS.lForceFemaleFracM = loadM;
matrix_yc_check_wdi821(outS.lForceFemaleFracM, [], [], 0.05, 0.7, 'lForceFemaleFrac', fp);



% Self-employment / employment
% interpolate
loadM = data_load_yc_wdi821(outS.wbCodeV, outS.yearV, 1, 'self_employed_frac') ./ 100;
loadM(loadM <= 0) = NaN;
outS.fracSelfEmployedM = loadM;
% Some countries have 94% self employed (!). Others have 1%
matrix_yc_check_wdi821(outS.fracSelfEmployedM, [], [], 0.005, 0.96, 'self empl frac', fp);


% GDP per capita, constant PPP
loadM = data_load_yc_wdi821(outS.wbCodeV, outS.yearV, 0, 'gdp_percapita_const_ppp');
loadM(loadM <= 0) = NaN;
outS.gdpPerCapitaConstPppM = loadM;

% % GDP per capita (LCU)
% %  some kind of index; no jumps when currencies change
% loadM = data_load_yc_wdi821(outS.wbCodeV, outS.yearV, 0, 'gdp_percap_current_lcu');
% loadM(isnan(loadM)  |  (loadM <= 0)) = NaN;
% outS.gdpPerCapitaLcuM = loadM;

% GDP per capita (current USD)
loadM = data_load_yc_wdi821(outS.wbCodeV, outS.yearV, 0, 'gdp_percapita_current_usd');
loadM(loadM <= 0) = NaN;
outS.gdpPerCapitaUsdM = loadM;



% Exchange rate (period average) (LCU / USD)
loadM = data_load_yc_wdi821(outS.wbCodeV, outS.yearV, 0, 'exchange_rate');
loadM(loadM <= 0) = NaN;
exchRateM = loadM;

% % Inflation rate
% inflationM = data_load_yc_wdi821(outS.wbCodeV, outS.yearV, 0, 'inflation_gdp_deflator');
% validInflM = (inflationM > -90);
% outS.inflationM = inflationM ./ 100;
% outS.inflationM(validInflM < 0.5) = NaN;


validM = (outS.popM > 0) & (popFrac1564M > 0) & (popFrac65M > 0) & (outS.gdpPerCapitaUsdM > 0) & (empPop15plusM > 0)  &  (exchRateM > 0);
fprintf(fp, 'No of valid obs: %i \n',  sum(validM(:) == 1));
% validM(outS.inflationM > 0.3  |  outS.inflationM < -0.3) = 0;
% fprintf(fp, 'No of valid obs after inflation filter: %i \n',  sum(validM(:) == 1));



%%  Derived variables

% GDP per capita (LCU)
outS.gdpPerCapitaLcuM = outS.gdpPerCapitaUsdM .* exchRateM;
outS.gdpPerCapitaLcuM(validM < 0.5) = NaN;

% GDP (LCU)
outS.gdpLcuM = outS.gdpPerCapitaLcuM .* outS.popM;
outS.gdpLcuM(outS.gdpPerCapitaLcuM <= 0  |  outS.popM <= 0) = NaN;

% Employment / population
outS.emplPopM = empPop15plusM .* (popFrac1564M + popFrac65M);
outS.emplPopM(validM < 0.5) = NaN;
matrix_yc_check_wdi821(outS.emplPopM, [], [], 0.15, 0.7, 'employment / pop', fp);

% Employment
outS.employM = outS.popM .* outS.emplPopM;
outS.employM(validM < 0.5) = NaN;

% GDP / worker (LCU)
outS.gdpPerWorkerLcuM = outS.gdpLcuM ./ max(0.1, outS.employM);
outS.gdpPerWorkerLcuM(outS.gdpLcuM <= 0  |  outS.employM <= 0) = NaN;
validateattributes(outS.gdpPerWorkerLcuM, {'double'}, {'nonempty', 'real', ...
   'size', sizeV})



%% Save

var_save_wdi821(outS, cS.vWdiData);

fclose(fp);
type(logFn);

end