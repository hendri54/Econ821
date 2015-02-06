function [v_keM, c_keM, k_keM] = hh_solve_age2_ogm(...
   a, wageNet, R, transfer, vPrime_keM, paramS, cS)

% Income by [k,e]
y_keM = hh_income_ogm(paramS.kGridV, R, wageNet, transfer, a, paramS, cS);

sizeV = [cS.nk, cS.nw];
c_keM = nan(sizeV);
k_keM = nan(sizeV);
v_keM = nan(sizeV);

for ie = 1 : cS.nw
   vPrime_kV = nan([cS.nk, 1]);
   for ik = 1 : cS.nk
      vPrime_kV(ik) = sum(paramS.leTrProbM(ie,:) * vPrime_keM(ik,:));
   end
   vPrime = griddedInterpolant(paramS.kGridV, vPrime_kV, 'linear');
   for ik = 1 : cS.nk
      y = y_keM(ik, ie);
      
      [c_keM(ik,ie), k_keM(ik,ie), v_keM(ik,ie)] = ...
         hh_optc2_ogm(y, R, vPrime, paramS, cS);
   end
end

end