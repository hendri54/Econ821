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


[logGridV, trProbM] = ar1_lh.tauchen(cS.nw, cS.lePersistence, cS.leShockStd, 0, cS.leWidth);

% New agents draw from stationary distribution
prob1V = markov_lh.markov_stationary(trProbM, cS.dbg);
prob1V = prob1V(:);


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