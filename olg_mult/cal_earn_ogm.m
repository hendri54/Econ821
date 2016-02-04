function [logGridV, trProbM, prob1V] = cal_earn_ogm(cS)
% Calibrate labor endowment process
%{
This is net of the age efficiency profile

OUT:
   logGridV
      log grid of endowment states
   trProbM
      trProbM(i,j) = Prob i -> j
   prob1V
      stationary and age 1 distribution
%}


[logGridV, trProbM] = ar1LH.tauchen(cS.nw, cS.lePersistence, cS.leShockStd, 0, cS.leWidth);

% New agents draw from an approximate log normal distribution
% On the grid defined by the AR(1)
prob1V = distribLH.norm_grid_lh(logGridV, logGridV(1)-2, logGridV(end)+2, 0, cS.leSigma1, cS.dbg);
prob1V = prob1V(:);

% % New agents draw from stationary distribution
% prob1V = markovLH.markov_stationary(trProbM, cS.dbg);
% prob1V = prob1V(:);


% Improve scaling
logGridV = logGridV(:) - logGridV(1) - 1;



%% Self test
if cS.dbg > 10
   validateattributes(trProbM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, ...
      '<', 1, 'size', [cS.nw, cS.nw]})
   pSumV = sum(trProbM, 2);
   if any(abs(pSumV - 1) > 1e-6)
      error('probs do not sum to 1');
   end
   
   validateattributes(prob1V, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, ...
      'size', [cS.nw, 1]})
   if abs(sum(prob1V) - 1) > 1e-6
      error('prob1V does not sum to 1');
   end
end

end