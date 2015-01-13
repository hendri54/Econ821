function [fPath, fn] = cal_fn_olg2d(calNo, dbg);
% File name for parameter file
% ----------------------------------------------

matDir = const_olg2d('matDir', dbg);
fn = sprintf('cal%03i.mat', calNo);
fPath = [matDir, fn];

% **** eof ****
