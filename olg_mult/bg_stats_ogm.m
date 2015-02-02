function bg_stats_ogm(calNo)
% Compute stats about BGP
% ----------------------------------

cS = const_ogm(calNo);
expNo = cS.expBase;
paramS = var_load_ogm(cS.vParams, calNo, expNo);
bgpS = var_load_ogm(cS.vBgp, calNo, expNo);


% Individual earnings histories
saveS.earnHistM = bgpS.lsHistM(:, 1:cS.aR) .* bgpS.wageNet .* (ones([cS.nSim,1]) * paramS.ageEffV(1:cS.aR)');


%% Stats for all

% Assumes that all cohorts have same mass
if any(abs(cS.ageMassV - 1/cS.aD) > 1e-3)
   error('Not implemented');
end

saveS.giniWealth = distrib_lh.gini_weighted(bgpS.kHistM(:), 1, cS.dbg);
saveS.giniEarn   = distrib_lh.gini_weighted(saveS.earnHistM(:), 1, cS.dbg);


% Cross-sectional wealth distribution
[cumPctV, xSortV, cumTotalV] = distrib_lh.cdf_weighted(bgpS.kHistM(:), 1, cS.dbg);
saveS.wealthPctUbV = (0.01 : 0.01 : 1)';
wCumTotalV = interp1(cumPctV, cumTotalV, saveS.wealthPctUbV, 'linear');
saveS.wealthCumFrac_pV = wCumTotalV(:) ./ wCumTotalV(end);


%% Stats by age

sizeV = [cS.aD, 1];
saveS.stdLogEarn_aV = nan(sizeV);
saveS.earnGini_aV = nan(sizeV);

for a = 1 : cS.aD
   if a <= cS.aR
      % Earnings distribution
      logEarnV = log(saveS.earnHistM(:, a));
      saveS.stdLogEarn_aV(a) = std(logEarnV);
      
      % Earnings Gini
      saveS.earnGini_aV(a) = distrib_lh.gini_weighted(saveS.earnHistM(:,a), 1, cS.dbg);
   end
end



%% Save

var_save_ogm(saveS, cS.vBgpStats, calNo, expNo);

end