function outS = hh_budget_olg2s(wY, wOld, r, paramS, cS)
% For each young wage state: return info about the budget


%% Feasible range of cY

% Young earnings
outS.yYV = paramS.eYV .* wY;
ltyMinV = outS.yYV + (paramS.eOldV(1) .* wOld) ./ (1 + r);

% Upper bound on cY
%  Ensures positive consumption tomorrow in each state of the world
outS.cyMaxV = ltyMinV - cS.cFloor;


%% Feasible range for saving

outS.sMinV = outS.yYV - outS.cyMaxV;
outS.sMaxV = outS.yYV - cS.cFloor;


end