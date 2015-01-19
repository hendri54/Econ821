function t_var_save_olg2d

calNo = 1;
expNo = 99;
varNo = 999;
dataM = round(100 .* rand([3,4]));

var_save_olg2d(dataM, varNo, calNo, expNo);

loadM = var_load_olg2d(varNo, calNo, expNo);

if ~isequal(dataM, loadM)
   warning('Invalid load');
   keyboard;
else
   fprintf('save / load ok \n');
end

end