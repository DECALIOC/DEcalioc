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

function modelVars = assignParams(modelVars, paramVars, assign)
  % INFO
  % Assigns/updates adjustable model variables in modelVars according to 
  % variables specified in paramVars
  % 
  % args:
  %   - modelVars: scalar structure with "old" model variables
  %   - paramVars: row vector with to be updated/assigned model variables
  %   - assign: scalar structure for correct assignment of the parameters
  % returns:
  %   - modelVars: updated modelVars
  
  % assign parameters
  for i=1:length(assign)
    modelVars.(assign{i}) = paramVars(i);
  endfor
  
  % update Rayleigh time step
  modelVars.RLTS = getRayleigh(
    modelVars.radiusP,
    modelVars.densityP,
    modelVars.youngsModulusP,
    modelVars.poissonsRatioP);
  modelVars.SIMTS = modelVars.RLTS * modelVars.percentRayleigh;
  
endfunction