function [saveS, success] = var_load_ogm(varNo, calNo, expNo)
% Load variable
% --------------------------------------------

success = 1;

% Name for parameter file
fPath = var_fn_ogm(varNo, calNo, expNo);

% Does the file exist?
if exist(fPath, 'file')
   saveS = load(fPath);
   saveS = saveS.saveS;

else
   saveS = [];
   success = 0;
end

end