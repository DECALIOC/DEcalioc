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

function [RLTS] = getMinMaxRayleigh(modelVars)
  % INFO
  % calculates min/max values of Rayleigh time for given paramter space
  %   -> minimal if:   radius, rho, nu -> min   &&   Young's modulus -> max
  % 
  % args:
  %   - modelVars: scalar structure with the current model variables
  %
  % returns:
  %   - RLTS: struct containg min/max values of Rayleigh time step
  %           content: RLTS.min, RLTS.max
  
  [~, ~, modelVars, assign, paramLims] = loadInput();
  
  if (sum(strcmp(assign,'radiusP')))
    radiusP_minmax = paramLims(:,strcmp(assign,"radiusP"));
  else
    radiusP_minmax = ones(2,1) * modelVars.radiusP;
  endif
  
  if (sum(strcmp(assign,'densityP')))
    rhoP_minmax = paramLims(:,strcmp(assign,"densityP"));
  else
    rhoP_minmax = ones(2,1) * modelVars.densityP;
  endif
  
  if (sum(strcmp(assign,'youngsModulusP')))
    YM_minmax = flip(paramLims(:,strcmp(assign,"youngsModulusP")));
  else
    YM_minmax = ones(2,1) * modelVars.youngsModulusP;
  endif
  
  if (sum(strcmp(assign,'poissonsRatioP')))
    nuP_minmax = paramLims(:,strcmp(assign,"poissonsRatioP"));
  else
    nuP_minmax = ones(2,1) * modelVars.poissonsRatioP;
  endif
  
  tmp = getRayleigh(
    radiusP_minmax,
    rhoP_minmax,
    YM_minmax,
    nuP_minmax);
  
  RLTS.min = tmp(1);
  RLTS.max = tmp(2);
  
endfunction