function [c, kPrime, vFct] = hh_optc_vfi_ogm(y, R, vPrimeOfK, fminbndOptS, paramS, cS)
% Optimal consumption saving choice using
% value function iteration
%{
Budget constraint is  k' = y - c

IN
   vPrimeOfK
      EV next period, function of kPrime
      as a griddedInterpolant
   fminbndOptS
      options for fminbnd (searching for the opt c)
OUT
   c, kPrime
   vFct
      value function
%}

%% Input check
if cS.dbg > 10
end



%% Main

% Range of feasible kPrime
kPrimeMax = min(paramS.kGridV(cS.nk), y - cS.cFloor);
if kPrimeMax <= paramS.kGridV(1)
   % No feasible choice. Hh gets c floor and lowest kPrime
   kPrime = paramS.kGridV(1);
   
else
   % Test: plot vOut against kPrime
   if 0
      n = 50;
      vOutV = nan([n,1]);
      kPrimeV = linspace(paramS.kGridV(1), kPrimeMax, n)';
      for i1 = 1 : n
         vOutV(i1) = -bellman(kPrimeV(i1));
      end
      plot(kPrimeV, vOutV, 'o-');
      keyboard;
   end
   
   % Find optimal kPrime
   [kPrime, fVal, exitFlag] = fminbnd(@bellman, paramS.kGridV(1), kPrimeMax, fminbndOptS);
end


[vFct, c] = bellman(kPrime);
vFct = -vFct;


%% Output check
if cS.dbg > 10
   validateattributes(kPrime, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar', ...
      '>=', paramS.kGridV(1) - 1e-6, '<=', kPrimeMax + 1e-6})
   validateattributes(c, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar', ...
      '>=', cS.cFloor - 1e-6})
   validateattributes(vFct, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar'})
end


%% Nested: objective function
% RHS of Bellman (negative)
   function [vOut, c] = bellman(kPrime)
      c = max(cS.cFloor, y - kPrime);
      [~, u] = ces_util_821(c, paramS.sigma, cS.dbg);
%       EV = 0;
%       for iePrime = 1 : cS.nw
%          EV = EV + leTrProbV(iePrime) * vPrimeOfK{iePrime}(kPrime);
%       end
      vOut = -(u + paramS.beta * R * vPrimeOfK(kPrime));
   end

end