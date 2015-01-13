function [fPath, fn] = var_fn_wdi821(varNo)
% File name for a generated variable
% ----------------------------------

cS = const_wdi821;

fn = sprintf('v%03i.mat', varNo);
fPath = fullfile(cS.matDir, fn);

end