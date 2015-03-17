function test_euler_ogm(calNo, expNo)
% Test Euler equation from simulated histories
%{
Not done: exclude states where household hits corners
%}

cS = const_ogm(calNo);
expNo = cS.expBase;
paramS = var_load_ogm(cS.vParams, calNo, expNo);
bgpS = var_load_ogm(cS.vBgp, calNo, expNo);

% Ages to show
nAge = 3;
ageV = round(linspace(5, cS.aR, nAge));




for a = ageV
   [c_keM, rhs_keM] = euler_grid(a, bgpS, paramS, cS);
   euler_plot(c_keM, rhs_keM, a, cS);
end



end


%% Local: Regress c on rhs; plot
function euler_plot(c_keM, rhs_keM, a, cS)
   idxV = find(~isnan(c_keM));

   cMin = min(c_keM(idxV));
   cMax = max(c_keM(idxV));

   fh = figures_lh.new(cS.figOptS, 1);
   hold on;
   plot(rhs_keM(idxV), c_keM(idxV), 'o');
   plot([cMin, cMax], [cMin, cMax], '-');
   xlabel(sprintf('RHS of EE; age %i', a));
   ylabel('c');
   figure_format_821(fh, 'line');
   pause;
   close;
end



%% Local: Compute u'(c) and u'(c') on [k,e] grid
function [c_keM, rhs_keM] = euler_grid(a, bgpS, paramS, cS)
   bR = paramS.beta * (1 + cS.tgIntRate);
   
   c_keM = nan([cS.nk, cS.nw]);
   rhs_keM = nan([cS.nk, cS.nw]);

   minObs = 10;

   for ie = 1 : cS.nw
      for ik = 2 : cS.nk
         idxV = find(bgpS.kHistM(:, a) >= paramS.kGridV(ik-1)  &  bgpS.kHistM(:, a) <= paramS.kGridV(ik)  & ...
            bgpS.eIdxM(:, a) == ie);
         if length(idxV) >= minObs
            % c today
            c_keM(ik, ie) = mean(bgpS.cHistM(idxV,a));
            % u'(c) tomorrow
            uPrimeNextV = ces_util_821(bgpS.cHistM(idxV,a+1), paramS.sigma, cS.dbg);
            rhs_keM(ik,ie) = ces_inv_util_821(bR * mean(uPrimeNextV), paramS.sigma, cS.dbg);
         end
      end   
   end
end
