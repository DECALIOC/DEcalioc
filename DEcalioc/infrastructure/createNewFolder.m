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

function err = createNewFolder(model, folderName)
  % INFO
  % creates a folder for a new run and copies the original simulation-folder 
  % from DEMmodels/model to optim/model
  %
  % args:
  %   - model: name of the model
  %   - folderName: name of the folder
  % returns:
  %   none
  
  global path;
  
  [err, ~, ~] = copyfile([path, "DEMmodels/", model, "/"], [path, "optim/", model, "/", folderName]);
  
endfunction
