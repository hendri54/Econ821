function idxM = markov_sim(nInd, T, prob0V, trProbM, rvInM, dbg)
% Simulate history of a markov chain 
%{
Based on CompEcon toolbox (though that code seems wrong)
IN:
   nInd
      no of individuals to simulate
   T
      length of histories
   prob0V
      prob of each state at date 1
   trProbM(s', s)
      transition matrix
   rvInM
      uniform random variables, by [ind, t]

OUT:
   idxM(ind, t)

Checked: 2014-Oct-24
%}
% --------------------------------------------------

%% Input check

ns = length(prob0V);

if nargin ~= 6
   error('Invalid nargin');
end

if dbg > 10
   validateattributes(trProbM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, '<=', 1, ...
      'size', [ns, ns]})
   % Make sure probabilities sum to one
   prSumV = sum(trProbM);
   if max(abs( prSumV - 1 )) > 1e-5
      error('Probabilities do not sum to one');
   end
   
   validateattributes(prob0V(:), {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, '<=', 1, ...
      'size', [ns,1]})
   if abs(sum(prob0V) - 1) > 1e-5
      error('Initial probs do not sum to 1');
   end
   
   validateattributes(rvInM, {'double', 'single'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, '<=', 1, ...
      'size', [nInd, T]})
end


%% Preliminaries

% For each state, find cumulative probability
% distribution for next period
cumTrProbM = cumsum(trProbM);
cumTrProbM(ns, :) = 1;

% Need to transpose this for the formula below
% now by [s, s']
cumTrProbM = cumTrProbM';


%%  Iterate over dates

idxM = zeros([nInd, T]);

% Draw t=1
idxM(:, 1) = 1 + sum((rvInM(:,1) * ones(1, ns)) > (ones(nInd,1) * cumsum(prob0V(:)')), 2);

for t = 1 : (T-1)
   idxM(:, t+1) = 1 + sum((rvInM(:,t+1) * ones(1, ns)) > cumTrProbM(idxM(:,t), :), 2);
end


end
