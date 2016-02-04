% Budget constraint object for one [age, efficiency] state
classdef bConstraint
   
properties
   % Gross int rate
   R
   % non-capital income
   nonCapIncome
   % Consumption floor
   cFloor
   % Borrowing limit
   kMin
   dbg
end


methods
   function bcS = bConstraint(a, ie, R, w, transfer, paramS, cS)
      bcS.dbg = cS.dbg;
      bcS.cFloor = cS.cFloor;
      bcS.kMin = paramS.kMin;
      bcS.R = R;
      % Non-capital income (by shock)
      if a <= cS.aR
         bcS.nonCapIncome = paramS.ageEffV(a) .* w .* paramS.leGridV(ie);
      else
         bcS.nonCapIncome = transfer;
      end
   end
   
   
   % Feasible range for kPrime
   function [kMin, kMax] = kPrimeRange(bcS, k)
      kMin = bcS.kMin;
      kMax = bcS.getKPrime(k, bcS.cFloor) + 1e-6;
      if bcS.dbg > 10
         validateattributes(kMin, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar'})
         validateattributes(kMax, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', size(k)})
      end
   end
   
   function c = getc(bcS, k, kPrime)
      c = bcS.nonCapIncome + bcS.R * k - kPrime;
      if bcS.dbg > 10
         validateattributes(c, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', size(kPrime)})
      end
   end
   
   function kPrime = getKPrime(bcS, k, c)
      kPrime = bcS.nonCapIncome + bcS.R * k - c;
      if bcS.dbg > 10
         validateattributes(kPrime, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'size', size(c)})
      end
   end
end
   
   
end