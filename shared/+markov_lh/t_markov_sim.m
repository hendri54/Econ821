function t_markov_sim
% Test function for markov_sim
% ---------------------------------


%% Parameters

dbg = 111;

% No of states
ns = 3;
% No of periods
T = 5;
% Initial probabilities
prob0V = linspace(1, 2, ns);
prob0V = prob0V(:) ./ sum(prob0V);
% Transition matrix
trProbM = diag(ones(ns,1)) + ones(ns, ns);
for i1 = 1 : ns
   trProbM(:, i1) = trProbM(:, i1) ./ sum(trProbM(:, i1));
end

% Seed random number generator (for reproducability)
rng(21);


%% Syntax test
if 0
   dbstop error
   disp(' Syntax test ');
   nInd = 4;
   rvIn = rand([nInd, T]);

   idxM = markov_lh.markov_sim(nInd, T, prob0V, trProbM, rvIn, dbg)
   dbclear all
   return;
end


% if 0
%    disp(' ');
%    disp('TEST OF SMOOTHNESS');
%    disp('  Do fractions in each state vary smoothly with parameters?');
% 
%    n = 50 * 1000;
%    rvIn = rand([1, n]);
% 
%    ns = 3;
%    % Value attached to each state
%    stateV = UNDEFINED;
%    x0 = 2;
% 
%    % Range of proability deviations to try
%    np = 10;
%    dProbV = linspace(-0.01, 0.01, np);
% 
%    % Store fraction of observations by simulation / state
%    stateFracM = zeros(np, ns);
% 
%    for i = 1 : np
%       % Simulate for one diagonal probability
%       trProbM = [0.5 0.3 0.2;  0.1 0.5 0.4;  0.2 0.3 0.5];
%       trProbM(:,1) = trProbM(:,1) + dProbV(i);
%       for s = 1 : ns
%          trProbM(s,:) = trProbM(s,:) ./ sum( trProbM(s,:) );
%       end
%       dProbV(i) = trProbM(1,1) - 0.5;
% 
%       idxV = markov_sim(n, x0, stateV, trProbM, rvIn, dbg);
% 
%       % Count fraction in each state
%       countV = zeros(1, ns);
%       for s = 1 : ns
%          countV(s) = length(find( idxV == s ));
%       end
% 
%       % Results:
%       disp(sprintf('Probability perturbation:  %5.4f',  dProbV(i) ));
%       disp('  Fraction of cases in each state:');
%       disp(sprintf('  %7.4f', 100 .* countV ./ n));
% 
%       stateFracM(i,:) = countV ./ n;
%    end
% 
%    if 1
%       plot( dProbV(:), stateFracM(:,1),  'b-',  ...
%             dProbV(:), stateFracM(:,ns), 'r-' );
%       title('Fraction in bottom/top state');
%       xlabel('Probability perturbation');
%       pause_print(0);
%    end
% end



%% Test transition probs
if 1
   disp(' Test of transition probabilities');
   nInd = 1e5;
   rvIn = rand([nInd, T]);

   idxM = markov_lh.markov_sim(nInd, T, prob0V, trProbM, rvIn, dbg);
   
   % Count initial states
   sCntV = accumarray(idxM(:,1), 1);
   sFracV = sCntV ./ sum(sCntV);
   fprintf('Initial states. Max abs diff: %.3f \n',  max(abs(sFracV(:) - prob0V)))
   
   % Count how often state s -> s' occurs
   %  Just for one date
   trCntM = accumarray(idxM(:, 2:3), 1);

   % Transform into transition probs
   % and compute frequency of each state
   trFracM = zeros(ns, ns);
   for s = 1 : ns
      trFracM(:, s) = trCntM(s,:) ./ sum(trCntM(s,:));
   end

   trDiffM = trFracM - trProbM;
   fprintf('ns = %i    Diff in transition probs: %f \n', ...
      ns, max(abs(trDiffM(:))) );
end

end