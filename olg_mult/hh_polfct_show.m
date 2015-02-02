function hh_polfct_show(cPolM, kPolM, paramS, cS)
% Show hh policy functions
% -----------------------------------------------

%% Input check


%% Consumption and saving function
if 1
   a = round(0.5 * cS.aR);
   ieV = round(linspace(1, cS.nw, 3));
   legendV = cell(size(ieV));
   
   for iPlot = 1 : 2
      if iPlot == 1
         polM = cPolM(:, :, a);
         polStr = 'c';
      elseif iPlot == 2
         polM = kPolM(:, :, a);
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
      legend(legendV)
      figure_format_821(fh, 'line');
      pause;
      close;
   end
end
   
end
