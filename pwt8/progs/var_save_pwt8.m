function var_save_pwt8(saveS, varNo, cS)

[fPath, fn, fDir] = var_fn_pwt8(varNo, cS);

if exist(fDir, 'dir') <= 0
   filesLH.mkdir(fDir, cS.dbg);
end

save(fPath,  'saveS');
fprintf('Saved variable %s \n',  fn);

end