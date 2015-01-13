function go_pwt821

fprintf('Initialize PWT data \n');

cS = const_821;

cd(cS.pwtDir);
addpath(cS.pwtDir);
init_pwt821;

end