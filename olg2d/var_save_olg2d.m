function var_save_olg2d(saveS, varNo, calNo, expNo)
% Save file
% --------------------------------------------

fPath = var_fn_olg2d(varNo, calNo, expNo);
save(fPath, 'saveS');
fprintf('Saved variable %i for %i / %i \n', varNo, calNo, expNo);

end