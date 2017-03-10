% This file is part of DEcalioc.
% 
% Main contributor(s) of this file:
% Carolin D. Görnig
% 
% Copyright 2016           Institute for
%                          Materials Handling, Material Flow, Logistics
%                          Technical University of Munich, Germany
% 
% DEcalioc is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, version 3 of the License.
% 
% DEcalioc is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with DEcalioc. If not, see <http://www.gnu.org/licenses/>.
% ----------------------------------------------------------------------

function lastFoldersName = getLastFoldersName(path, model)
  % INFO:
  % Reads the files found at the model's folder, sorts them in ascending order
  % and returns the last file name found.
  % 
  % args:
  %   - path: absolute path of working directory
  %   - model: model name as string
  % returns:
  %   - lastFoldersName
  
  % get content (first two entries are: . and ..)
  folder_content = readdir([path, 'optim/', model]);
  
  % get last folder's name
  if(rows(folder_content) > 2)
    lastFoldersName = folder_content{end};
  else
    % folder is empty
    lastFoldersName = "";
  endif
  
endfunction
