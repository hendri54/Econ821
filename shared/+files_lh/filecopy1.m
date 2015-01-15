function result = filecopy1(path1, path2, overWrite)
% Copy file path1 -> path2
% ---------------------------------------
% TASK:

% IN:
%  path1, path2   Full paths
%  overWrite      1: overwrite existing path2
%                 0: skip if path2 exists

% OUT:

% AUTHOR: Lutz Hendricks, 1999
% ---------------------------------------

if exist( path2, 'file' ) > 0  &&  overWrite ~= 1
   disp('File already exists. Skipped.');
   result = 1;
else
   result = copyfile( path1, path2 );
end

if result ~= 1
   warnmsg([ mfilename, ':  Copying failed' ]);
   disp(path1)
   disp(path2)
end


end 