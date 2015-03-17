function country_list_pwt8
% Diagnostic list of country characteristics
% -------------------------------------------

cS = const_pwt8;

outFn = [cS.outDir, 'country_list.txt'];
fp = fopen(outFn, 'w');


%% Load

cListS = var_load_pwt8(cS.vCountryList);
rgdpeM = var_load_pwt8('rgdpe');
empM   = var_load_pwt8('emp');
[ny, nc] = size(empM);

% m = load([cS.baseDir, 'pwt80.mat']);
% m = m.PWT;
% [nc, ny] = size(m.pop);

idxUSA = find(strcmpi(cListS.wbCodeV, 'USA'));
year1 = 2000;
iy = find(year1 == cListS.yearV);

gdpUSA = rgdpeM(iy, idxUSA);
empUSA = empM(iy, idxUSA);

fprintf(fp, 'RGDP/worker, USA, %i:  %.0f \n', year1,  gdpUSA ./ empUSA);

fmtStr = '%4s %8s %8s';
fprintf(fp, fmtStr, 'ISO', 'GDPe', 'GDPvUSA');
fprintf(fp, '\n');

for ic = 1 : nc
   gdp = rgdpeM(iy, ic);
   emp = empM(iy, ic);
   
   if gdp > 0
      relGdpStr = sprintf('%4.2f', (gdp / emp) ./ (gdpUSA ./ empUSA));
      gdpStr = sprintf('%.0f', gdp);
   else
      relGdpStr = '-';
      gdpStr = '-';
   end
   
   fprintf(fp, fmtStr, cListS.wbCodeV{ic}, gdpStr, relGdpStr);
   fprintf(fp, '\n');
end


fclose(fp);
type(outFn);

end