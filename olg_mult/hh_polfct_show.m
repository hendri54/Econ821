function hh_polfct_show(saveFigures, calNo, expNo)
% Show hh policy functions


%% Load

cS = const_ogm(calNo);
paramS = var_load_ogm(cS.vParams, calNo, expNo);
bgpS = var_load_ogm(cS.vBgp, calNo, expNo);


%% Consumption and saving function
if 1
   a = round(0.5 * cS.aR);
   ieV = round(linspace(1, cS.nw, 3));
   legendV = cell(size(ieV));
   
   for iPlot = 1 : 2
      if iPlot == 1
         polM = bgpS.cPolM(:, :, a);
         polStr = 'c';
      elseif iPlot == 2
         polM = bgpS.kPolM(:, :, a);
         polStr = 'k';
      else
         error('Invalid');
      end
      
      fh = figures_lh.new(cS.figOptS, 1);
      hold on;
      for i1 = 1 : length(ieV)
         ie = ieV(i1);
         plot(paramS.kGridV(:), polM(:,ie));
         legendV{i1} = sprintf('e %i', ie);
      end
      hold off;

      xlabel('k');
      ylabel(sprintf('%s(k,e,%i)', polStr, a));
      legend(legendV, 'location', 'northwest')
      figure_format_821(fh, 'line');
      figFn = fig_fn_ogm(sprintf('hh_%s_fct', polStr), calNo, expNo);
      figures_lh.fig_save_lh(figFn, saveFigures, 0, cS.figOptS);
   end
end
   
end
