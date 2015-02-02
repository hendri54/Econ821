function copy_shared_821(dirV, nameV, overWrite)
% copy shared routines to the econ821 project
%{
IN
   dirV
      list of dirs to be copied entirely
      or: empty (skip copying dirs)
      or: 'all' (copy all dirs)
   nameV
      list of files to be copied
      or: empty
      or: 'all'

Change
   make into a general function
   only the target base dir is project specific
%}
% -----------------------------------------

if nargin ~= 3
   error('Invalid nargin');
end

global lhS
cS = const_821;
sourceBaseDir = lhS.sharedDir;
tgBaseDir = cS.sharedDir;


%% Copy entire directories
if ~isempty(dirV)
%    if ischar(dirV)
%       % Copy all
%       dirV = {'+export_fig', '+multistart_lh', '+preamble_lh', '+struct_lh'};
%    end
      
   for i1 = 1 : length(dirV)
      srcDir = fullfile(sourceBaseDir, dirV{i1});
      tgDir  = fullfile(tgBaseDir,  dirV{i1});
      if ~exist(srcDir, 'dir')
         error('Src dir does not exist');
      end
      fprintf('Copying  %s    to    %s \n', srcDir, tgDir);
      copyfile(srcDir, tgDir);
   end
end



%% Copy individual files
if ~isempty(nameV)
   if ischar(nameV)
      nameV = {'+distrib_lh/cdf_weighted', '+distrib_lh/pcnt_weighted',  '+distrib_lh/gini_weighted',  ...
         '+distrib_lh/norm_grid',  '+distrib_lh/norm_grid_lh',  '+distrib_lh/truncated_normal',  ...
         '+figures_lh/new', ...
         '+markov_lh/markov_sim', '+markov_lh/markov_stationary', ...
         '+matrix_lh/is_monotonic', ...
         '+random_lh/rand_discrete', ...
         '+stats_lh/std_w', ...
         '+t_distrib_lh/t_pcnt_weighted', '+t_distrib_lh/t_norm_grid_lh', ...
         '+t_matrix_lh/t_is_monotonic', ...
         '+t_random_lh/t_rand_discrete', ...
         'integ1', ...
         };
   end

   for i1 = 1 : length(nameV)
      nameStr = [nameV{i1}, '.m'];
      disp(['Copying  ',  nameStr]);

      srcPath = fullfile(sourceBaseDir, nameStr);
      tgPath  = fullfile(tgBaseDir, nameStr);

      if exist(srcPath, 'file')
         % Check that tg dir exists
         tgDir1 = fileparts(tgPath);
         if exist(tgDir1, 'dir')
            files_lh.filecopy1(srcPath, tgPath, overWrite);
         else
            warning('Target dir does not exist\n  %s', tgDir1);
         end
      else
         warning('Cannot copy %s \nFile does not exist.', srcPath);
      end
   end
end

end