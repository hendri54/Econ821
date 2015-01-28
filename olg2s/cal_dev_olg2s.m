function [dev, outS] = cal_dev_olg2s(paramS, cS, expS)
% Deviation function for simple minded calibration
% ------------------------------------------------

% Compute BGP
outS = bg_comp_olg2s(paramS, cS, expS);

% Deviations from calibration targets
devV = [outS.w ./ cS.tgWageYoung - 1, outS.k / outS.y ./ cS.tgKY - 1, 10 .* (outS.r - cS.tgIntRate)];
dev = sum(devV .^ 2);

end