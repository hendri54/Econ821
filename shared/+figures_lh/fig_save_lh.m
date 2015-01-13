function fig_save_lh(figFn, saveFigures, slideOutput, figOptInS)
% Save a figure as pdf or eps
%{
Make dir if it does not exist

IN
   figFn
      incl dir, no extension
   slideOutput
      format with larger fonts etc
   figOptS
      optional: width, height (inches)
      optional: figType (pdf)
      optional: saveFigFile
         1: save as FIG file, so that data can be retrieved later
      optional: figDir
         dir for FIG file
         if missing: use same as figFn
%}
% ---------------------------------------------

%typePdf = 21;
%typeEps = 34;


%       % Compute screen resolution in DPI
%       %  for setting figure size on screen
%       %Sets the units of your root object (screen) to pixels
%       set(0,'units','pixels');
%       %Obtains this pixel information
%       Pix_SS = get(0,'screensize');
%       %Sets the units of your root object (screen) to inches
%       set(0,'units','inches');
%       %Obtains this inch information
%       Inch_SS = get(0,'screensize');
%       %Calculates the resolution (pixels per inch)
%       pointsPerInch = Pix_SS./Inch_SS;
%       pointsPerInch = pointsPerInch(4);


%% Options

if isempty(figOptInS)
   figOptS = struct('height', 4, 'width', 4);
else
   figOptS = figOptInS;
end
if ~isfield(figOptS, 'figType')
   figOptS.figType = 'pdf';
end
if ~isfield(figOptS, 'width')
   figOptS.width = 4;
end
if ~isfield(figOptS, 'height')
   figOptS.height = 4;
end
if ~isfield(figOptS, 'saveFigFile')
   figOptS.saveFigFile = 0;
end


% ****  Output settings for the type

if strcmpi(figOptS.figType, 'pdf')
   %figType = typePdf;
   figExtStr = '.pdf';
   painterStr = '-pdf';
elseif strcmpi(figOptS.figType, 'eps')
   %figType = typeEps;
   figExtStr = '.eps';
   painterStr = '-eps';
else
   error('Invalid');
end



%% Make dir

% Try to extract the fig dir
[figDir, figName] = fileparts(figFn);
if isempty(figDir)
   error('Need a directory');
end

% Create fig dir if necessary
if ~exist(figDir, 'dir')
   mkdir_lh(figDir);
end


%% Save figure
if saveFigures == 1
   % Fix for slide output
   if slideOutput == 1
      fixfig_lh
   end
   
%    % Make sure figure size is correct
%    %  Resulting figures are too small (why?)
%    set(gcf,'PaperUnits', 'inches');
%    papersize = get(gcf, 'PaperSize');
%    left = (papersize(1)- figOptS.width)/2;
%    bottom = (papersize(2)- figOptS.height)/2;
%    myfiguresize = [left, bottom, figOptS.width, figOptS.height];
%    set(gcf,'PaperPosition', myfiguresize);
   
   
   % Set paper size to avoid large borders in preview
   %  Fails with pdf: multi panel figures are off page (or not centered on page)
   %set(gcf, 'PaperUnits', 'inches');
   %set(gcf, 'PaperSize', [figOptS.width + 0.5, figOptS.height + 0.5]);
   
   % Use newer export_fig to generate pdf files
%    pointsPerInch = 100;
%    width  = round(pointsPerInch * figOptS.width);
%    height = round(pointsPerInch * figOptS.height);
%    % Why 100, 100?
%    set(gcf, 'Position', [100, 100, width, height]);
%    % White background
%    set(gcf, 'color', 'w');
   export_fig([figFn, figExtStr], painterStr, '-painters', '-r600', '-nocrop');
   
   if figOptS.saveFigFile == 1
      if isfield(figOptS, 'figDir')
         % Save in different dir
         [~, fn] = fileparts(figFn);
         figFileFn = fullfile(figOptS.figDir, fn);
      else
         figFileFn = figFn;
      end
      % Also save as FIG file
      hgsave(gcf, figFileFn);
   end
   
   close;
   disp(['Saved figure:  ',  figFn, figExtStr]);

else
   disp(['Figure name:   ',  figFn]);
   pause;
   close;
end

end % eof
