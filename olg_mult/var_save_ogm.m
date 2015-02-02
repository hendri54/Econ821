function var_save_ogm(saveS, varNo, calNo, expNo)
% Save file
% --------------------------------------------

fPath = var_fn_ogm(varNo, calNo, expNo);
save(fPath, 'saveS');
fprintf('Saved variable %i for %i / %i \n', varNo, calNo, expNo);

end