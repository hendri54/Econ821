function cc_regr_growth821
% Run cross-country growth regressions
% ------------------------------------

cS = const_growth821;

fprintf('\nCross country growth regressions \n');

% Min no of obs required for computing time series averages
minObs = 20;

%% Load PWT data

% RGDP, local constant prices
[rgdp_ycM, wbCodeV] = var_load_yc_pwt821('rgdpna', cS.yearV, []);
% Investment share
iy_ycM = var_load_yc_pwt821('csh_i', cS.yearV, wbCodeV);


%% Make regressors

y1V = log(rgdp_ycM(1,:))';
growthV = log(rgdp_ycM(end,:))' - y1V;

iyV = nan(size(growthV));
for ic = 1 : length(growthV)
   dataV = iy_ycM(:, ic);
   idxV = find(~isnan(dataV));
   if length(idxV) >= minObs
      iyV(ic) = mean(dataV(idxV));
   end
end
fprintf('No of counties with I/Y data: %i \n',  sum(~isnan(iyV)));

keyboard;

xM = [ones(size(growthV)), y1V, iyV];

% Find countries with data
cIdxV = find(~isnan(growthV)  &  all(~isnan(xM'))');

fprintf('No of countries with data %i \n',  length(cIdxV));


%% Regression




end