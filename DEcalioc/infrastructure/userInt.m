% This file is part of DEcalioc.
% 
% Main contributor(s) of this file:
% Michael Rackl
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

function [stop, info] = userInt(p, vals, state, DEMflag)
  % INFO
  % Display information in the console during the second optimization step
  % requires setting: optimset('user_interaction',@UserInt);
  %
  % args:
  %   - p:       current parameter set
  %   - vals:    structure containing additional values
  %              -> vals.iteration: current iteration count
  %              -> vals.residual:  residuals of last iteration
  %   - state:   specifies current optimization state: init, iter or done
  %   - DEMflag: flag specifying if this user_interaction-function is called 
  %              within the Kringing-model-based-optimization (DEMflag = false)
  %              or within the DEM-model-based-optimization (DEMflag = true)
  %    
  % returns:
  %   - stop:    flag indicating if optimization should be stopped
  %   - info:    additional string with information about the reason for stopping
  %              Note: info must be defined (e.g. info = [])
  
  % check for additional residuals
  [~, optim, ~, ~, ~] = loadInput();
  if rows(optim.targetVal) < rows(vals.residual)
    % get rid of weighting factors
    if optim.WRL != 0
      vals.residual(end) = vals.residual(end) / optim.WRL;
    else
      vals.residual(end) = 0;
    endif
  endif
  
  % multiply residuals by 100 and round off
  vals.residual = round(vals.residual * 10000) / 100;
  
  if (strcmp(state, 'init'))
    % init state
    if (DEMflag == false)
      disp('##########################################################');
      disp('###             Optimization - init (Kriging)          ###');
      disp('##########################################################');
    else
      disp('##########################################################');
      disp('###             Optimization - init (DEM-model)        ###');
      disp('##########################################################');
    endif
    disp('Iteration no.: 0');
    disp('  Residuals');
    for i = 1:rows(vals.residual)
      disp(['     ', num2str(vals.residual(i,:))]);
    endfor

  elseif (strcmp(state, 'iter'))
    % iter state
    disp(['Iteration no.: ', num2str(vals.iteration)]);
    disp('  Residuals:');
    for i = 1:rows(vals.residual)
      disp(['     ', num2str(vals.residual(i,:))]);
    endfor
  
  elseif (strcmp(state, 'done'))
    % done state
    info = ['Tolerance limits specified in optimset have been met!'];
    % write "Optimization - done" output
    optimDone(p, vals, info);
  endif
  
  if (DEMflag == true)
  % check stopping criteria
    if sum(abs(vals.residual(1:length(optim.tolRes))/100) > optim.tolRes(:))
      % at least one residual is still above the specified tolerance limit
      % check iteration count...
      if vals.iteration > optim.maxIter
        stop = true;
        info = ['Maximum number of iterations exceeded!'];
        % write "Optimization - done" output
        optimDone(p, vals, info);
      else
        stop = false;
        info = [];
      endif
    else
      % all residuals are below their specified tolerance limit
      stop = true;
      info = ['Specified tolerance limits of the residuals have been met!'];
      % write "Optimization - done" output
      optimDone(p, vals, info);
    endif
  else
    stop = false;
    info = [];
  endif
  
endfunction

function optimDone(p, vals, info)
  % INFO
  % writes "Optimization - done" output
  %
  % args:
  %   - p:       current parameter set
  %   - vals:    structure containing additional values
  %              -> vals.iteration: current iteration count
  %              -> vals.residual:  residuals of last iteration
  %   - info:    additional string with information about the reason for stopping
  % returns:
  %   none
  
  % load input
  [~, optim, modelVars, ~, ~] = loadInput();
  RLTS = getMinMaxRayleigh(modelVars);
  
  disp('##########################################################');
  disp('###             Optimization - done                    ###');
  disp('##########################################################');
  disp('Residuals:');
  for i = 1:rows(vals.residual)
    disp(['     ', num2str(vals.residual(i,:))]);
  endfor
  
  disp('Simulation results:');
  for i = 1:rows(optim.targetVal)
    disp(['     ', num2str( (vals.residual(i,:)/100+1) * optim.targetVal(i) )]);
  endfor
  disp(['     ', num2str( RLTS.max - (vals.residual(end)/100 * (RLTS.max - RLTS.min)) )]);
  
  disp('Parameter:');
  for i = 1:rows(p)
    disp(['     ', num2str(p(i,:))]);
  endfor
  
  disp('Reason for stopping:');
  disp(['  ', info]);
endfunction
