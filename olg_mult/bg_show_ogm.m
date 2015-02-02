function bg_show_ogm(saveFigures, calNo)
% Show steady state results
% Assumes that steady state has been computed and saved
% ------------------------------------------------

cS = const_ogm(calNo);
expNo = cS.expBase;


%%  What to show?

% Age wealth profiles
showAgeWealth = 01;
% Wealth distribution by age
showAgeWealthDistr = 01;
% Show Lorenz curves for wealth by age
showAgeWealthLorenz = 01;
% Consumption income parallel
showConsIncome = 01;
% Consumption function by wealth
showConsWealth = 01;


%% Load parameters and steady state results
paramS = var_load_ogm(cS.vParams, calNo, expNo);
bgpS = var_load_ogm(cS.vBgp, calNo, expNo);
bgStatS = var_load_ogm(cS.vBgpStats, calNo, expNo);


%%  Wealth distribution
if 01
   fprintf('\nCross-sectional wealth distribution\n');
   topPctV = [1, 5, 25, 50];
   topShareV = interp1(bgStatS.wealthPctUbV, bgStatS.wealthCumFrac_pV, 1 - topPctV ./ 100, 'linear');
   fprintf('Gini: %.2f \n',  bgStatS.giniWealth);
   for i1 = 1 : length(topShareV)
      fprintf('Fraction held by top %2i pct: %.1f pct \n',  topPctV(i1),  100 * (1 - topShareV(i1)));
   end
end



%% Age wealth profiles
% Average wealth by age, scaled by economy wide mean earnings
ageWealthV = mean(bgpS.kHistM) ./ bgpS.avgEarn;

if showAgeWealth == 1
   fh = figures_lh.new(cS.figOptS, 1);
   plot(cS.physAgeV(:), ageWealthV(:), '-');
   xlabel('Age in years');
   ylabel('Wealth / mean earnings');
   figure_format_821(fh, 'line');
   figFn = fig_fn_ogm('age_wealth', calNo, expNo);
   figures_lh.fig_save_lh(figFn, saveFigures, 0, cS.figOptS);
end




%% Wealth distribution by age 
if showAgeWealthDistr == 1
   % Show these percentiles
   percentileV = [0.1 0.25 0.5 1];
   % Plot the first np profiles
   np = length(percentileV) - 1;

   % Compute percentiles of wealth distribution by age
   awdM = zeros([cS.aD, np]);
   % Wealth gini by age
   giniV = zeros([1, cS.aD]);
   legendV = cell([np+1, 1]);

   for a = 1 : cS.aD
      % Scaled wealth in this age
      aWealthV = bgpS.kHistM(:, a) ./ bgpS.avgEarn;
      if any(aWealthV > 0.01)
         % Compute distribution
         [~, upperV] = distrib_lh.pcnt_weighted(aWealthV, 1, percentileV, cS.dbg);
         awdM(a,:) = upperV(1:np);
         % Gini.
         giniV(a) = distrib_lh.gini_weighted(aWealthV, ones(size(aWealthV)), cS.dbg);
      end
   end

   % Show the plot
   fh = figures_lh.new(cS.figOptS, 1);
   hold on;
   for ip = 1 : np
      plot(cS.physAgeV(:), awdM(:,ip), '-');
      % Construct the legend
      legendV{ip} = sprintf('%4.1f-th percentile', 100 .* percentileV(ip));
   end
   % Also plot mean profiles
   plot(cS.physAgeV(:), ageWealthV(:), '--');
   legendV{np+1} = 'Mean';
   hold off;

   xlabel('Age in years');
   ylabel('Wealth / mean earnings');
   legend(legendV, 'location', 'northwest');

   figure_format_821(fh, 'line');
   figFn = fig_fn_ogm('age_wealth_dist', calNo, expNo);
   figures_lh.fig_save_lh(figFn, saveFigures, 0, cS.figOptS);

   
   % ***** Show ginis by age *****
   if 01
      fh = figures_lh.new(cS.figOptS, 1);
      plot(cS.physAgeV(2:end), giniV(2:end), '-');
      xlabel('Age in years');
      ylabel('Wealth Gini');

      figure_format_821(fh, 'line');
      figFn = fig_fn_ogm('age_wealth_gini', calNo, expNo);
      figures_lh.fig_save_lh(figFn, saveFigures, 0, cS.figOptS);
   end
end


%% Lorenz curves of wealth by age 
if showAgeWealthLorenz == 1
   % Show for these physical ages
   showAgeV = [30 45 60 75];
   ageV = showAgeV - cS.age1 + 1;
   fh = figures_lh.new(cS.figOptS, 1);
   for ia = 1 : length(ageV);
      a = ageV(ia);
      subplot(2,2,ia);
      hold on;
      yV = cumsum(sort(bgpS.kHistM(:,a)));
      plot(linspace(0, 100, cS.nSim), 100 .* yV ./ yV(end), '-');
      plot([0,100], [0,100], '--');
      figure_format_821(fh, 'line');
      xlabel(sprintf('Wealth percentile, age %i', showAgeV(ia)));
      ylabel('Cumulative fraction held');
   end

   figFn = fig_fn_ogm('age_wealth_lorenz', calNo, expNo);
   figures_lh.fig_save_lh(figFn, saveFigures, 0, cS.figOptS);
end



%%   Consumption and income 
if showConsIncome == 1
   % Income by [age, individual]
   incomeM = bgpS.lsHistM .* bgpS.wageNet + bgpS.kHistM .* (bgpS.R - 1);
   % Mean income by age
   ageIncomeV = mean(incomeM);
   % Mean consumption by age
   ageConsV = mean(bgpS.cHistM);

   fh = figures_lh.new(cS.figOptS, 1);
   hold on;
   
   plot(cS.physAgeV(:), ageIncomeV(:), '-');
   plot(cS.physAgeV(:), ageConsV(:), '--');
   
   hold off;
   xlabel('Age in years');
   ylabel('Consumption and Income');
   legend({'Income', 'Consumption'});

   figure_format_821(fh, 'line');
   figFn = fig_fn_ogm('cons_income', calNo, expNo);
   figures_lh.fig_save_lh(figFn, saveFigures, 0, cS.figOptS);
end


%%  Consumption by wealth 
if showConsWealth == 1
   % Show these wealth levels
   idxV = 1 : round(cS.nk ./ 2);
   % Show this earnings state
   ie = round(cS.nw ./ 2);
   % Show these physical ages
   showAgeV = [25 40 55 70];
   % Translate into model ages
   modelAgeV = showAgeV - cS.age1 + 1;
   legendV = cell(size(showAgeV));

   fh = figures_lh.new(cS.figOptS, 1);
   hold on;
   for ia = 1 : length(modelAgeV);
      a = modelAgeV(ia);
      if a >= 1
         plot(paramS.kGridV(idxV), bgpS.cPolM(idxV, ie, a)', '-');
         legendV{ia} = sprintf('Age %i', showAgeV(ia));
      end
   end
   hold off;
   
   xlabel('Wealth');
   ylabel('Consumption');
   legend(legendV{find(modelAgeV >= 1)});

   figure_format_821(fh, 'line');
   figFn = fig_fn_ogm('cons_wealth', calNo, expNo);
   figures_lh.fig_save_lh(figFn, saveFigures, 0, cS.figOptS);
end

end