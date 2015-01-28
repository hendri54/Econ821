function [cyV, sV] = hh_solve_olg2s(wY, wOld, r, paramS, cS)
% Solve the household problem
%{
IN:
   wY, wOld
      Wage rates when young, old
   r
      Interest rate
   paramS, cS
      calibrated and exogenous parameters

OUT:
   cyV
      consumption function (by young wage shock)
%}


%%  Check input arguments

% nargin is the number of input arguments
if nargin ~= 5
   error('Invalid nargin');
end



%% Prepare inputs for equation solver

% Info about budget (for setting asset range over which to evaluate MU(old))
budgetS = hh_budget_olg2s(wY, wOld, r, paramS, cS);

% Asset grid (depends on prices)
kMin = min(budgetS.sMinV) - 0.1;
kMax = max(budgetS.sMaxV) + 0.1;
inputS.kGridV = linspace(kMin, kMax, cS.nk);

% EMU(c) when old
% on k grid
inputS.emuOldV = mu_old_olg2s(wOld, r, inputS.kGridV, paramS, cS);


% We use default options as returned by optimset
optS = optimset('fzero');

% The structure inputS contains all parameters needed
% to solve the household problem.
% We could pass them as individual arguments, but that is less
% convenient.
inputS.r = r;




%% Search for a zero of Euler equation deviation

cyV = nan([cS.nw, 1]);
sV  = nan([cS.nw, 1]);

for i1 = 1 : cS.nw
   inputS.yY = budgetS.yYV(i1);
   
   % Range of c values to search
   % cFloor is a small constant. Avoids trouble with huge
   % marginal utilities when c is extremely small.
   cLow  = cS.cFloor + 1e-6;
   cHigh = budgetS.cyMaxV(i1);
   
   % Check for corner
   devHigh = deviation(cHigh);
   if devHigh > 0
      cyV(i1) = cHigh;
      
   else
      % This command does all the work!
      [cyV(i1), fVal, exitFlag] = fzero(@deviation, [cLow, cHigh], optS);

      % Did fzero converge?
      % exitFlag tells us whether fzero found a solution or got stuck
      if exitFlag < 0
         warning('fzero failed to converge');
      end
   end
   
   sV(i1) = inputS.yY - cyV(i1);
end




%% Nested: deviation function
   function [dev, s] = deviation(guess)
      [dev, s] = hh_dev_olg2s(guess, inputS, paramS, cS);
   end


end


