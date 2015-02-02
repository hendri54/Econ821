function kHistM = sim_hh_ogm(kPolM, eIdxM, paramS, cS)
% Simulate a population of households
%{
Method:
   Populate a set of households
   Households go through sequence of labor endowments
   given in eIdxM
   Compute capital holdings from kPolM

IN:
 kPolM
    k' policy function, by [ik, ie, a]
 eHistM
    labor endowment histories by [ind, age]
 
OUT:
 kHistM
    Capital stock histories for households
    by [ind, age]

%}
% -----------------------------------------------------

nSim = size(eIdxM, 1);

%% Input checks
if cS.dbg > 10
   validateattributes(kPolM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      'size', [cS.nk,cS.nw,cS.aD]})
end


%% Simulate capital histories, age by age
% Not efficient +++

kHistM = nan([nSim, cS.aD]);
kHistM(:,1) = zeros([nSim, 1]);
for a = 1 : (cS.aD - 1)
   for ie = 1 : cS.nw
      % Find households with labor endowment ie at this age
      idxV = find(eIdxM(:,a) == ie);
      if ~isempty(idxV)
         % Find next period capital for each individual by interpolation
         kHistM(idxV, a+1) = interp1(paramS.kGridV(:), kPolM(:,ie,a), ...
            kHistM(idxV, a), 'linear');
      end
   end
end

%% Output check
if cS.dbg > 10
   validateattributes(kHistM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      '>', paramS.kGridV(1) - 1e-6})
end


%keyboard;   % +++++
   

end
