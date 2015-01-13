function init_growth821

fprintf('Startup growth progs \n');

cS = const_growth821;

% Need pwt data
go_pwt8;
go_wdi821;
cd(cS.progDir);


end