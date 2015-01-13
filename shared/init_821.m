function init_821

fprintf('Startup Econ821 \n');

% Add shared progs to path
cS = const_821;
addpath(cS.sharedDir);
addpath(fullfile(cS.sharedDir, 'export_fig'));

set(0, 'DefaultLineLineWidth', 1.5);


end