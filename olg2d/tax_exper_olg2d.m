function tax_exper_olg2d(calNo)
% Run a tax experiment.
% Plot results
% --------------------------------------

cS = const_olg2d(calNo);
expS = exp_set_olg2d(cS.expBase);
saveFigures = 1;

% Capital tax experiment
expNoV = expS.capTaxExperV;
nx = length(expNoV);

% Allocate storage for results
kV = zeros(1, nx);
yV = zeros(1, nx);
rv = nan(1, nx);
cYV = nan(1, nx);
cOV = nan(1, nx);
taxV = zeros(1, nx);

% Compute each steady state
for ix = 1 : nx
   expS = exp_set_olg2d(expNoV(ix));
   taxV(ix) = expS.tauR;
   [kV(ix), yV(ix), rV(ix), ~, cYV(ix), cOV(ix)] = bg_comp_olg2d(calNo, expNoV(ix));
end


%% Plot y and k against tax rates

fh = figures_lh.new(cS.figOptS, 1);
hold on;
plot(taxV, yV ./ yV(1), '-');
plot(taxV, kV ./ kV(1), '--');

hold off;
xlabel('Capital tax rate');
ylabel('Output and capital');
legend({'Output', 'Capital'});
figures_lh.format(fh, 'line', cS);

figName = fullfile(cS.outDir, [cS.calPrefix, 'cap_tax_yk']);
figures_lh.fig_save_lh(figName, saveFigures, 0, cS.figOptS);


%% Plot interest rate, cOld/cY

fh = figures_lh.new(cS.figOptS, 1);
hold on;
plot(taxV, rV ./ rV(1), '-');
plot(taxV, cOV ./ cYV, '--');

hold off;
xlabel('Capital tax rate');
legend({'r', 'cOld / cY'});
figures_lh.format(fh, 'line', cS);

figName = fullfile(cS.outDir, [cS.calPrefix, 'cap_tax_rc']);
figures_lh.fig_save_lh(figName, saveFigures, 0, cS.figOptS);


end