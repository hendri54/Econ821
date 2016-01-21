function saveS = country_list_wdi2013
% Make a list of country codes and names
% --------------------------------------

cS = const_wdi2013;

fn = fullfile(cS.xlsDir, 'wits_codes.xls');
[~, textM] = xlsread(fn);

saveS.nameV = textM(2:end, 1);
saveS.wbCodeV = textM(2:end, 2);




end