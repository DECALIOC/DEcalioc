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

function name = newFolderName(num)
  % INFO
  % Creates a name for a new folder according to the passed number.
  % The structure is: XXXXyyyy_XXXXX with X being digits and y being random letters (a-z)
  %
  % args:
  %   - num: number of the folder
  % returns:
  %   - name: folder's name
  
  % generate four digit number based on the passed argument
  len = length(num2str(num));
  switch len
    case 1
      number = ['000',num2str(num)];
    case 2
      number = ['00',num2str(num)];
    case 3
      number = ['0', num2str(num)];
    case 4
      number = num2str(num);
  endswitch
  
  % add 3 random letters (a-z)
  letters = char([randi(26)+96, randi(26)+96, randi(26)+96]);
  
  % add processorID and return
  name = [number, letters, '_', num2str(getpid())];
  
endfunction
