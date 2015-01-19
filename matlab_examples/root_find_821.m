function root_find_821
% Root finding example
% -------------------------

%% Parameters

a = 4;
xLb = 0;
xUb = 4;
n = 100;


%% Plot
if 0
   xGridV = linspace(xLb, xUb, n);

   fh = figure;
   plot(xGridV, dev_fct(xGridV, a), '-');
   pause;
   close;
end


%% Find zero

xGuess = 5;
xOpt = fzero(@dev_wrapper, xGuess);
fprintf('Solution: %f \n', xOpt);


%% Nested: wrapper
   function dev = dev_wrapper(x)
      dev = dev_fct(x,a);
   end


end


function dev = dev_fct(x, a)
   dev = x .^ 2 - a;
end