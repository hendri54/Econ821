function [c, kPrime, vFct] = ...
   hh_optc2_ogm(y, R, vPrime, paramS, cS)

% Feasible range for k'
kLow = paramS.kGridV(1);
kHigh = min(paramS.kGridV(end), y - cS.cFloor);

if kHigh <= kLow
   kPrime = kLow;
   c = max(y - kPrime, cS.cFloor);
   [~, vFct] = ces_util_821(c, paramS.sigma, cS.dbg);
   vFct = -vFct;
   
else
   kPrime = fminbnd(@bellman, kLow, kHigh);
   [vFct, c] = bellman(kPrime);
   vFct = -vFct;
end


%% Nested: Bellman
   function [v, c] = bellman(kPrime)
      c = max(y - kPrime, cS.cFloor);
      [~, u] = ces_util_821(c, paramS.sigma, cS.dbg);
      
      v = -(u + R * paramS.beta * vPrime(kPrime));
   end

end
