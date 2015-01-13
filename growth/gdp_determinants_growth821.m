function gdp_determinants_growth821(saveFigures)
% Explore determinants of output gaps
% ------------------------------------------

cS = const_growth821;

%% Load pwt data by country

% GDP in constant PPP prices (millions)
[gdp_ycV, wbCodeV] = var_load_yc_pwt8('rgdpo', cS.refYear, []);
% Employment (millions)
emp_ycV = var_load_yc_pwt8('emp', cS.refYear, wbCodeV);

gdpPerWorkerV = gdp_ycV ./ emp_ycV;
validateattributes(gdpPerWorkerV, {'double'}, {'nonempty', 'real', 'positive'})

% Investment share
iyV = var_load_yc_pwt8('csh_i', cS.refYear, wbCodeV);


%% Plot I/Y against GDP

fh = figures_lh.new(cS.figOptS, 1);
plot(log(gdpPerWorkerV), iyV, 'o', 'color', cS.colorM(1,:));
xlabel('log GDP per worker (PPP)');
ylabel('I/Y');
figure_format_821(fh, 'line');
figFn = fullfile(cS.outDir, 'iy_gdp');
figures_lh.fig_save_lh(figFn, saveFigures, 0, cS.figOptS);



end