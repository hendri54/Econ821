function growth_model_821(showPlot)
%{
A first pass at solving the optimal growth problem via value function
iteration.  A more general version is provided in optgrowth.py (QuantEcon).

Adapted from quant-econ julia code

Not how much more complicated this is in Matlab relative to Julia
(because we cannot define an interpolation object to pass to the objective function
[actually, we could; see griddedInterpolant])

IN
   showPlot :: Boolean
      generate a plot with value functions as iterations progress?
%}
% --------------------------------------------


% Primitives and grid
n = 100;
alpha = 0.65;
bet = 0.95;
grid_max = 2;
grid_size = 150;
gridV = 1e-2:(grid_max-1e-6)/(grid_size-1):grid_max;




%% Main

if showPlot == 1
   fh = figure;
   hold on;
   plot(gridV, v_star(gridV), 'k-');
end

    
wV = 5 .* log(gridV) - 25;  % An initial condition -- fairly arbitrary
tic
for i1 = 1:n
   wV = bellman_operator(gridV, wV, alpha, bet);
   if (showPlot == 1)  &&  (rem(i1, 10) == 0)
      plot(gridV, wV, '-');
   end
end
toc

if showPlot == 1
   hold off;
   xlabel('k');
   ylabel('w');
end

return;

    
%% Nested

   % Exact solution
   function outV = v_star(k)
      ab = alpha * bet;
      c1 = (log(1 - ab) + log(ab) * ab / (1 - ab)) / (1 - bet);
      c2 = alpha / (1 - ab);
      outV = c1 + c2 .* log(k);
   end
    
end


%% Local: Bellman
%{
3 implementations of the objective function
   nested
   anonymous
   using griddedInterpolant
%}

function Tw = bellman_operator(gridV, wV, alpha, bet)
   optS = optimset('fminbnd');
   optS.TolX = 1e-6;

   % Interpolation object
   Aw = griddedInterpolant(gridV, wV, 'linear');

   % Output of the Bellman operator for each k grid point
   Tw = zeros(size(gridV));

   for i1 = 1 : length(gridV)
      k = gridV(i1);
      % Find acceptable range for c
      cMin = 1e-6;
      cMax = k^alpha - 1e-6;
      
      if 0
         % Objective function as anonymous function
         dev_fct2 = @(c) (- log(c) - bet * interp1(gridV, wV, k^alpha - c, 'linear'));      
         [cOpt, fVal, exitFlag] = fminbnd(dev_fct2, cMin, cMax, optS);
      elseif 1
         % Using interpolation object (by far the fastest approach)
         dev_fct3 = @(c) (- log(c) - bet * Aw(k^alpha - c));      
         [cOpt, fVal, exitFlag] = fminbnd(dev_fct3, cMin, cMax);
      else
         % Objective function as nested function
         [cOpt, fVal, exitFlag] = fminbnd(@dev_fct, cMin, cMax);
      end
      
      Tw(i1) = -fVal;
   end
    
    % Local
   function dev = dev_fct(c)
      dev = obj_fct(c, k, gridV, wV, alpha, bet);
   end
end

% Objective function: negative value function
function dev = obj_fct(c, k, gridV, wV, alpha, bet)
   dev = - log(c) - bet * interp1(gridV, wV, k^alpha - c, 'linear');
end
