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

function results = runScript(matr, model)
  % INFO
  % Creates folder for DEM-Simulation, writes the model variables into data.head,
  % starts the simulation and waits for the simulation to be finished.
  %
  % args:
  %   - matr: vector with parameters of current run
  %           columns: parameters  +  end-1: ExPlan row number  +  end: model nr.
  %   - model: model name as string
  % returns:
  %   - results: cell structure with results (1: angle of response, 2: bulk density)
  
  global path;
  
  %*****************************************************************************
  %//	PREPARE MODELS
  %*****************************************************************************
  % load modelVars and assignment matrix
  [~, ~, modelVars, assign, ~] = loadInput();
  
  % assign parameters to modelVars
  modelVars = assignParams(modelVars, matr(1:end-2), assign);
  
  % create a new folder inside "path/optim/'model'" for this run
  folderNumber = getLastFoldersNumber(path, model);
  newFolderName = newFolderName(folderNumber + 1);
  if (createNewFolder(model, newFolderName) == 1)
    disp([ctime(time()), ' New folder ', newFolderName, ' created!']);
  else
    disp(['ERROR in runScript(): Could not create the folder ', newFolderName, ' !']);
  endif
  
  % write model variables into corresponding data.head
  writeHead(model, modelVars, newFolderName);
  
  % write parameters into csv-file
  writeParams(model, matr, newFolderName);
    
  % write simulation settings into job.sh 
  writeJob(model, newFolderName);
  
  %*****************************************************************************
  %//	START SIMULATION
  %*****************************************************************************
  try
    startSimulation(model, newFolderName);
  catch
    disp(["Unable to run ", newFolderName, " - ", model]);
    disp("Skipping to next file");
  end
  
  %*****************************************************************************
  %//	PROCESS RESULTS
  %*****************************************************************************
  % calculate results based on DEM-Simulation (these are used in the cost function)
  addpath([path, 'DEMmodels/', model, '/OctaveFuns']);
  results = getResults(model, newFolderName);
  rmpath([path, 'DEMmodels/', model, '/OctaveFuns']);
  
endfunction
