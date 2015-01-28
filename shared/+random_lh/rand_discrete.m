function idxM = rand_discrete(probV, uniRandM, dbg)
% draw discrete random variables, given probabilities and uniform random vars (for repeatability)
%{
IN:
   probV
      prob of each value in valueV
   uniRandM
      matrix of uniform random vars 

OUT:
   idxM
      state for each observation
%}


%% Input check

sizeV = size(uniRandM);

if nargin < 4
   dbg = 0;
end
if nargin < 3
   error('Too few input args');
end

% Check that inputs are uniform random vars
if any(uniRandM(:) > 1)  ||  any(uniRandM(:) < 0)
   error('Not valid random vars');
end

%% Main


% Cumulative probs
n = length(probV);
cumProbV = cumsum(probV);
if abs(cumProbV(n) - 1) > 1e-6
   error('Probs must sum to 1');
end
cumProbV(n) = 1;


% Assign output values
% if length(sizeV) == 2  &&  min(sizeV) == 1
%    % Vector
%    idxM = 1 + sum((uniRandM(:) * ones(1, n)) > (ones([length(uniRandM),1]) * cumProbV(:)'), 2);
% 
% else
%    % Matrix of any dim
%    idxM = ones(size(uniRandM));
%    for i1 = 1 : (n-1)
%       idxM(uniRandM > cumProbV(i1)) = i1 + 1;
%    end
% end


%% Alternative code (based on gendist.m from file exchange)
% This is faster than my code for large matrices

[~,idxV] = histc(uniRandM(:)', [0; cumProbV(:)]);

idxM = reshape(idxV, size(uniRandM));

% if ~isequal(idxM, idx2M)
%    warning('Not equal');
%    keyboard;
% end


%% Output check
if dbg > 10
   validateattributes(idxM, {'numeric'}, {'finite', 'nonnan', 'nonempty', 'integer', ...
      '>=', 1,  '<=', n, 'size', sizeV})
end

end