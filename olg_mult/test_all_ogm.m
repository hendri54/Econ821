function test_all_ogm(calNo)
% Run all tests

cS = const_ogm(calNo);
cS.dbg = 111;

param_set_ogm(calNo);

param_derived_ogm([], cS);

hh_ogm.bConstraintTest(calNo);
hh_ogm.hh_solve_age_test(calNo);
hh_ogm.hh_solve_test(calNo);


end