function [cPolM, kPolM, valueM] = ...
   hh_solve_age_vfi_ogm(a, vPrime_keM, R, w, transfer, paramS, cS)
% Solve hh problem for age a, by value function iteration
% Given value function for a+1 (unless a = aD)
%{
IN:
 a
    Current age
 vPrime_keM(ik, ie)
    Value function for age a+1; on k grid
    Ignored if a = aD
 transfer
    Age a transfer
 R, w
    Household prices

OUT:
 cPolM, kPolM, valueM
    Policy functions and value function, indexed by [ik, ie]
%}

%% Input check

sizeV = [cS.nk, cS.nw];

if cS.dbg > 10
   if a < cS.aD
      if ~isequal(size(vPrime_keM), [cS.nk, cS.nw])
         error('Invalid size of cPrimeM');
      end
   end
end



%% Main

% Income by [k,e]
y_keM = hh_income_ogm(paramS.kGridV, R, w, transfer, a, paramS, cS);

% Options for optimization
fminbndOptS = optimset('fminbnd');
fminbndOptS.TolX = 1e-5;


if a == cS.aD
   % Eat your income
   cPolM = max(cS.cFloor, y_keM);
   kPolM = zeros(sizeV);
   [~, valueM] = ces_util_821(cPolM, paramS.sigma, cS.dbg);

else
   % Allocate space for policy functions
   cPolM  = nan([cS.nk, cS.nw]);
   kPolM  = nan([cS.nk, cS.nw]);
   valueM = nan([cS.nk, cS.nw]);

   
   % Loop over states [ik, ie]
   for ie = 1 : cS.nw
      % On k' grid: E V(k')
      vPrime_kV = nan([cS.nk, 1]);
      for ik = 1 : cS.nk
         vPrime_kV(ik) = paramS.leTrProbM(ie,:) * vPrime_keM(ik,:)';
      end
      % Continuous approximation of tomorrows EV(k')
      % Could do better than linear
      vPrimeOfK = griddedInterpolant(paramS.kGridV, vPrime_kV, 'linear');
      
      % Loop over capital states
      for ik = 1 : cS.nk
            % Solve for 0 of Euler equation deviation
            [cPolM(ik,ie), kPolM(ik,ie), valueM(ik,ie)] = ...
               hh_optc_vfi_ogm(y_keM(ik,ie), R, vPrimeOfK, fminbndOptS, paramS, cS);
      end % for ik
   end % for ie
end


%% Output check
if cS.dbg > 10
   validateattributes(cPolM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
      'size', sizeV})
   validateattributes(kPolM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real',  ...
      '>=', cS.kMin - 1e-6,  '<=', paramS.kGridV(cS.nk) + 1e-6, 'size', sizeV})
   validateattributes(valueM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real',  ...
      'size', sizeV})
end

end
