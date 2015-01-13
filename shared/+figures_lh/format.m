function format(fh, graphType, cS)
% Format a figure
%{
% IN:
%  fh
%     figure handle, may be empty, then use gcf
      can be a handle to a subplot
   graphType [optional]
      'line' or 'bar'
   cS
      struct with constants, such as figFontSize
      construct with const
%}
% ----------------------------------

if nargin < 2
   graphType = [];
end

% Make sure we have a figure handle, not an axis handle
if ~strcmp(get(fh, 'type'), 'figure')
   fh = gcf;
end



%% Get figure info

% Type of graph
iBar = 1;
iLine = 2;

% What type of figure
if ~isempty(graphType)
   if strcmpi(graphType, 'bar')
      figType = iBar;
   elseif strcmpi(graphType, 'line')
      figType = iLine;
   else
      error('Invalid graphType');
   end
else
   figType = [];
end


% Get axis handles
if isempty(fh)
   fh = gcf;
   axes_handle = gca;
else
   axes_handle = get(fh, 'CurrentAxes');
end


% Get line handles
lineHandleV = findobj(axes_handle, 'Type', 'Line');
% disp('Change line width for one line only');
% set(lineHandleV(1), 'LineWidth', 2);

% Another try at figuring out figure type
if isempty(figType)
   if isempty(lineHandleV)
      figType = iBar;
   else
      figType = iLine;
   end
end


%%  Format figure area

% White background
set(fh, 'color', 'w');


%%  Format axes

set(axes_handle,  'Units','normalized', ...
   'FontUnits','points', 'FontWeight','normal', 'FontSize',cS.figFontSize, 'FontName',cS.figFontName, ...
   'Box', 'off');

grid(axes_handle, 'on');


xl = get(axes_handle, 'XLabel');
if ~isempty(xl)
   set(xl, 'Fontsize', cS.figFontSize, 'FontName', cS.figFontName);
end
yl = get(axes_handle, 'yLabel');
if ~isempty(yl)
   set(yl, 'Fontsize', cS.figFontSize, 'FontName', cS.figFontName);
end


% % Make sure figure size is correct
% set(fh,'PaperUnits', 'inches');
% papersize = get(fh, 'PaperSize');
% left = (papersize(1)- figOptS.width)/2;
% bottom = (papersize(2)- figOptS.height)/2;
% myfiguresize = [left, bottom, figOptS.width, figOptS.height];
% set(gcf,'PaperPosition', myfiguresize);


% Set axis so that labels are not truncated when in latex
% This does not work for subplots
% set(gca, 'Units', 'normalized',  'Position', [0.15 0.2 0.75 0.7]);



%% Format bar graph
if figType == iBar

   % Set color map for bar graphs
   %  seems to have no effect on line graphs
   %colormap(cS.colorMap);

   % Get handles to bar objects
   barV = get(axes_handle, 'Children');
   if length(barV) > length(cS.colorM) / 2
      % Not enough colors to set individually in cS.colorM
      colormap(cS.colorMap);
   else
      % Set each color, skipping 1 color to get more contrast
      for i1 = 1 : length(barV)
         if strcmp(get(barV(i1), 'type'), 'hggroup')
            % This is a bar, not text
            set(barV(i1), 'Facecolor', cS.colorM(1 + (i1-1) * 2, :));
         end
      end
   end
end


%% Format line graph
if figType == iLine
   % ******  Markers
   for i1 = 1 : length(lineHandleV)
      mk = get(lineHandleV(i1), 'Marker');
      if ~isempty(mk)
         lColor = get(lineHandleV(i1), 'Color');
         set(lineHandleV(i1), 'MarkerFaceColor', lColor);

         % Set marker size
         %  Odd: if no line, the marker disappears. Why?
         lStyle = get(lineHandleV(i1), 'LineStyle');
         if ~strcmp(lStyle, 'none')
            set(lineHandleV(i1), 'MarkerSize', 4);
         end
      end
   end
end





%%  Tick labels

% Ensure that small numbers are not displayed in scientific notation
% in which case the exponent gets truncated
% axisV = axis;
% if axisV(4) < 0.01  &&  axisV(4) > 0
%    yTickV = get(gca, 'YTick');
%    set(gca,'YTickLabel', sprintf('%.3f',yTickV))
% end

% Set tick labels
% set(gca, 'XTick', -pi : pi/2 : pi);
% set(gca,'XTickLabel',{'-pi','-pi/2','0','pi/2','pi'})

% 
% % Get current labels. Char array
% %xTickM = get(gca, 'XTickLabel');
% %[nTick, nLen] = size(xTickM);
% 
% % Make new labels
% xTickValueV = xV(1) : 1 : xV(end);
% nTick = length(xTickValueV);
% xTickStrV = cell([nTick,1]);
% for i1 = 1 : nTick
%    xTickStrV{i1}=sprintf('%4.1f', xTickValueV(i1));
% end
% 
% set(gca, 'XTick', xTickValueV,  'XTickLabel', xTickStrV);



%%  Legend

lHandle = legend(axes_handle);
if ~isempty(lHandle)
   set(lHandle, 'FontUnits', 'points', 'FontSize', cS.legendFontSize, 'FontName', cS.figFontName);

   % Get position of legend: [x, y, w, h]
   %  w,h are width and height
   %  x,y is x,y position of legend
   % lPosV = get(lHandle, 'Position');

   % Turn off box around legend
   %legend(axes_handle, 'boxoff');

   % 
   % disp('More robust way of showing subset of legend objects');
   % % Plot entire legend
   % [legend_h, object_h, plot_h, textV] = legend(legendV);
   % % Now redraw with just the desired objects
   % legend(plot_h(1), legendV(1));
   % pause;
end


end