% This file is part of DEcalioc.
% 
% Main contributor(s) of this file:
% Christopher Jelich
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

function folderName = getOptimFolder(optimParams)
  % INFO
  % returns the name of the folder in which the simulation results of the 
  % optimal parameter run lies
  % args:
  %   - optimParams: row vector with optimal parameter set
  % returns:
  %   - folderName: struct with names of the folder in which the corresponding optim run solution lies
  
  global path;
  
  [Input, ~, ~, ~, ~] = loadInput();
  
  for k = 1:max(size(Input.model))
    % read folder content
    folder_content = readdir([path, 'optim/', Input.model{k}]);
    
    % set default value
    folderName{k} = NaN;
    
    for j = 3:max(size(folder_content))
      % read csv with params
      params = csvread([path, 'optim/', Input.model{k}, '/', folder_content{j}, '/params.csv'])';
      % check params
      if abs(optimParams - params) <= (eps(params) + eps(optimParams))
        folderName{k} = folder_content{j};
        break;
      endif
    endfor
    
  endfor
  
endfunction