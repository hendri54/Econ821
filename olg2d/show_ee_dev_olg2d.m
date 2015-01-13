function show_ee_dev_olg2d(saveFigures, calNo)
% Show Euler equation deviations
% Illustrates the importance of transforming
% marginal utility to avoid strong non-
% linearity
% -------------------------------------------

% Set exogenous parameters
cS = const_olg2d(calNo);

fprintf('\nShowing Euler equation deviation\n');

% Lifetime income
lifeTimeW = cS.tgWageYoung + cS.tgWageOld ./ (1 + cS.tgIntRate);

% Number of consumption points to plot
n = 200;
cV = linspace(0.1 * lifeTimeW, 0.5 * lifeTimeW, n);

% Input structure for household problem
inputS.r     = cS.tgIntRate;
inputS.W     = lifeTimeW;
inputS.sigma = cS.sigma;
inputS.beta  = 0.98;
inputS.dbg   = cS.dbg;

% Store Euler equation deviations for all consumption points
hhDevV = zeros(1, n);
eeDevV = zeros(1, n);
for ic = 1 : n
   [hhDevV(ic), eeDevV(ic)] = hh_dev_olg2d(cV(ic), inputS);
end

%%  Plot Euler equation deviations

fh = figures_lh.new(cS.figOptS, 1);
hold on;
plot(cV, hhDevV)
plot(cV, eeDevV);
hold off;
xlabel('cY', 'FontSize', cS.figFontSize);
ylabel('Deviation', 'FontSize', cS.figFontSize);
legend('Transformed', 'Not transformed',  0);
figure_format_821(fh, 'line');

if saveFigures == 1
   figName = fullfile(cS.outDir, 'fig_ee_dev');
   figures_lh.fig_save_lh(figName, saveFigures, 0, cS.figOptS);
   fprintf('Saved figure  %s \n',  figName);
end

end