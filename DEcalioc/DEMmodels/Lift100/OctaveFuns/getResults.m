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

function res = getResults(model, folderName)
  % INFO
  % Calculate the angle of repsonse and the bulk density based on the results
  % of the DEM-Simulation.
  % Returns NaN if calculation throws an error.
  %
  % args:
  %   - model: model's name
  %   - folderName: name of the folder where the simulation output has been written
  %                 i.e. the simulation has been run
  % returns:
  %   - results: scalar structure containg angle of response (1) and bulk density (2)
  
  % bulk density and remaining mass
  try
    [bd, mr] = readOutput(model, folderName);
    res{1} = bd;
    res{2} = mr;
  catch
    res{1} = NaN;
    res{2} = NaN;
  end
  
endfunction
