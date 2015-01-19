function [saveS, success] = var_load_olg2d(varNo, calNo, expNo)
% Load variable
% --------------------------------------------

success = 1;

% Name for parameter file
fPath = var_fn_olg2d(varNo, calNo, expNo);

% Does the file exist?
if exist(fPath, 'file')
   saveS = load(fPath);
   saveS = saveS.saveS;

else
   saveS = [];
   success = 0;
end

end