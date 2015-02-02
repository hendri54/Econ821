function [cPolM, kPolM] = ...
   hh_solve_age_ogm(a, cPrimeM, R, w, transfer, paramS, cS)
% Solve hh problem for age a
% Given policy function for a+1 (unless a = aD)
%{
IN:
 a
    Current age
 cPrimeM(ik, ie)
    Consumption policy function for age a+1
    Ignored if a = aD
 transfer
    Age a transfer
 R, w
    Household prices

OUT:
 cPolM, kPolM
    Policy functions, indexed by [ik, ie]
 eeDevM(ik,ie)
    Euler equation deviation

%}

%% Input check

sizeV = [cS.nk, cS.nw];

if cS.dbg > 10
   if a < cS.aD
      if ~isequal(size(cPrimeM), [cS.nk, cS.nw])
         error('Invalid size of cPrimeM');
      end
      if any(cPrimeM(:) < cS.cFloor)
         error('cPrime < cFloor');
      end
   end
end



%% Main

% Income by [k,e]
y_keM = hh_income_ogm(paramS.kGridV, R, w, transfer, a, paramS, cS);


if a == cS.aD
   % Eat your income
   cPolM = y_keM;
   kPolM = zeros(sizeV);

else
   % Precompute marginal utility tomorrow
   uPrimeM = ces_util_821(cPrimeM, cS.sigma, cS.dbg);

   % Allocate space for policy functions
   cPolM  = nan([cS.nk, cS.nw]);
   kPolM  = nan([cS.nk, cS.nw]);

   % Loop over states [ik, ie]
   for ie = 1 : cS.nw
      % Expected u'(c) tomorrow, by kPrime grid point
      emuV = nan([cS.nk, 1]);
      for ik = 1 : cS.nk
         emuV(ik) = paramS.leTrProbM(ie,:) * uPrimeM(ik,:)';
      end
      
      % Loop over capital states
      for ik = 1 : cS.nk
            % Solve for 0 of Euler equation deviation
            [cPolM(ik,ie), kPolM(ik,ie)] = ...
               hh_opt_c_ogm(a, y_keM(ik,ie), R, paramS.kGridV, emuV, paramS, cS);
      end % for ik
   end % for ie
end


%% Output check
if cS.dbg > 10
   validateattributes(cPolM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'positive', ...
      'size', sizeV})
   validateattributes(kPolM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real',  ...
      'size', sizeV})
end

end
