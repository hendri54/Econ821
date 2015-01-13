function out_ycM = extrapolate_wdi821(data_ycM)
% Interpolate and extrapolate a matrix
% ------------------------------------

cS = const_wdi821;

out_ycM = data_ycM;
[ny, nc] = size(data_ycM);

for ic = 1 : nc
   outV = data_ycM(:, ic);
   if any(~isnan(outV))
      % Value at start
      vIdxV = find(~isnan(outV));
      if vIdxV(1) > 1
         outV(1 : vIdxV(1)) = outV(vIdxV(1));
      end
      % Values at end
      if vIdxV(end) < ny
         outV(vIdxV(end) : ny) = outV(vIdxV(end));
      end
      % Values in between
      vIdxV = find(~isnan(outV));
      out_ycM(:,ic) = interp1(vIdxV, outV(vIdxV), 1:ny, 'linear');
   end
end

validateattributes(out_ycM, {'double'}, {'nonempty', 'real', 'size', size(data_ycM)})


end