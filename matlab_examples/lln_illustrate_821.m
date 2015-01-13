function lln_illustrate_821
% Illustrate law of large numbers
%{
Based on QuantEcon code
%}
% ----------------------------------------

% No of points to draw
n = 100;
rng(42);  % reproducible results

% Arbitrary collection of distributions

distributionM = {'beta(2, 2)',  makedist('Beta', 'a', 2, 'b', 2);  ...
   'lognormal(0, 0.5)', makedist('Lognormal', 'mu', 0, 'sigma', 0.5); ...
   };
nDist = size(distributionM, 1);


for i1 = 1 : nDist
   % Generate n draws from the distribution
   dataV = random(distributionM{i1, 2}, [n,1]);
   
   trueMean = mean(distributionM{i1, 2});

   % Compute sample mean at each n
   dMeanV = cumsum(dataV) ./ (1 : n)';

   % Plot
   fh = figure;
   hold on;
   plot(1:n, dataV, 'o');
   plot(1:n, dMeanV, '-');
   plot(1:n, trueMean .* ones([1, n]), 'k-');
   hold off;
   title(distributionM{i1,1});
   pause;
   close;
end


end