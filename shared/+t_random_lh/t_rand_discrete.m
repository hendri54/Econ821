function t_rand_discrete

dbg = 111;
nr = 1e4;
% Must test vector and matrix case
nc = 1;
uniRandM = rand([nr, nc]);

n = 4;
probV = rand([n,1]);
probV = probV ./ sum(probV);

% valueV = round(100 .* rand([n,1]));

outM = random_lh.rand_discrete(probV, uniRandM, dbg);


for i1 = 1 : n
   frac = sum(outM(:) == i1) ./ (nr * nc);
   fprintf('%2i:  prob: %5.2f    frac: %5.2f \n', ...
      i1, 100 * probV(i1), 100 * frac);
end



end