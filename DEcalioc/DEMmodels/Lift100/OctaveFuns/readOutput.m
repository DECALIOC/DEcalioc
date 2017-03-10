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

function [bd, mr]=readOutput(model, folderName)
  % INFO
  % Reads the bulk density from the corresponding results file
  % 
  % args:
  %   - model: model's name
  %   - folderName: name of the folder where the corresponding results file is stored
  % returns:
  %   - bd: bulk density
  
  global path;
  
  bd = csvread([path, 'optim/', model, '/', folderName, '/output_density']);
  
  mr = csvread([path, 'optim/', model, '/', folderName, '/output_mass']);
  
endfunction
