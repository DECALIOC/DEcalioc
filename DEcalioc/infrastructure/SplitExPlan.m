% This file is part of DEcalioc.
% 
% Main contributor(s) of this file:
% Michael Rackl
% 
% Copyright 2015           Institute for
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

function [runs_main, runs_rest] = SplitExPlan(ExPlan, nProc, runs_p_CPU, remainder)
  % INFO
  % Splits the experimental plan according to the data from function SplitToCPU
  %
  % args:
  %   - ExPlan: experimental plan
  %   - nProc: number of processes to run in parallel (integer)
  %   - runs_p_CPU: experiments per parallel process
  %   - remainder: remainder of the experimental plan
  % returns:
  %   - runs_main: main parallelization
  %   - runs_rest: parallelization for the remainder of the runs
  % 
  % OUTPUT for an example with a max. of three parallel processes and a rest of two
  % runs_main: main parallelization
  % [ 1 - 12]
  % [13 - 24]
  % [25 - 36]
  %
  % runs_rest: parallelization for the remainder of the runs
  % [37]
  % [38]
  
  
  % split the main part of the experimental plan, excluding the remainder  
  g = 1;
  for i = 1:runs_p_CPU:(nProc*runs_p_CPU);
    idx1 = i;
    idx2 = i + runs_p_CPU-1;
    tmp(1:runs_p_CPU, :) = ExPlan(idx1:idx2, :);
    tmp(1:runs_p_CPU, columns(tmp(1,:))+1) = [idx1:idx2]'; % index for folder generation
    runs_main{g} = tmp;
    g = g+1;
    tmp = [];
  endfor
  
  % divide the remainder of the experimental plan to processes
  g = 1;
  for k = (idx2+1):rows(ExPlan)
    tmp(1, :) = ExPlan(k,:);
    tmp(1, max(size(tmp(1,:)))+1) = [k]'; % index for folder generation
    runs_rest{g} = tmp;
    g = g+1;
    tmp = [];
  endfor
  
  % no remainder equals no runs_rest
  if(remainder == 0)
    runs_rest=[];
  endif;

endfunction