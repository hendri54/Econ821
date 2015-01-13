function [y, trProbM] = tauchen(N, pRho, pSigma, pMu, n_std)
%{
    Use Tauchen's (1986) method to produce finite state Markov
    approximation of the AR(1) processes

    y_t = pMu + pRho y_{t-1} + ?_t,
    where ?_t ~ N (0, pSigma^2)

    Parameters
    ----------
    N : int
        Number of points in markov process
    pRho : float
        Persistence parameter in AR(1) process
    pSigma : float
        Standard deviation of random component of AR(1) process
    pMu : float, optional(default=0.0)
        Mean of AR(1) process
    n_std : int, optional(default=3)
        The number of standard deviations to each side the processes
        should span
    Returns
    -------
    y : array(dtype=float, ndim=1)
        1d-Array of nodes in the state space
    trProbM : array(dtype=float, ndim=2)
        Matrix transition probabilities for Markov Process
        trProbM(i,j) = Prob i -> j

   Adapted from QuantEcon Julia code
%}
% ---------------------------------------------------------

%% Get discretized space

% Width of grid
a_bar = n_std * sqrt(pSigma^2 / (1 - pRho^2));
% Grid
y = linspace(-a_bar, a_bar, N);
% Distance between points
d = y(2) - y(1);

%% Get transition probabilities

trProbM = zeros(N, N);
for iRow = 1:N
   % Do end points first
   trProbM(iRow, 1) = normcdf((y(1) - pRho*y(iRow) + d/2) / pSigma);
   trProbM(iRow, N) = 1 - normcdf((y(N) - pRho*y(iRow) - d/2) / pSigma);

   % fill in the middle columns
   for iCol = 2:N-1
      trProbM(iRow, iCol) = (normcdf((y(iCol) - pRho*y(iRow) + d/2) / pSigma) - ...
         normcdf((y(iCol) - pRho*y(iRow) - d/2) / pSigma));
   end
end

% NOTE: I need to shift this vector after finding probabilities
%       because when finding the probabilities I use a function norm_cdf
%       that assumes its input argument is distributed N(0, 1). After
%       adding the mean E[y) is no longer 0, so I would be passing
%       elements with the wrong distribution.
%
%       It is ok to do after the fact because adding this constant to each
%       term effectively shifts the entire distribution. Because the
%       normal distribution is symmetric and we just care about relative
%       distances between points, the probabilities will be the same.
%
%       I could have shifted it before, but then I would need to evaluate
%       the cdf with a function that allows the distribution of input
%       arguments to be [pMu/(1 - pRho), 1) instead of [0, 1)

y = y + pMu / (1 - pRho); % center process around its mean (wbar / (1 - rho))

end