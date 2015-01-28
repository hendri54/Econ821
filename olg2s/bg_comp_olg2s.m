function outS = bg_comp_olg2s(paramS, cS, expS)
% Compute steady state
%{
IN:
 calNo
    Determines parameter set to use
 expNo
    Determines policy parameters to use

OUT:
 Solution of steady state conditions.
%}


%% Set parameters


% Prepare input structure for bg_dev_olg2s
inputS.tauR = expS.tauR;
inputS.tauW = expS.tauW;
inputS.wOld = cS.tgWageOld;


% Prepare inputs for equation solver
optS = optimset('fzero');

kLow  = paramS.kGridV(1);
kHigh = paramS.kGridV(end);


%% Plot deviation function
if 0
   n = 30;
   kV = linspace(kLow, kHigh, n);
   devV = nan([n, 1]);
   aggrSV = nan([n, 1]);
   for i1 = 1 : n
      [devV(i1), outS] = wrapper(kV(i1));
      aggrSV(i1) = outS.aggrS;
   end
   
   fh = figures_lh.new(cS.figOptS, 1);
   hold on;
   plot(kV, devV, 'o-');
   plot(kV, aggrSV, 'd-');
   xlabel('k');
   ylabel('BGP deviation');
   legend({'Dev', 's'});
   figure_format_821(fh, 'line');
   pause;
   close;
   return;
end



%% Solve BGP

% Make sure search range is wide enough
devHigh = wrapper(kHigh);
if devHigh < 0
   error('Search range for k is too narrow');
end

% Search for a zero of Euler equation deviation
% k = K/L
[k, fVal, exitFlag] = fzero(@wrapper, [kLow, kHigh], optS);

if exitFlag < 0
   warning('fzero failed to converge');
end

% Compute steady state characteristics
[bgDev, outS] = wrapper(k);

% Aggregate cY
outS.aggrCY = sum( paramS.eYProbV .* outS.cyV );
% Aggregate earnings of young
outS.aggrWY = sum( paramS.eYProbV .* paramS.eYV ) .* outS.w .* outS.lPerYoung;

outS.bgDev = bgDev;


%% Nested: deviation wrapper
   function [bgDev, outS] = wrapper(k)
      [bgDev, outS] = bg_dev_olg2s(k, inputS, paramS, cS);
   end

end
