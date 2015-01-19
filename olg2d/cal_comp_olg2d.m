function cal_comp_olg2d(calNo)
% Calibrate steady state
%{
IN:
 calNo
    Determines parameter set to use
 expNo
    Determines policy parameters to use
%}
% ----------------------------------

% This global structure is used in the deviation function
global calDevS

cS = const_olg2d(calNo);
expNo = cS.expBase;
% Set experiment variables, such as tax rates
expS = exp_set_olg2d(expNo);
% Plot sequence of fzero guesses?
plotGuesses = 01;
saveFigures = 01;
calDevS.n = 0;

fprintf('\nCalibrating olg2d model\n');



%% Calibrate technology parameters to match
% interest rate and wage rate

[paramS.A, paramS.ddk] = cal_tech_olg2d(cS.tgKY, cS.tgIntRate, ...
   cS.tgWageYoung, cS.capShare, expS.tauR, expS.tauW, cS.dbg);


% Fix k = K/L at level consistent with target K/Y
k = (paramS.A * cS.tgKY) ^ (1 / (1-cS.capShare));


% ***  Check that inputs are recovered
% Compute factor prices as faced by household
% Also check K/Y

[y, mpk, mpl] = prod_fct_olg2d(k, 1, paramS.A, cS.capShare, cS.dbg);
[r, wY] = hh_prices_olg2d(mpk, mpl, expS.tauR, expS.tauW, paramS.ddk, cS.dbg);
% Verify that calibration replicates targets
devV = [r, wY, k/y] ./ [cS.tgIntRate, cS.tgWageYoung, cS.tgKY] - 1;
if max(abs(devV)) > 1e-5
   warning('Large deviations from targets for (r, wY, k/y)');
   keyboard;
end


%% Calibrate beta

% Prepare input structure for cal_dev_olg2d
inputS.wY   = cS.tgWageYoung;
inputS.r    = cS.tgIntRate;
inputS.wOld = cS.tgWageOld;
inputS.k    = k;
inputS.popGrowth = cS.popGrowth;
inputS.saveGuesses = plotGuesses;


betaLow  = 0.9 ^ cS.pdLength;
betaHigh = 1.1 ^ cS.pdLength;


%% Plot deviations for a range of beta values
if 1
   % Do not save those steps
   inputS.saveGuesses = 0;

   nBeta = 50;
   betaV = linspace(betaLow, betaHigh, nBeta);
   calDevV = zeros(1, nBeta);
   cYV = zeros(1, nBeta);
   cOV = zeros(1, nBeta);
   saveV = zeros(1, nBeta);
   for ib = 1 : nBeta
      [calDevV(ib), cYV(ib), cOV(ib), saveV(ib)] = dev_wrapper(betaV(ib));
   end

   horLineV = inputS.k .* (1 + cS.popGrowth) .* ones(size(betaV));
   
   fh = figures_lh.new(cS.figOptS, (saveFigures == 0));
   hold on;
   plot(betaV .^ (1/cS.pdLength), saveV,   '-');
   plot(betaV .^ (1/cS.pdLength), horLineV, '.-');
   hold off;
   
   grid on;
   xlabel('beta');
   ylabel('Saving');
   figures_lh.format(fh, 'line', cS);

   if saveFigures == 1
      figName = fullfile(cS.outDir, [cS.calPrefix, 'cal_dev']);
      figures_lh.fig_save_lh(figName, saveFigures, 0, cS.figOptS);
   end
   

   % Restore the saveGuesses switch
   inputS.saveGuesses = plotGuesses;
end


%% Search for a zero of deviation from calibration conditions

% Prepare inputs for equation solver
optS = optimset('fzero');

[betaN, fVal, exitFlag] = fzero(@dev_wrapper, [betaLow, betaHigh], optS);

if exitFlag < 0
   warning('fzero failed to converge');
   keyboard;
end



%% *** Show results ***

[calDev, cY, cOld] = dev_wrapper(betaN);

fprintf('\nDeviation from calibration targets: %f \n', calDev);
fprintf('beta  = %5.3f.  Annual beta = %5.3f \n', betaN, betaN ^ (1/cS.pdLength));
wLifetime = inputS.wY + inputS.wOld / (1 + inputS.r);
fprintf('cY/wY = %5.3f.  cY/W = %5.3f \n', cY/inputS.wY, cY/wLifetime);
fprintf('k     = %5.3f \n', k);

paramS.beta = betaN;
var_save_olg2d(paramS, cS.vParams, calNo, expNo);


%% Check that computing the bgp for given parameters recovers targets

[k2, y2, r2, wY2, cY2, cO2] = bg_comp_olg2d(calNo, expNo);
devV = [k2, y2, r2, wY2, cY2, cO2] - [inputS.k, y, inputS.r, inputS.wY, cY, cOld];
if max(abs(devV)) > 1e-5
   warning('Solution not consistent with bgp');
   keyboard;
end


%% Plot the search history of fzero

if plotGuesses == 1
   n = calDevS.n;

   % Which steps to plot
   if n > 30
      plotIdxV = [1 : 5,  round(linspace(6, n-6, 20)), n-5 : n];
   else
      plotIdxV = 1 : n;
   end
   
   fh = figures_lh.new(cS.figOptS, 1);
   hold on;
   for i1 = plotIdxV(:)'
      text(calDevS.cYV(i1), calDevS.devV(i1), sprintf('%i', i1));
   end
   
   hold off;
   xlabel('cY');
   ylabel('Calibration deviation');

   figName = fullfile(cS.outDir, [cS.calPrefix, sprintf('seq_c%03i', calNo)]);
   figures_lh.fig_save_lh(figName, saveFigures, 0, cS.figOptS);
end


%% Nested: deviation wrapper
   function [dev, cY, cOld, save] = dev_wrapper(betaIn)
      [dev, cY, cOld, save] = cal_dev_olg2d(betaIn, inputS, paramS, cS);
   end

end
