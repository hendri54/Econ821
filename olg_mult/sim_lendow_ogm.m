function idxM = sim_lendow_ogm(paramS, cS)
% Simulate labor endowments for a cohort of household as it
% moves through the ages
%{
OUT:
   idxM
      labor endowment index by [ind, age]
%}
% --------------------------------------------------

% Seed random number generator for repeatability
rng(433);

% Endowment state by [ind, age]
idxM = markov_lh.markov_sim(cS.nSim, cS.aD, paramS.leProb1V, paramS.leTrProbM', rand([cS.nSim, cS.aD]), cS.dbg);

end