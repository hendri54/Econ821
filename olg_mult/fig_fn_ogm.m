function figFn = fig_fn_ogm(figName, calNo, expNo)

cS = const_ogm(calNo);

figFn = fullfile(cS.outDir, [figName, sprintf('_c%03i_x%03i', calNo, expNo)]);

end