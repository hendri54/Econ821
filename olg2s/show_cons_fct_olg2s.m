function show_cons_fct_olg2s(calNo, expNo)
% Show the consumption function
% cY(wY)
% Assumes that calibration has been computed
% ----------------------------------------------


cS = const_olg2s(calNo);
paramS = var_load_olg2s(cS.vParams, calNo, expNo);
bgpS = var_load_olg2s(cS.vBgp, calNo, expNo);
saveFigures = 1;

budgetS = hh_budget_olg2s(bgpS.w, cS.tgWageOld, bgpS.r, paramS, cS);

% %% Solve household problem for various yY levels
% 
% 
% % Income when young (grid)
% np = 40;
% yYV = linspace(budgetS.yYV(1), budgetS.yYV(end), np)';
% 
% cYV = zeros(1, np);
% sV  = zeros(1, np);
% for ip = 1 : np
%    [cYV(ip), sV(ip)] = hh_solve_olg2s(yYV(ip), cS.tgWageOld, bgpS.r, paramS, cS);
% end
% 
% mpcY = (cYV(np) - cYV(1)) ./ (yYV(np) - yYV(1));
% fprintf('\nMarginal propensity to consume when young = %.3f \n', mpcY);


%% Plot

fh = figures_lh.new(cS.figOptS, 1);
hold on;
plot(budgetS.yYV, bgpS.cyV, 'o-');
plot(budgetS.yYV, bgpS.sV,  'd-');
hold off;
xlabel('Young income');
ylabel('cY, s');
legend({'cY', 's'});
figure_format_821(fh, 'line');

figures_lh.fig_save_lh(fig_fn_olg2s('cons_fct', calNo, expNo), saveFigures, 0, cS.figOptS);

end
