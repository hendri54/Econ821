function init_821

fprintf('Startup Econ821 \n');

% Add shared progs to path
cS = const_821;
addpath(cS.sharedDir);
addpath(cS.progDir);

set(0, 'DefaultLineLineWidth', 1.5);


end