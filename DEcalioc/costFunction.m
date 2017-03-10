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

function residual = costFunction(params, evaluateFunc, varargin)
  % INFO
  % Computes the value of the cost function
  % args:
  %   - params: row vector with parameters
  %   - evaluateFunc: function handle to evaluate the current model
  %                   NOTE: it should return results in (:,1)
  %   - optional: additional arguments used in evaluateFunc
  % returns:
  %   - residual: evaluated cost function
  %               NOTE: length(residual) > 1 must be true
  
  % evaluate given model with current parameters
  result = evaluateFunc(params, varargin);
  
  % load input and assign params to modelVars (which also updates modelVars.RLTS)
  [~, optim, modelVars, assign, paramLims] = loadInput();
  modelVars = assignParams(modelVars, params, assign);
  
  % calculate min/max Rayleigh time step (RLTS.min and RLTS.max)
  RLTS = getMinMaxRayleigh(modelVars);
  
  
  %*****************************************************************************
  %//	input - COST FUNCTION
  %*****************************************************************************
  % first part:
  %  - scaled difference of current iteration's results and the specified target values
  residual = (result(:,1) - optim.targetVal) ./ optim.targetVal;
  
  % second part:
  %  - weighted and scaled Rayleigh time step of the current iteration
  residual(end+1) = optim.WRL * ((RLTS.max - modelVars.RLTS) / (RLTS.max - RLTS.min));
  
endfunction