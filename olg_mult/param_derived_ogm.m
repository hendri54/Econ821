function paramS = param_derived_ogm(paramS, cS)
% Set derived parameters
% ------------------------------------

if isempty(paramS)
   paramS = param_set_ogm(cS.calNo);
end

paramS.sigma = cS.sigma;

% Borrowing limit
paramS.kMin = 0;

% Capital grid
paramS.kGridV = kgrid_ogm(cS);
paramS.kGridV = paramS.kGridV(:);

% Precalibrate tech parameters
%  should be general purpose code!
[paramS.A, paramS.ddk] = cal_tech_ogm(cS.tgKY, cS.tgIntRate, cS.tgWage, cS.capShare, cS);

% Precalibrate labor endowment process
%  trProbM: i -> j
[paramS.leLogGridV, paramS.leTrProbM, paramS.leProb1V] = cal_earn_ogm(cS);
paramS.leGridV = exp(paramS.leLogGridV);

% Age efficiency profile
% A crude linear approximation of Huggett (1996), by physical age
% Levels
ageEffV = zeros(100, 1);
ageEffV(20:72) = [linspace(0.3, 1.5, 36-20+1), 1.5 .* ones(1, 47-37+1), ...
   linspace(1.5, 0.2, 65-48+1), linspace(0.18, 0, 72-66+1)];
paramS.ageEffV = ageEffV(cS.age1 : cS.ageLast);


% Utility function (handle)
paramS.uFct = @(c)  c .^ (1-paramS.sigma) ./ (1-paramS.sigma);

end