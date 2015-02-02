function emu = hh_emu_ogm(ie, a, cPrimeV, paramS, cS)
% Compute E u'(c') for a given state (a, e, k)

% IN:
%  State vector (e, a) (k does not matter)
%  cPrimeV(e')
%     Consumption tomorrow for each e'
% --------------------------------------------

if cS.dbg > 10
   validateattributes(cPrimeV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive'})
end


uPrimeV = ces_util_821(cPrimeV, paramS.sigma, cS.dbg);
emu = paramS.leTrProbM(ie,:) * uPrimeV(:);


if cS.dbg > 10
   validateattributes(emu, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', 'scalar'})
end


end
