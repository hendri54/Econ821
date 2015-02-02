function t_is_monotonic
% Test function
% -----------------------------------

dbg = 111;
sizeV = [2,3,4];
%sizeV = [2, 3];
xM = randn(sizeV);

strict = 0;
increasing = 1;

for xDim = 1 : length(sizeV)
   resultV(xDim) = matrix_lh.is_monotonic( xM, xDim, strict, increasing, dbg );
end
disp(' ');
disp([ 'Result for random matrix:  ',  sprintf(' %i', resultV) ]);



disp(' ');
disp('Matrix increasing in dimension 2');
xDim = 2;
for i = 2 : sizeV(xDim)
   xM(:,i,:) = xM(:,i-1,:) + max(xM(:,i,:), 0);
end
for xDim = 1 : length(sizeV)
   resultV(xDim) = matrix_lh.is_monotonic( xM, xDim, strict, increasing, dbg );
end
disp(' ');
disp([ 'Result:  ',  sprintf(' %i', resultV) ]);

end