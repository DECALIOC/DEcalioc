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

function writeParams(model, matr, folderName)
  % INFO
  % writes the parameters of the current run into the folder where the 
  % simulation results will be stored
  %
  % args:
  %   - model: model name as string
  %   - matr:  vector with parameters of current run
  %            columns: parameters  +  end-1: ExPlan row number  +  end: model nr.
  %   - folderName: name of the folder
  % returns:
  %   none
  
  global path;
  
  % write params into csv-file
  csvwrite([path, 'optim/', model, '/', folderName, '/params.csv'], matr(1:end-2));
  
  % write experimental plan number into txt-file
  if matr(end-1) != 0
    fd = fopen([path, 'optim/', model, '/', folderName, '/ExPlan.txt'], "a");
    fdisp(fd, matr(end-1));
    fclose(fd);
  endif

endfunction