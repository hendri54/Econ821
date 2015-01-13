function country_list_wdi821
% Make list of countries. Defines their order in all files
% ------------------------------------------------------

cS = const_wdi821;

% XLS file with WITS codes 
fn = fullfile(cS.dataDir, 'wits_codes.xls');
[~, textM] = xlsread(fn);

saveS.nameV = textM(2:end, 1);
saveS.wbCodeV = textM(2:end, 2);

var_save_wdi821(saveS, cS.vCountryList)

end