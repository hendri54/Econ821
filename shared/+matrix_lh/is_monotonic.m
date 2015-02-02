function result = is_monotonic(xM, xDim, strict, increasing, dbg)
% Is the matrix (strictly) montone in dimension xDim?
%{
IN:
 xM          Matrix of arbitrary dimension
 xDim        Dimension to consider
 strict      1: check for strictly in/decreasing
 increasing  1: check for increasing

OUT:
 result      1: yes; 0: no

TEST:  t_is_monotonic
%}

%% Input check

sizeV = size(xM);

if xDim > length(sizeV)
   error('Invalid xDim');
end


%% Main


xdM = diff(xM, 1, xDim);

if increasing == 1
   if strict == 1
      result = min(xdM(:)) > 0;
   else
      result = min(xdM(:)) >= 0;
   end
elseif increasing == 0
   if strict == 1
      result = max(xdM(:)) < 0;
   else
      result = max(xdM(:)) <= 0;
   end
else
   error('Invalid');
end

end