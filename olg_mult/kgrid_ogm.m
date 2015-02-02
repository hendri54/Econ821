function kGridV = kgrid_ogm(cS)
% Set the k grid
% ----------------------------------------------

% Highest earnings level possible
%  4 std deviations above median at age 1
% maxEarn = cS.tgWage * exp(4 * cS.leSigma1);

% % Find the highest wealth level attainable
% % by age
% maxWealthV = zeros([cS.aR-1, 1]);
% for a = 1 : (cS.aR-1)
%    maxWealthV(a+1) = 0.8 .* maxEarn  +  (1 + cS.tgIntRate) * maxWealthV(a);
% end
% 
% % Highest k grid point
% kHigh = 0.8 * max(maxWealthV);

% Set k grid
kGridV = linspace(cS.kMin, cS.kMax, cS.nk);

end