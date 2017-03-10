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

function writeHead(model, modelVars, folderName)
  % INFO
  % Writes the model values and the parameters which shall be used for the 
  % simulation at the end of the corresponding data.head-file
  %
  % args:
  %   - model: model name
  %   - modelVars: scalar structure with model variables
  %   - folderName: number of the run to be performed
  % returns: 
  %   none
  
  global path;
  
  % open data.head
  fd = fopen([path, 'optim/', model, '/', folderName, '/data.head'], "a");
  
  % append modelVars to data.head 
  fdisp(fd, '');
  
  fields = fieldnames(modelVars);
  for i = 1:length(fields)
    newline = ['variable ', fields{i}, ' equal ', num2str(modelVars.(fields{i}))];
    fdisp(fd, newline);
  endfor
  
  % close data.head
  fclose(fd);
  
endfunction