function [devV, outS] = cal_dev_ogm(inputS, paramS, cS)
% Returns deviations from calibration targets
% and equilibrium conditions
%{
To be called from eqn solver during calibration
and computation of equilibrium

IN:
 inputS
    wageNet
       After tax wage rate
    R
       After-tax interest rate (R = 1+r)
    transferEarn
       Per capita transfer to the retired as fraction
       of average earnings
   L
      aggregate labor supply
   eIdxM(ind, age)
      simulated labor efficiency shocks

OUT:
 devV     Vector of deviations
 Other variables characterizing steady state
%}

%% Input check

% Switch debugging on at random
if rand([1,1]) < 0.1
   cS.dbg = 111;
end

if cS.dbg > 10
   validateattributes(inputS.R, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar', '>', 0.1})
end


%% Main


% Mass of households working
massWorking = sum(cS.ageMassV(1 : cS.aR));
% Compute avg earnings of working households (after tax)
outS.avgEarn = inputS.wageNet * inputS.L / massWorking;


% Solve household problem (with exogenous prices)
% Set transfers to fraction of avg after-tax earnings
transfer = inputS.transferEarn * outS.avgEarn;
transferV = [zeros(1, cS.aR), ones(1, cS.aD - cS.aR) .* transfer];

[outS.cPolM, outS.kPolM] = hh_solve_ogm(inputS.R, inputS.wageNet, transferV, paramS, cS);


% Simulate capital histories from policy function
% indexed by [ind, age]
outS.kHistM = sim_hh_ogm(outS.kPolM, inputS.eIdxM, paramS, cS);


% Aggregate capital
outS.K = aggr_hist_ogm(outS.kHistM, cS.ageMassV, cS.dbg);
outS.K = max(0.01, outS.K);

% Aggregate output and factor prices
[outS.Y, outS.MPK, outS.MPL] = prod_fct_ogm(outS.K, inputS.L, paramS.A, cS.capShare, cS.dbg);


%%   Deviations  

KYdev = (outS.K / outS.Y) / cS.tgKY - 1;

devV = KYdev;

if 1
   fprintf('    beta: %5.4f    KYdev: %5.4f \n', paramS.beta, KYdev);
end



end
