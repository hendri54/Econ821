function figFn = fig_fn_olg2s(figName, calNo, expNo)

cS = const_olg2s(calNo);

figFn = fullfile(cS.outDir, [figName, sprintf('_c%03i_x%03i', calNo, expNo)]);

end