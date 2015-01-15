function t_std_w
% Test function

fprintf('\nTesting std_w\n');

dbg = 111;
nr = 200;
nc = 5;


%% Syntax test

xM = rand([nr, nc]);
wtInM = rand([nr, nc]);

[sdV, xMeanV] = stats_lh.std_w(xM, wtInM, dbg)


%% Case with known mean and std

xM = randn([1e5, 3]);
wtInM = ones(size(xM));

[sdV, xMeanV] = stats_lh.std_w(xM, wtInM, dbg);

meanDev = max(abs(xMeanV - 0));
sdDev = max(abs(sdV - 1));

fprintf('Deviation for std normal rv: mean %f sd: %f \n', meanDev, sdDev);


end