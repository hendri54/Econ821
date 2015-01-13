function var_save_wdi821(saveS, varNo)

validateattributes(varNo, {'numeric'}, {'finite', 'nonnan', 'nonempty', 'integer', ...
   'positive', '<', 999, 'size', [1,1]})

save(var_fn_wdi821(varNo), 'saveS');

end