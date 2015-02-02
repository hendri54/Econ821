function [lsHistM, L] = ls_histories_ogm(eIdxM, paramS, cS)
% Compute labor supply histories by [ind, age] and aggregate labor supply
% ----------------------------------------------

% Individual labor supplies: efficiency * shock
lsHistM = nan([cS.nSim, cS.aD]);
for a = 1 : cS.aD
   lsHistM(:, a) = paramS.ageEffV(a) .* paramS.leGridV(eIdxM(:,a));
end


% Aggregate labor supply
L = aggr_hist_ogm(lsHistM, cS.ageMassV, cS.dbg);   

end