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

function [this_procs_res] = Start(matr, model)
  % INFO
  % Starts DEM-Simulations of 'model' using the parameter sets sepecified in 'matr'.
  % 
  % args:
  %   - matr: matrix with parameters
  %           rows: runs
  %           columns: parameters  +  end-1: ExPlan row number  +  end: model nr.
  %   - model: cell struct with model names
  % returns:
  %   - this_procs_res: matrix with results
  %                     rows: results 
  %                     columns: this processor's runs
  
  % preallocate results matrix
  this_procs_res(1,1:rows(matr))=0;
  
  % loop over runs_p_CPU
  for i = 1:rows(matr)
    
    % start i-th run and store result
    res = runScript(matr(i,:), model{matr(i,end)});
    
    % save results
    for j = 1:length(res)
      this_procs_res(j,i) = res{j};
    endfor
  endfor
  
endfunction