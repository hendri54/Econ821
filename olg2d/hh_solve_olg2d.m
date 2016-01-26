function [cY, cO, saving] = hh_solve_olg2d(wY, wO, r, saveGuesses, paramS, cS)
% Solve the household problem
%{
IN:
 wY, wO
    Wage rates when young, old
 r
    Interest rate
 saveGuesses
    Save the history of fzero guesses into hhDevS?
    For plotting the search pattern of fzero.
 cS
    Structure with exogenous parameters
 paramS
    Structure with calibrated parameters

OUT:
 cY, cO
    Solutions for consumption when young/old
%}

if saveGuesses == 1
   fprintf('\nSolving household problem\n');
end

% This is used to plot Euler equation deviations only.
global hhDevS

%%  Check input arguments

% nargin is the number of input arguments
if nargin ~= 6
   error('Invalid nargin');
end
if ~any(saveGuesses == [0,1])
   error('Invalid saveGuesses');
end


%% Prepare inputs for equation solver

% We use default options as returned by optimset
optS = optimset('fzero');

% The structure inputS contains all parameters needed
% to solve the household problem.
% We could pass them as individual arguments, but that is less
% convenient.
inputS.r    = r;
inputS.wY   = wY;
inputS.wOld = wO;
inputS.sigma  = cS.sigma;
inputS.beta = paramS.beta;
inputS.dbg  = cS.dbg;
% Save sequence of guesses?
inputS.saveGuesses = saveGuesses;


% Range of c values to search
% cFloor is a small constant. Avoids trouble with huge
% marginal utilities when c is extremely small.
cLow = cS.cFloor;
cHigh = 0.999 * (inputS.wY + inputS.wOld ./ (1 + inputS.r));


%% Search for a zero of Euler equation deviation

% This command does all the work!
hhDevS.n = 0;
[cY, fVal, exitFlag] = fzero(@deviation, [cLow, cHigh], optS);

% Did fzero converge?
% exitFlag tells us whether fzero found a solution or got stuck
if exitFlag < 0
   warning('fzero failed to converge');
end

% Cap consumption, so households cannot save negative amounts
cY = min(cY, 0.99 .* wY);


% Compute cO from budget constraint
[cO, saving] = hh_budget_olg2d(cY, inputS.wY, inputS.wOld, inputS.r);
if saveGuesses == 1
   fprintf('\nDone. Solution cY %.3f  cOld %.3f \n', cY, cO);
end


% Directly verify that Euler equation deviation is small
if cY < 0.95 * wY
   % Marginal utility today
   muY = ces_util_821(cY, inputS.sigma, cS.dbg);
   % RHS of Euler equation
   muOld = ces_util_821(cO, inputS.sigma, cS.dbg);
   rhs = inputS.beta * (1 + r) * muOld;
   if max(abs(rhs ./ muY - 1)) > 1e-5
      warning('Large Euler equation deviation');
      keyboard;
   end
end


%% Plot the search history of fzero
if saveGuesses == 1
   fh = figures_lh.new(cS.figOptS, 1);
   n = hhDevS.n;
   hold on;
   plot( hhDevS.cYV(1:n), hhDevS.hhDevV(1:n), 'wo' );
   for i1 = 1 : n
      text(hhDevS.cYV(i1), hhDevS.hhDevV(i1), sprintf('%i', i1), 'FontName', cS.figFontName, ...
         'FontSize', cS.figFontSize);
   end
   xlabel('cY');
   ylabel('Euler equation deviation');
   figFn = fullfile(cS.outDir, 'ee_dev_example');
   figure_format_821(fh, 'line');
   figures_lh.fig_save_lh(figFn, 1, 0, cS.figOptS)
end


%% Nested: deviation function
   function [dev, cOld, saving] = deviation(guess)
      [dev, ~, cOld, saving] = hh_dev_olg2d(guess, inputS);
   end


end


