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

function number = getLastFoldersNumber(path, model)
  % INFO
  % Returns the series of digits of the lastFoldersName
  % 
  % args:
  %   - path: absolute path of working directory
  %   - model: model name as string
  % returns:
  %   - number: number found in lastFoldersName
  
  lastFoldersName = getLastFoldersName(path,model);
  
  if(isempty(lastFoldersName) == true)
    % folder is empty
    number = 0;
  else
    number = str2num(substr(lastFoldersName,1,4));
    if (number > 9000)
      number = 0;
      disp('WARNING: foldersNumber over 9000!')
    endif
  endif
  
endfunction