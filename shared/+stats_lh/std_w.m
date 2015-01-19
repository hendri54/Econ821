function [sdV, xMeanV] = std_w(xM, wtInM, dbg)
% Std deviation for weighted observations
%{
TASK:
   If xM is a matrix, then treat each column as a vector of data

IN:
   xM       vector/matrix of observations
   wtInM    vector/matrix of weights

OUT:
   sdV      weighted std dev
   xMeanV   weighted average

AUTHOR: Lutz Hendricks, 1997
%}


%% Input check

if nargin < 3
   dbg = 1;
end
if nargin < 2
   error('Invalid nargin');
end
if ~isequal(size(xM), size(wtInM))
   error('Size mismatch');
end

if dbg > 10
   if any(wtInM(:) < 0)
      error('Negative weights');
   end
end


%% Main

% Inefficient, but hard to avoid
xM = double(xM);
wtInM = double(wtInM);

sizeV = size(xM);
if length(sizeV) > 2
   error('Not implemented for matrices of dim > 2');
elseif length(sizeV) < 2
   error('Input matrix is empty');
elseif min(sizeV) == 1
   % Vector
   % Make sure weights sum to 1
   wtV = wtInM ./ sum(wtInM);

   xMeanV = sum( wtV(:) .* xM(:) );

   sdV = sqrt( sum( wtV(:) .* (xM(:) - xMeanV).^2 ));

else
   % Matrix
   % Make sure weights sum to 1
   wtM = wtInM ./ (ones(sizeV(1),1) * sum(wtInM));

   xMeanV = sum( wtM .* xM );

   sdV = sqrt( sum( wtM .* (xM - (ones(sizeV(1),1) * xMeanV)).^2 ));
end


%% Output check
if dbg > 10
   validateattributes(xMeanV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real'})
   validateattributes(sdV, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', '>=', 0})
end


end