function t_cdf_lh

dbg = 111;
n = 1e2;
xV = rand([n,1]);
ng = 8;
xGridV = linspace(-0.2, 1.2, ng);

prGridV = distrib_lh.cdf_lh(xV, xGridV, dbg)

% Direct check
for ig = 1 : ng
   cnt = sum(xV < xGridV(ig));
   if abs(cnt / n - prGridV(ig)) > 1e-6
      error('invalid');
   end
end

end