function [fPath, fn, fDir] = var_fn_pwt8(varNo, cS)
%{
varNo can be string
for named pwt variables such as RDGPO
%}
% ------------------------------------------

% cS = const_pwt8;

if ischar(varNo)
   fn = [varNo, '.mat'];
else
   validateattributes(varNo, {'numeric'}, {'finite', 'nonnan', 'nonempty', 'integer', 'positive', ...
      'scalar'})
   fn = sprintf('v%03i.mat', varNo);
end

fDir = cS.matDir;
fPath = fullfile(fDir, fn);

end