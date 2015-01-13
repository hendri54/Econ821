function figure_format_821(fh, graphType)
% Simple figure formatting function
% ---------------------------------

cS = const_821;

figures_lh.format(fh, graphType, cS)

% %%  Format axes
% 
% axes_handle = get(fh, 'CurrentAxes');
% 
% set(axes_handle,  'Units','normalized', ...
%    'FontUnits','points', 'FontWeight','normal', 'FontSize',cS.figFontSize, 'FontName',cS.figFontName, ...
%    'Box', 'off');
% 
% grid(axes_handle, 'on');
% 
% 
% xl = get(axes_handle, 'XLabel');
% if ~isempty(xl)
%    set(xl, 'Fontsize', cS.figFontSize, 'FontName', cS.figFontName);
% end
% yl = get(axes_handle, 'yLabel');
% if ~isempty(yl)
%    set(yl, 'Fontsize', cS.figFontSize, 'FontName', cS.figFontName);
% end
% 
% 
% %% Legend
% 
% lHandle = legend(axes_handle);
% if ~isempty(lHandle)
%    set(lHandle, 'FontUnits', 'points', 'FontSize', cS.legendFontSize, 'FontName', cS.figFontName);
% 
%    % Get position of legend: [x, y, w, h]
%    %  w,h are width and height
%    %  x,y is x,y position of legend
%    % lPosV = get(lHandle, 'Position');
% 
%    % Turn off box around legend
%    %legend(axes_handle, 'boxoff');
% 
%    % 
%    % disp('More robust way of showing subset of legend objects');
%    % % Plot entire legend
%    % [legend_h, object_h, plot_h, textV] = legend(legendV);
%    % % Now redraw with just the desired objects
%    % legend(plot_h(1), legendV(1));
%    % pause;
% end
% 

end