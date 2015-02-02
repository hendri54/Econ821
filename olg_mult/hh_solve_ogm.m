function [cPolM, kPolM] = hh_solve_ogm(R, w, transferV, paramS, cS)
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


% Backward induction
for a = cS.aD : -1 : 1
   % Next period consumption function
   if a < cS.aD
      cPrimeM = cPolM(:,:,a+1);
   else
      % There is no next period
      cPrimeM = [];
   end

   [cPolM(:,:,a), kPolM(:,:,a)] = ...
      hh_solve_age_ogm(a, cPrimeM, R, w, transferV(a), paramS, cS);
end


%% Output check
if cS.dbg > 10
   validateattributes(cPolM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
      'size', sizeV})
   validateattributes(kPolM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      'size', sizeV, '>=', cS.kMin, '<=', paramS.kGridV(end)})
end

end