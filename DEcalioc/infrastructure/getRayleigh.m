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

function dtr = getRayleigh(r, rho, YM, nu)
  % INFO
  % Caluclates the Rayleigh-time dt_R. Returns ZERO if calculation fails.
  % Has to be multiplied by 0.1 ... 0.3 to get the Rayleigh-time-step. 
  %
  % args:
  %   - r: particle radius
  %   - rho: density
  %   - YM: Young's modulus (particle)
  %   - nu: Poisson's ratio (particle)
  % returns:
  %   - dtr: Rayleigh-time (not time-step, i.e. w/o mutiplication of 0.25)
  
  SM = YM ./ (2*(1+nu));
  A = sqrt(rho./SM);
  B = 1./(0.1631*nu + 0.8766);
  dtr = pi .* r .* A .* B;
  
endfunction
