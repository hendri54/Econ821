function [fPath, fn] = var_fn_olg2s(varNo, calNo, expNo)
% File name for parameter file
% ----------------------------------------------

cS = const_olg2s(calNo);
fn = sprintf('cal%03i_exp%03i_v%03i.mat', calNo, expNo, varNo);
fPath = fullfile(cS.matDir, fn);

end
