function [gini, cumWtV, cumValueV] = gini_weighted(xV, wtV, dbg)
% Compute Gini and plot Lorenz curve. Weighted data.
%{
% ---------------------------------------
% TASK:
%  The Lorenz plot shows the fraction of the total value
%  attributed to the bottom x percent

% IN:
%  wtV            Weights. Set to scalar if unweighted data.

% OUT:
%  x and y vectors for the Lorenz plot
%  Gini coefficient

% TEST:  t_gini_weighted.m

% AUTHOR: Lutz Hendricks, 2000
%}
% ---------------------------------------

if nargin ~= 3
   error('Invalid nargin');
end



%% Main

% Delete observations with zero weights
if length(wtV) > 1  &&  any(wtV <= 0)
   idxV = find( wtV(:) > 0 );
   if ~isempty(idxV)
      xV = xV(idxV);
      wtV = wtV(idxV);
   else
      error('No data with positive weights');
   end
end


% Sort observations and associated weights
if length(wtV) > 1
   tmp = sortrows([xV(:), wtV(:)], 1);

   % Cumulative weights
   cumWtV = cumsum( tmp(:,2) );
   cumWtV = cumWtV ./ cumWtV(end);

   % Cumulative "value"
   cumValueV = cumsum( tmp(:,1) .* tmp(:,2) );
   clear tmp;

else
   % Unweighted data
   n = length(xV);
   cumValueV = cumsum(sort(xV(:)));
   cumWtV = (1 : n)' ./ n;
end


if cumValueV(end) <= 0
   error('cumValueV(end) <= 0');
end
cumValueV = cumValueV ./ cumValueV(end);



%%  Gini 

% Integrate under the curve
LorenzIntegral = integ1(cumWtV, cumValueV, dbg);
% Gini = [area above the curve] / [area under 45 degree line]
gini = (0.5 - LorenzIntegral) / 0.5;


end