function cal_comp_olg2d(calNo, expNo, dbg);
% Calibrate steady state

% IN:
%  calNo
%     Determines parameter set to use
%  expNo
%     Determines policy parameters to use

% ----------------------------------

% This global structure is used in the deviation function
global calDevS

if nargin ~= 3
   error('Invalid number of input arguments');
end

% Plot sequence of fzero guesses?
plotGuesses = 1;
calDevS.n = 0;

% Set exogenous parameters
olg2dS = cal_set_olg2d(calNo, dbg);

% Load parameters (guesses)
paramS = cal_load_olg2d(calNo, dbg);

% Set experiment variables, such as tax rates
expS = exp_set_olg2d(expNo, dbg);

% Calibrate technology parameters to match
% interest rate and wage rate
[paramS.A, paramS.ddk] = cal_tech_olg2d(olg2dS.tgKY, olg2dS.tgIntRate, ...
   olg2dS.tgWageYoung, olg2dS.capShare, expS.tauR, expS.tauW, dbg);
cal_save_olg2d(calNo, paramS, dbg);


% Fix k = K/L at level consistent with target K/Y
k = (paramS.A * olg2dS.tgKY) ^ (1 / (1-olg2dS.capShare));

% Compute factor prices as faced by household
[y, mpk, mpl] = cobb_douglas_604(k, 1, olg2dS.capShare, paramS.A, dbg);
r  = mpk .* (1 - expS.tauR) - paramS.ddk;
wY = mpl .* (1 - expS.tauW);
% Verify that calibration replicates targets
devV = [r, wY] ./ [olg2dS.tgIntRate, olg2dS.tgWageYoung] - 1;
if max(abs(devV)) > 1e-5
   warnmsg([ mfilename, ':  Large deviations from targets for (r, wY)' ]);
   keyboard;
end


% Prepare input structure for cal_dev_olg2d
inputS.dbg  = dbg;
inputS.wY   = olg2dS.tgWageYoung;
inputS.r    = olg2dS.tgIntRate;
inputS.wOld = olg2dS.tgWageOld;
inputS.k    = k;
inputS.popGrowth = olg2dS.popGrowth;
inputS.saveGuesses = plotGuesses;


% Prepare inputs for equation solver
optS = optimset('fzero');

betaLow  = 0.9 ^ olg2dS.pdLength;
betaHigh = 1.1 ^ olg2dS.pdLength;


% Plot deviations for a range of beta values
if 1
   labelFontSize = const_olg2d('labelFontSize', dbg);
   titleFontSize = const_olg2d('titleFontSize', dbg);
   saveFigures   = const_olg2d('saveFigures', dbg);
   % Do not save those steps
   inputS.saveGuesses = 0;

   nBeta = 100;
   betaV = linspace(betaLow, betaHigh, nBeta);
   calDevV = zeros(1, nBeta);
   cYV = zeros(1, nBeta);
   cOV = zeros(1, nBeta);
   for ib = 1 : nBeta
      [calDevV(ib), cYV(ib), cOV(ib)] = cal_dev_olg2d(betaV(ib), inputS, olg2dS, paramS);
   end

   horLineV = inputS.k .* (1 + olg2dS.popGrowth) .* ones(size(betaV));
   saveV = inputS.wY - cYV;
   plot(betaV .^ (1/olg2dS.pdLength), saveV,   'k.-',  ...
        betaV .^ (1/olg2dS.pdLength), horLineV, 'b-');
   grid on;
   xlabel('\beta',   'FontSize', labelFontSize);
   ylabel('Saving',  'FontSize', labelFontSize);
   title('Deviations from calibration targets',  'FontSize', titleFontSize);

   if saveFigures == 1
      outDir = const_olg2d('outDir', dbg);
      figName = [outDir, 'fig_cal_dev'];
      exportfig(gcf, figName, const_olg2d('figOptS', dbg));
   end
   pause_print(0);

   % Restore the saveGuesses switch
   inputS.saveGuesses = plotGuesses;
end

% Search for a zero of deviation from calibration conditions
[betaN, fVal, exitFlag] = fzero('cal_dev_olg2d', [betaLow, betaHigh], optS, ...
   inputS, olg2dS, paramS);

if exitFlag < 0
   warnmsg([ mfilename, ':  fzero failed to converge' ]);
   keyboard;
end


% *** Show results ***

[calDev, cY, cOld] = cal_dev_olg2d(betaN, inputS, olg2dS, paramS);

disp(' ');
disp(sprintf( 'Deviation from calibration targets: %f', calDev ));
disp(sprintf( 'beta  = %5.3f.  Annual beta = %5.3f', betaN, betaN ^ (1/olg2dS.pdLength) ));
wLifetime = inputS.wY + inputS.wOld / (1 + inputS.r);
disp(sprintf( 'cY/wY = %5.3f.  cY/W = %5.3f', cY/inputS.wY, cY/wLifetime ));
disp(sprintf( 'k     = %5.3f.', k));

paramS.beta = betaN;
cal_save_olg2d(calNo, paramS, dbg);


% Plot the search history of fzero
if plotGuesses == 1
   n = calDevS.n;
   optS.fontSize = 12;
   labelM = repmat(' ', [n, 3]);
   for i1 = 1 : n
      labelM(i1,:) = sprintf('%3i', i1);
   end

   % Which steps to plot
   if n > 30
      plotIdxV = [1 : 5,  round(linspace(6, n-6, 20)), n-5 : n];
      %plotIdxV = [1 : 5,  round(n./2) + [-5 : 5], n-5 : n];
   else
      plotIdxV = 1 : n;
   end

   labelFontSize = const_olg2d('labelFontSize', dbg);
   titleFontSize = const_olg2d('titleFontSize', dbg);
   plot_w_labels_lh( calDevS.cYV(plotIdxV), calDevS.devV(plotIdxV), ...
      labelM(plotIdxV,:), optS, dbg );
   grid on;
   xlabel('cY', 'FontSize', labelFontSize);
   ylabel('Calibration deviation', 'FontSize', labelFontSize);
   title(['fzero Sequence. ', sprintf('%i steps.', n)], ...
      'FontSize', titleFontSize);

   saveFigures == const_olg2d('saveFigures', dbg);
   if saveFigures == 1
      figOptS = const_olg2d('figOptS', dbg);
      figName = [const_olg2d('outDir', dbg), sprintf('cal_seq_c%03i', calNo)];
      exportfig(gcf, figName, figOptS);
   end
   pause_print(0);
end


%disp(mfilename);
%keyboard;

% ********  eof  *******
