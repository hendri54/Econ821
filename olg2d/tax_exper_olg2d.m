function tax_exper_olg2d(calNo, taxExpNo, dbg);
% Run a tax experiment.
% Plot results

% IN:
%  calNo
%     Parameters to use
%  taxExpNo
%     Specifies tax experiment
%  dbg

% --------------------------------------

% Load parameters
cal_load_olg2d(calNo, dbg);

labelFontSize = const_olg2d('labelFontSize', dbg);
titleFontSize = const_olg2d('titleFontSize', dbg);
saveFigures   = const_olg2d('saveFigures',   dbg);
figOptS       = const_olg2d('figOptS', dbg);


if taxExpNo == 1
   % Capital tax experiment
   expNoV = 0 : 9;
   nx = length(expNoV);

   % Allocate storage for results
   kV = zeros(1, nx);
   yV = zeros(1, nx);
   taxV = zeros(1, nx);

   % Compute each steady state
   for ix = 1 : nx
      expS = exp_set_olg2d(expNoV(ix), dbg);
      taxV(ix) = expS.tauR;
      [kV(ix), yV(ix), r, wY, cY, cO] = bg_comp_olg2d(calNo, expNoV(ix), dbg);
   end

   % Plot y and k against tax rates
   plot( taxV, yV ./ yV(1) .* 100, 'ko-', ...
         taxV, kV ./ kV(1) .* 100, 'r+-' );
   grid on;
   xlabel('Capital tax rate',   'FontSize', labelFontSize);
   ylabel('Output and capital', 'FontSize', labelFontSize);
   title('Capital tax experiments',  'FontSize', titleFontSize);
   legend('Output', 'Capital',  0);

   if saveFigures == 1
      outDir = const_olg2d('outDir', dbg);
      figName = [outDir, 'fig_cap_tax_c', sprintf('%03i', calNo)];
      exportfig(gcf, figName, figOptS);
   end
   pause_print(0);

else
   error('Invalid taxExpNo');
end


% *******  eof  *******
