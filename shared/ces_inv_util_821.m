function muInvM = ces_inv_util_821(muM, sig, dbg)
% CES inverse marginal utility function
% Also works for sig = 1 (log utility)

% IN:
%  muM
%     Marginal utility (matrix of any dimension)
%  sig
%     Sigma. Curvature parameter
%  dbg
%     Debugging parameter

% ------------------------------------

% Check inputs
if dbg > 10
   if length(sig) ~= 1
      error('sig must be scalar');
   end
   if sig <= 0
      error('sig must be > 0');
   end
end


% Inverse Marginal utility
muInvM = muM .^ (-1/sig);

end