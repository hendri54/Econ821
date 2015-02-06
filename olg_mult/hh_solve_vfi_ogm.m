function [cPolM, kPolM, valueM] = hh_solve_vfi_ogm(R, w, transferV, paramS, cS)
% Solve hh problem
%{
IN:
 R = 1+r, w
    Household prices
 transferV
    Lump-sum transfers by age

OUT:
 cPolM, kPolM
    Consumption and savings functions
    by [ik, ie, age]
%}


%% Main

% Initialize policy function by [ik, ie, age]
sizeV = [cS.nk, cS.nw, cS.aD];
cPolM = nan(sizeV);
kPolM = nan(sizeV);
valueM = nan(sizeV);


% Backward induction
for a = cS.aD : -1 : 1
   if rem(a,30) == 0
      fprintf('hh age %i \n', a);
   end
   % Next period consumption function
   if a < cS.aD
      vPrimeM = valueM(:,:,a+1);
   else
      % There is no next period
      vPrimeM = [];
   end

   [cPolM(:,:,a), kPolM(:,:,a), valueM(:,:,a)] = ...
      hh_solve_age_vfi_ogm(a, vPrimeM, R, w, transferV(a), paramS, cS);
end


%% Output check
if cS.dbg > 10
   validateattributes(cPolM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
      'size', sizeV})
   validateattributes(valueM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      'size', sizeV})
   validateattributes(kPolM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      'size', sizeV, '>=', cS.kMin - 1e-6, '<=', paramS.kGridV(end) + 1e-6})
end

end