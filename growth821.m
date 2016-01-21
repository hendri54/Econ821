function growth821

%% Set parameters

nIter = 40;

pBeta = 0.95;
pAlpha = 0.35;

kSS = (pAlpha * pBeta) ^ (1 / (1-pAlpha));

nk = 100;
kGridV = linspace(kSS ./ 20, kSS .* 20, nk);

v0V = log(kSS) .* ones(size(kGridV));

% V(k,n)
valueM = nan(nk, nIter);
valueM(:, 1) = -10;

%% Main loop

tic
for n = 2 : nIter
   oldValueV = valueM(:, n-1);
   
   vOld = griddedInterpolant(kGridV, oldValueV);

   % Loop over k
   for ik = 1 : nk
      k = kGridV(ik);
      cLow = max(1e-3, k ^ pAlpha - kGridV(nk));
      cHigh = max(cLow + 1e-3, k ^ pAlpha - kGridV(1));
      
      % Anonymous function
      %bellanon = @(c) -(log(c) + pBeta .* interp1(kGridV, oldValueV, k ^ pAlpha - c, 'linear', 'extrap'));
      bellanon = @(c) -(log(c) + pBeta .* vOld(k ^ pAlpha - c));
      
      cOpt = fminbnd(bellanon, cLow, cHigh);
      valueM(ik,n) = -bellnest(cOpt);
   end
   
end
toc


%% Plot value functions

fh = figure('visible', 'on');
hold on;

for n = 1 : nIter
   plot(kGridV, valueM(:, n), '-');
end

hold off;
xlabel('k');
ylabel('V(k)');


%% Nested Bellman
function out1 = bellnest(c)
   out1 = bellman(c, kGridV(ik), kGridV, oldValueV, pAlpha, pBeta);
end

end



%% Bellman
%{
OUT: - RHS of Bellman
%}
function out1 =  bellman(c, k, kGridV, valueV, pAlpha, pBeta)

   out1 = -(log(c) + pBeta .* interp1(kGridV, valueV, k ^ pAlpha - c, 'linear', 'extrap'));

end