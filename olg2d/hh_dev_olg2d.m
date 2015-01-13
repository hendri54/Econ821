function [hhDev, eeDev] = hh_dev_olg2d(cY, inputS)
% Deviation from household Euler equation
%{
% IN:
%  cY
%     Consumption when young
%  inputS
%     Structure with other inputs required to compute
%     Euler equation deviation
%     .W       Lifetime income: wY + wO / (1+r)
%     .r       Interest rate
%     .beta    Discount factor
%     .sig     Sigma
%     .dbg     Debugging switch

% OUT:
%  hhDev
%     Euler equation deviation
%  eeDev
%     Same deviation, but without transforming Euler equation
%     to avoid strong nonlinearity
%     To illustrate the importance of transforming Euler equation
   hhDevS
      updated global struct with iteration history
%}
% ---------------------------------------

% Save the sequence of points tried by zero in this global
global hhDevS

% Old consumption from the budget constraint
cO = (1 + inputS.r) .* max(inputS.W - cY, 1e-5);

% Marginal utility tomorrow
muC = ces_util_821(cO, inputS.sigma, inputS.dbg);

% Right hand side of Euler equation
rhs = inputS.beta * (1 + inputS.r) * muC;

% Euler equation deviation (transformed)
hhDev = ces_inv_util_821(rhs, inputS.sigma, inputS.dbg) ./ cY - 1;


% For comparison, also return deviation from untransformed Euler equation
% Marginal utility today
muY = ces_util_821(cY, inputS.sigma, inputS.dbg);
eeDev = muY ./ rhs - 1;

if ~isempty(hhDevS)  &&  1
   % Number of elements computed so far
   n = hhDevS.n + 1;
   hhDevS.cYV(n) = cY;
   hhDevS.hhDevV(n) = hhDev;
   hhDevS.n = n;
end

end