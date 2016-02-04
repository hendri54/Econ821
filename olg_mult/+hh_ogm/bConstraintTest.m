function bConstraintTest(calNo)

disp('Testing bConstraint');

cS = const_ogm(calNo);
paramS = param_derived_ogm([], cS);

ie = 2;
R = 1.05;
w = 1.5;
transfer = 0.4;

for a = [1, cS.aR-1, cS.aR, cS.aD]
   bcS = hh_ogm.bConstraint(a, ie, R, w, transfer, paramS, cS);
   
   k = paramS.kGridV(10);
   kPrime = paramS.kGridV(8);
   
   [kMin, kMax] = bcS.kPrimeRange(k);
   
   c = bcS.getc(k, kPrime);
   
   kPrime2 = bcS.getKPrime(k, c);
   checkLH.approx_equal(kPrime2, kPrime, 1e-5, []);
end


end