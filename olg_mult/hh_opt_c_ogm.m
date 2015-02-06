function [c, kPrime] = ...
   hh_opt_c_ogm(a, y, R, kPrimeV, emuV, paramS, cS)
%
% Compute optimal c for one state vector (ik, ie, a)
% given tomorrow's Eu'(c') by k'
%{
Budget constraint is: k' = y - c

If hh cannot afford any k': he gets cons floor

IN:
   a
      age
   y
      Today's income
   emuV(kPrime)
      Tomorrow's expected marginal utility
   kPrimeV
      k' grid
%}

%% Input check

nk = length(kPrimeV);

if length(emuV) ~= nk
   error('Invalid emuV');
end


%% Main

% Consumption by k'
cV = y - kPrimeV;
% Feasible k'
kpIdxV = find(cV > cS.cFloor);

if isempty(kpIdxV)
   kPrime = kPrimeV(1);
   c = cS.cFloor;
   return;
end

if a == cS.aD
   % In the last period: Eat all income
   kPrime = kPrimeV(1);

else
   % ******  Find a 0 of the EE deviation
   % Also check for corner solutions
   % EE dev goes from positive (low k') to negative (high k')

   % Compute Euler equation deviation on kPrime grid
   eeDevV = hh_ee_dev_ogm(kPrimeV(kpIdxV), a, y, R, emuV(kpIdxV), paramS, cS);   

   if eeDevV(1) > 0
      % Corner solution: Would like to borrow and raise c more
      kPrime = kPrimeV(kpIdxV(1));
      
   elseif eeDevV(1) < 0  &&  eeDevV(end) > 0
      % Interior case
      % Sign switches within grid. Just interpolate
      kPrime = interp1(eeDevV, kPrimeV(kpIdxV), 0, 'linear');
      %kPrime = interp1qr(eeDevV, kPrimeV(kpIdxV), 0);
      
   else
      % All eeDevV < 0
      % No sign change on feasible grid points
      if kpIdxV(end) == nk
         % Grid is too narrow
         kPrime = kPrimeV(nk);
         
      else
         % Sign switches between last feasible and first infeasible grid point
         % This will be inaccurate
         kPrimeMax = y - cS.cFloor;
         % Compute EMU(kPrimeMax) by interpolation
         emuMax = interp1(kPrimeV, emuV, kPrimeMax, 'linear');
         % Compute Euler equation deviation on that grid
         eeDevMax = hh_ee_dev_ogm(kPrimeMax, a, y, R, emuMax, paramS, cS);  
         if eeDevMax > 0
            % We now have a sign change
            % find kPrime by interpolation
            kPrime = interp1([eeDevV(kpIdxV); eeDevMax],  [kPrimeV(kpIdxV); kPrimeMax],  0,  'linear');   
         else
            % Still no sign change
            kPrime = kPrimeMax;
         end
      end
   end
end

if isnan(kPrime)
   error('Invalid');
end

c = max(cS.cFloor, y - kPrime);


%% Output check
if cS.dbg > 10
   validateattributes(c, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar', 'positive'})
   validateattributes(kPrime, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', 'scalar', ...
      '>=', kPrimeV(1), '<=', kPrimeV(end) + 1e-6})
end

kPrime = min(kPrimeV(end), max(kPrime, kPrimeV(1)));



end
