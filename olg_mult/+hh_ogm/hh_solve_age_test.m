function hh_solve_age_test(calNo)

disp('Testing hh_solve_age');

doProfile = false;

cS = const_ogm(calNo);
cS.dbg = 111;

if doProfile
   cS.dbg = 0;
   profile off;
   profile clear;
   profile on;
end

paramS = param_derived_ogm([], cS);

R = 1.05;
w = 2;
transfer = 0.4 * w;
% Must be concave in k
vPrime_kjM = (linspace(0.1, 10, cS.nk)' .^ 0.5)   *  linspace(1, 2, cS.nw);



%% Syntax test
if 01
   ageV = round(linspace(1, cS.aD, 5));
   for a = ageV
      fprintf('Age %i \n', a);
      hh_ogm.hh_solve_age(a, vPrime_kjM, R, w, transfer, paramS, cS);
   end
end

if doProfile
   profile off;
   profile report
end


end
