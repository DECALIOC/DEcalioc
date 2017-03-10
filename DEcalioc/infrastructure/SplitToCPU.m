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

function [numProc, runs_p_CPU, remainder]  = SplitToCPU(maxCPU, nRuns, nCPU_run)
  % INFO
  % Splits the experimental plan (number of runs, nRuns) according to the maximum
  % number of CPUs of the PC (maxCPU) and the ideal number of CPUs for the DEM model (nCPU_run)
  %
  % args:
  %   - maxCPU: maximum number of CPUs which should be used in total
  %   - nRuns: total number of runs
  %   - nCPU_run: number of CPUs per run
  % returns:
  %   - numProc: maximum number of parallel DEM processes
  %   - runs_p_CPU: number of runs per CPU
  %   - remainder: number of remaining runs
  
  % maximum number of parallel DEM processes
  numProc = fix(maxCPU/nCPU_run);
  if numProc > nRuns
    numProc = nRuns;
  endif
  
  % split experimental plan to the maximum number of parallel DEM runs
  runs_p_CPU = fix(nRuns/numProc);
  % Are any runs of the experimental plan remaining?
  remainder = rem(nRuns,numProc);
  
  % sanity check: Are all items of the experimental plan considered?
  check = numProc * runs_p_CPU + remainder;
  if (check != nRuns)
    % this warning should never occur
    disp('WARNING: Some runs of the experimental plan might not be computed with the DEM model.')
    disp('Check the configuration of number of available CPUs and the CPUs per DEM model')
    disp('The above warning message was generated from the function SplitToCPU.')
  end
  
endfunction