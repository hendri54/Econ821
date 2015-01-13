function clt_illustrate_821
% Illustrate Central Limit Theorem
%{
Adapted from QuantEcon
%}
% ---------------------------------

%% Set parameters 

rng(42);  % reproducible results
n = 250;    % Choice of n
k = 10000;  % Number of draws of Y_n

dist = makedist('Exponential', 'mu', 0.5);  % Exponential distribution, lambda = 1/2
trueMean = mean(dist);
trueStd  = std(dist);
fprintf('True mean: %.2f  std: %.2f \n',  trueMean, trueStd);

% == Draw underlying RVs. Each row contains a draw of X_1,..,X_n == %
data = random(dist, [k, n]);

% == Compute mean of each row, producing k draws of \bar X_n == %
sample_means = mean(data, 2);

% == Generate observations of Y_n == %
Y = sqrt(n) * (sample_means - trueMean);


%% Plot

xmin = -3 * trueStd;
xmax =  3 * trueStd;

fh = figure;
hold on;

% Std normal pdf
xV = linspace(xmin, xmax, 100);
plot(xV, normpdf(xV, 0, trueStd), '-');

% Histogram of means
histogram(Y, 60, 'Normalization', 'pdf');

hold off;

axisV = axis;
axis([xmin, xmax, axisV(3:4)]);
% ax[:hist](Y, bins=60, alpha=0.5, normed=true)
% xgrid = linspace(xmin, xmax, 200)
% ax[:plot](xgrid, pdf(Normal(0.0, s), xgrid), "k-", lw=2,
%           label=LaTeXString("\$N(0, \\sigma^2=$(s^2))\$"))
% ax[:legend]()

pause;
close;

end