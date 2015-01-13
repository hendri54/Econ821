function rgdp_density_growth821(saveFigures)
% Plot density of real output per worker
% --------------------------------------

cS = const_growth821;
yearV = [1960, 1980, 2000];

% Load pwt data by country
% GDP in constant PPP prices (millions)
[gdp_ycM, wbCodeV] = var_load_yc_pwt8('rgdpo', yearV, []);
% Employment (millions)
emp_ycM = var_load_yc_pwt8('emp', yearV, wbCodeV);

data_ycM = gdp_ycM ./ emp_ycM;
validateattributes(data_ycM, {'double'}, {'nonempty', 'real', 'positive'})


%% Persistence of output gaps

fprintf('\nPersistence of output gaps\n');

xV = log(data_ycM(1,:)');
yV = log(data_ycM(end,:)');
idxV = find(~isnan(xV) & ~isnan(yV));
fprintf('No of observations: %i \n', length(idxV));


fh = figures_lh.new(cS.figOptS, 1);
hold on;

plot(xV, yV, 'w.');
for i1 = idxV(:)'
   text(xV(i1), yV(i1), wbCodeV{i1},  'FontSize', cS.figFontSize,  'FontName', cS.figFontName);
end

hold off;
xlabel(sprintf('Log gdp %i', yearV(1)));
ylabel(sprintf('Log gdp %i', yearV(end)));
figure_format_821(fh, 'line');

% Save the figure
figFn = fullfile(cS.outDir, 'rgdp_persistence');
figures_lh.fig_save_lh(figFn, saveFigures, 0, cS.figOptS);



%% Plot density

fh = figures_lh.new(cS.figOptS, 1);

hold on;
for iy = 1 : length(yearV)
   dataV = data_ycM(iy, :)';
   % Drop missing values
   dataV(isnan(dataV)) = [];
   fprintf('No of observations in %i: %i \n',  yearV(iy), length(dataV));
   
   % Density
   n = 2 ^ 8;
   [~, yV, xV] = kde(log(dataV), n);
   plot(xV, yV, cS.lineStyleV{iy});

   validateattributes(xV(:), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [n,1]})
   validateattributes(yV(:), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', [n,1]})
end
hold off;

% A little tricky code to create a legend without a loop
f1 = @(x) sprintf('%i', x);
legendV = cellfun(f1, num2cell(yearV), 'Uniformoutput', false);
legend(legendV);

% Format the figure
xlabel('Log RGDPO');
ylabel('Density');
figure_format_821(fh, 'line');

% Save the figure
figFn = fullfile(cS.outDir, 'rgdp_density');
figures_lh.fig_save_lh(figFn, saveFigures, 0, cS.figOptS);

end