function [calDev, cY, cO] = cal_dev_olg2d(betaN, inputS, olg2dS, paramS);
% Deviation from calibration conditions

% IN:
%  betaN
%     Guess for beta
%  inputS
%     Structure with other input arguments
%     .dbg
%     .r
%        Household interest rate
%     .wY
%        Young household's wage rate
%     .wOld
%        Old household's transfer
%     .k
%        K/L
%     .saveGuesses
%        Save history of guesses into calDevS
%  olg2dS
%     Exogenous parameters
%  paramS
%     Calibrated parameters

% OUT:
%  calDev
%     Deviation from calibration conditions

% --------------------------------------------

global calDevS

% Store beta guess for household routine to use
paramS.beta = betaN;

% Solve household problem
[cY, cO] = hh_solve_olg2d(inputS.wY, inputS.wOld, inputS.r, 0, ...
   olg2dS, paramS, inputS.dbg);

% Deviation from capital market clearing
calDev = (inputS.wY - cY) ./ (inputS.k .* (1 + olg2dS.popGrowth)) - 1;

% Save guesses
if inputS.saveGuesses == 1
   n = calDevS.n + 1;
   calDevS.n = n;
   calDevS.cYV(n) = cY;
   calDevS.devV(n) = calDev;
end

% *****  eof  *******
