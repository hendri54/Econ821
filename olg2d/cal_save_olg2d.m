function cal_save_olg2d(calNo, paramS, dbg);
% Save parameters to file
% --------------------------------------------

if nargin ~= 3
   error('Invalid nargin');
end
if length(calNo) ~= 1
   error('calNo must be scalar');
end
if ~isint(calNo)
   error('calNo must be integer');
end

fPath = cal_fn_olg2d(calNo, dbg);
save2(paramS, fPath, dbg);

% *** eof ***
