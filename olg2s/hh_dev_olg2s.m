function [hhDev, s] = hh_dev_olg2s(cY, inputS, paramS, cS)
% Deviation from household Euler equation
%{
IN:
 cY
    Consumption when young
 inputS
      Structure with other inputs required to compute
      Euler equation deviation
      .yY         young income
      .r          Interest rate
      .emuOldV    old expected marginal utility
                  on k grid
      .kGridV

OUT:
 hhDev
    Euler equation deviation
 eeDev
    Same deviation, but without transforming Euler equation
    to avoid strong nonlinearity
    To illustrate the importance of transforming Euler equation
   hhDevS
      updated global struct with iteration history

Note:
   Not efficient. The interpolation of expected marginal utility should be done outside of this
   function
%}
% ---------------------------------------

% Saving
s = inputS.yY - cY;
if s > inputS.kGridV(end)  ||  s < inputS.kGridV(1)
   error('s outside of k grid');
end

% Expected marginal utility tomorrow
% Found by interpolation
emuC = interp1(inputS.kGridV, inputS.emuOldV, s, 'linear');
% Make sure interpolation worked
if isnan(emuC)
   error('Interpolation failed')
end

% Right hand side of Euler equation
rhs = paramS.beta * (1 + inputS.r) * emuC;

% Euler equation deviation (transformed)
hhDev = ces_inv_util_821(rhs, paramS.sigma, cS.dbg) - cY;


end