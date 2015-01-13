function paramS = cal_load_olg2d(calNo, dbg);
% Load parameters into structure paramS
% --------------------------------------------

% Name for parameter file
fPath = cal_fn_olg2d(calNo, dbg);

% Does the file exist?
if exist(fPath) > 0
   paramS = load2(fPath, dbg);

else
   % Set arbitrary guesses
   paramS.beta = 0.97;
   paramS.A = 1;
   paramS.ddk = 0.05;
end


% *******  Set any missing parameters to defaults  ********
if ~isfield(paramS, 'beta')
   paramS.beta = 0.95;
end

% *** eof ***
