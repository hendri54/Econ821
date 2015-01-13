function [muM, utilM] = ces_util_821(cM, sig, dbg)
% CES utility function

% IN:
%  cM
%     Consumption (matrix of any dimension)
%  sig
%     Sigma. Curvature parameter
%  dbg
%     Debugging parameter

% ------------------------------------

% Check inputs
if dbg > 10
   if any(cM(:) < 1e-8)
      error('Cannot compute utility for very small consumption');
   end
   if length(sig) ~= 1
      error('sig must be scalar');
   end
   if sig <= 0
      error('sig must be > 0');
   end
end

if sig == 1
   % Log utility
   % Utility
   utilM = log(cM);
   % Marginal utility
   muM   = 1 ./ cM;

else
   % Utility
   utilM = cM .^ (1-sig) ./ (1-sig);
   % Marginal utility
   muM = cM .^ (-sig);
end

end