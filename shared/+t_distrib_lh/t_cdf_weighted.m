function t_cdf_weighted
% -----------------------------------------

dbg = 111;

if 01
   disp(' ');
   disp('Test case 1');
   n = 5;
   wtInV = ones(1, n);
   xInV  = 1 : n;

   if 1
      wtInV(2) = 0;
   end
   [cumPctV, xV, cumTotalV] = cdf_weighted(xInV, wtInV, dbg);

   cumPctV
   xV
   cumTotalV
end


end