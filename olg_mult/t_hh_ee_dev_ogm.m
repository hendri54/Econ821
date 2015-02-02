function t_hh_ee_dev_ogm(calNo)
% ------------------------------

cS = const_ogm(calNo);
paramS = param_derived_ogm([], cS);


y = 10;
R = 1.05;
cPrimeV = linspace(5, 15, cS.nk);
emuV = ces_util_821(cPrimeV, paramS.sigma, cS.dbg)';
kPrimeV = paramS.kGridV;
a = 5;


%% Raising beta should decrease EE dev
if 01
   n = 10;
   betaV = linspace(0.7, 1.5, n);
   kIdx = 4;
   
   eeDevV = nan([n,1]);
   for i1 = 1 : length(betaV)
      paramS.beta = betaV(i1);
      
      eeOutV = hh_ee_dev_ogm(kPrimeV, a,  y, R, emuV, paramS, cS);
      eeDevV(i1) = eeOutV(kIdx);
   end
   
   disp('beta, eeDev');
   disp([betaV(:),  eeDevV]);
end


%% Syntax test
if 01
   aV  = 1 : cS.aD - 1;

   for a = aV(:)'
      [eeDevV, cV] = ...
         hh_ee_dev_ogm(kPrimeV, a,  y, R, emuV, paramS, cS);

      % u'(c) today
      muV = nan(size(cV));
      idxV = find(cV > 0);
      if ~isempty(idxV)
         muV(idxV) = ces_util_821(cV(idxV), paramS.sigma, cS.dbg);
      end

      % For one age: show EE dev as c varies
      if a == aV(2)
         disp(' ');
         disp('EE deviation   c    E MU(c)  RHS   MU(c)');
         disp([eeDevV(:),  cV(:),  emuV(:), paramS.beta .* R .* emuV(:),  muV(:)]);
      end

   end % for aV
end



end