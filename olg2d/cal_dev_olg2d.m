function [calDev, cY, cO, saving] = cal_dev_olg2d(betaN, inputS, paramS, cS)
% Deviation from calibration conditions
%{
IN:
 betaN
    Guess for beta
 inputS
    Structure with other input arguments
    .r
       Household interest rate
    .wY
       Young household's wage rate
    .wOld
       Old household's transfer
    .k
       K/L
    .saveGuesses
       Save history of guesses into calDevS
 cS
    Exogenous parameters
 paramS
    Calibrated parameters

OUT:
 calDev
    Deviation from calibration conditions
%}
% --------------------------------------------

global calDevS

% Store beta guess for household routine to use
paramS.beta = betaN;

% Solve household problem
[cY, cO, saving] = hh_solve_olg2d(inputS.wY, inputS.wOld, inputS.r, 0, paramS, cS);

% Deviation from capital market clearing
calDev = saving - (inputS.k .* (1 + cS.popGrowth));

% Save guesses
if inputS.saveGuesses == 1
   n = calDevS.n + 1;
   calDevS.n = n;
   calDevS.cYV(n) = cY;
   calDevS.devV(n) = calDev;
end

end
