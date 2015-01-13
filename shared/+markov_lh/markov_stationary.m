function distrV = markov_stationary(trM, dbg)
% Returns the stationary distribution associated with
% a Markov transition matrix trM
%{
% Uses the fact that the eigenvector associated with
% eigenvalue 1 is the stationary distribution.

% IN:
%  trM
%     trM(i,j) = Pr(i -> j)

% OUT:
%  distrV
%     Stationary distribution. Row vector
%}
% ----------------------------------------------------


%% Input check

trSumV = sum(trM, 2);
if max(abs(trSumV - 1)) > 1e-7
   error('Rows of trM do not sum to 1');
end

if dbg > 10
   ns = length(trM);
   validateattributes(trM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0, '<=', 1, ...
      'size', [ns,ns]})
end


%% Main

[eigVecM, eigValM] = eig(trM');

% Find eigenvector associated with eigenvalue 1
idx1 = find(abs(diag(eigValM) - 1) < 1e-8);
if length(idx1) ~= 1
   error('Cannot find eigenvalue 1');
end

distrV = eigVecM(:,idx1)' ./ sum(eigVecM(:,idx1));


%%  Output check
if dbg > 10
   validateattributes(distrV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      'size', [1,ns], '>=', 0, '<=', 1})
   if abs(sum(distrV) - 1) > 1e-6
      error('Does not sum to 1');
   end
end


end
