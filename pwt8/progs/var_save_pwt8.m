function var_save_pwt8(saveS, varNo)

[fPath, fn] = var_fn_pwt8(varNo);
save(fPath,  'saveS');
fprintf('Saved variable %s \n',  fn);

end