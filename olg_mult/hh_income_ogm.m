function income_keM = hh_income_ogm(kV, R, w, transfer, a, paramS, cS)
% Household income by [k, e]; for given age

% Non-capital income (by shock)
if a <= cS.aR
   nonCapIncomeV = paramS.ageEffV(a) .* w .* paramS.leGridV;
else
   nonCapIncomeV = transfer .* ones([cS.nw, 1]);
end

% Income by [k, e]
income_keM = R * kV(:) * ones([1, cS.nw]) + ones([length(kV),1]) * nonCapIncomeV(:)';


if cS.dbg > 10
   validateattributes(income_keM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
      'size', [length(kV), cS.nw]})
end


end