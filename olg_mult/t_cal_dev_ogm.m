function t_cal_dev_ogm(calNo)
% Test calibration deviation
% ---------------------------------------

cS = const_ogm(calNo);
paramS = param_derived_ogm([], cS);

% Beta grid
ng = 10;
betaV = zeros(1, ng);
calDevV = zeros(1, ng);
KYV = zeros(1, ng);

% Bounds (per YEAR)
betaLow  = 0.75;
betaHigh = 1.25;
betaGridV = linspace(betaLow, betaHigh, ng);

inputS.eIdxM = sim_lendow_ogm(paramS, cS);

[~, inputS.L] = ls_histories_ogm(inputS.eIdxM, paramS, cS);


%% Show BG deviation on beta grid
for ig = 1 : ng
   betaGuess = betaGridV(ig);
   fprintf('\nbeta = %5.3f  p.a. \n', betaGuess);

   paramS.beta = betaGuess;

   % Prepare inputs for cal_dev_ogm
   inputS.wageNet = cS.tgWage .* (1 - cS.wageTax);
   % After-tax interest rate
   inputS.R = 1 + cS.tgIntRate;
   % Set transfers to fraction of avg after-tax earnings
   inputS.transferEarn = cS.transferEarn;


   [devV, outS] = cal_dev_ogm(inputS, paramS, cS);

   calDevV(ig) = max(abs(devV));
   betaV(ig) = betaGuess;
   KYV(ig) = outS.K / outS.Y;

%    if devV(1) > 0
%       % Raise beta
%       betaLow = betaGuess;
%    else
%       % Reduce beta
%       betaHigh = betaGuess;
%    end

   fprintf('K/Y: %5.3f    KY dev: %5.3f \n', outS.K/outS.Y, devV(1));
end


if 1
   fh = figures_lh.new(cS.figOptS, 1);
   plot(betaV, KYV, 'o-');
   xlabel('beta');
   ylabel('K/Y');
   figure_format_821(fh, 'line');
   pause;
   close;
end


end
