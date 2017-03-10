% This file is part of DEcalioc.
% 
% Main contributor(s) of this file:
% Michael Rackl
% Carolin D. Görnig
% Christopher Jelich
% 
% Copyright 2017           Institute for
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
%
% Main Script
%

clc;
close all
clear all;
more off;
diary 'Octave_logfile.txt'

tic();

% load necessary packages
pkg load stk
pkg load parallel
pkg load struct
pkg load optim

% set and add paths
global path;
path = [pwd(), "/"];
addpath([path, 'infrastructure']);

% create clean folders
confirm_recursive_rmdir(0);
rmdir([path, 'optim'], 's');
rmdir([path, 'results'], 's');
rmdir([path, 'KrigingFuns'], 's');
confirm_recursive_rmdir(1);
mkdir([path, 'optim']);
mkdir([path, 'results']);
mkdir([path, 'KrigingFuns']);

%***********************************************************************************
%//	INPUT - LOAD SETTINGS
%***********************************************************************************
[Input, optim, ~, ~, paramLims] = loadInput();

%***********************************************************************************
%//	Experimental plan and DEM-simulation
%***********************************************************************************
% generate experimental plan
runs = GenerateExperPlan(paramLims, Input.numOfSam, path);

% perform runs of every 'Input.model' the parameter sets defined in 'runs'
for k = 1:max(size(Input.model))
  % create folder for k-th model
  mkdir([path, 'optim/', Input.model{k}]);
  
  % divide experiment plan according to the parallelization settings
  [numProc, runs_p_CPU, remainder] = SplitToCPU(Input.maxCPU, rows(runs), Input.cpu(k));
  [runs_main, runs_rest] = SplitExPlan(runs, numProc, runs_p_CPU, remainder);
  
  if(remainder!=0)
    runs_all = [runs_main runs_rest];
  else
    runs_all = runs_main;
  endif
  
  % write index of current model at the end of runs_all
  for i = 1:length(runs_all)
    runs_all{i}(:,end+1) = ones(rows(runs_all{i}),1) * k;
  endfor
  
  % create anonymous function to pass additional arguments when using parcellfun()
  anonym_Start = @(runs_all)Start(runs_all, Input.model);
  
  % perform all runs of k-th model
  %   - results_all{1,k} (rows: result variables, cols: runs)
  disp(['Starting DEM-Simulation of ', Input.model{k}]);
  [results_all{k}] = parcellfun(fix(Input.maxCPU/Input.cpu(k)), anonym_Start, runs_all, 'VerboseLevel', 0);
  
  % detect those runs which produced unfeasible results indicated by NaN-values 
  [~, NaN_runs{k}] = find(isnan(results_all{k}));
  
  for i = 1:length(NaN_runs{k})
    disp(["Warning: NaN_runs...", num2str(NaN_runs{k}(i))])
  endfor
  
endfor

% reshape results and experimental plan if NaN_runs occured
%   -> runs with params leading to NaN-values are deleted for EVERY model
%   -> be careful here: columns in results_all do match rows in runs!!
results_DoE = results_all;
runs_DoE = runs;

% get columns of runs which lead to NaN-runs
cols = [];
for k = 1:max(size(Input.model))
  cols = [cols; NaN_runs{k}];
endfor
cols = unique(cols);

% delete runs in experimental plan
runs_DoE(cols,:) = [];
csvwrite([path, "ExperimentalPlan_DoE.csv"], runs_DoE);

% delete runs in results
for k = 1:max(size(Input.model))
  results_DoE{k}(:,cols) = [];
  
  % write results (one .csv-file for each result quantity - saved as row vector)
  for i = 1:rows(results_DoE{k})
    % create folder
    namefile = ["DoE_", Input.model{k}, "_", num2str(i)];
    mkdir([path, "results/", namefile]);
    csvwrite([path, "results/", namefile, "/", namefile, ".csv"], [results_DoE{k}(i,:)]');
    
    % save folder's name for later
    foldername{end+1} = namefile;
  endfor
endfor


%*****************************************************************************
%//   KRIGING-model
%*****************************************************************************

for i = 1:max(size(foldername))
  ExPath{i} = [path, "ExperimentalPlan_DoE.csv"];
  RePath{i} = [path, "results/", foldername{i}, "/", foldername{i}, ".csv"];
endfor

% Sanity check --> are the desired values within the boundaries of
% the responses? Issue warning if not.
for i = 1:length(RePath)
  tmp = csvread(RePath{i});
  if (min(tmp) > optim.targetVal(i) || max(tmp) < optim.targetVal(i))
    disp('WARNING from Kriging optimisation:')
    disp('The desired DEM model result lies outside of the boundaries of the initial DEM results.')
    disp(['Minimum in ' RePath{i} ' is ' num2str(min(tmp)) ', maximum is ' num2str(max(tmp)) ','])
    disp(['but your desired result is ' num2str(optim.targetVal(i))])
  endif
endfor

% create Kriging models in subfolder KrigingFuns
disp('Creating Kriging models...');
KrigingFunNames = createKrigingModels(ExPath, RePath, paramLims);


%*****************************************************************************
%//   OPTIMIZATION using KRIGING-model
%*****************************************************************************

% initial parameters
initParam = mean(paramLims,1)';

% specify user_interaction function
DEMflag = false();
userIntKriging = @(p,vals,state)userInt(p,vals,state,DEMflag);

% optimization settings
settings = optimset('lbound', paramLims(1,:)', 'ubound', paramLims(2,:)',...
                    'FunValCheck','on', 'MaxIter',1000, 'MaxFunEvals',3000,...
                    'Display', 'iter', 'TolFun', optim.tolfun,
                    'user_interaction', userIntKriging,
                    'parallel_local', 0);

% define cost function
costFunc = @(params)costFunction(params, @evaluateKriging, KrigingFunNames);

% optimize
[p, resid, cvg, outp] = nonlin_residmin(costFunc, initParam, settings);

clear initParam settings costFunc;


%*****************************************************************************
%//   OPTIMIZATION using DEM-model
%*****************************************************************************

% initial parameters
initParam = p;

% specify user_interaction function
DEMflag = true();
userIntDEM = @(p,vals,state)userInt(p,vals,state,DEMflag);

% specify number of cpus to be used
optimCPU = fix(Input.maxCPU / sum(Input.cpu));

% optimization settings
settings = optimset('lbound', paramLims(1,:)', 'ubound', paramLims(2,:)',...
                    'FunValCheck','on', 'MaxFunEvals', optim.maxFunEvals,...
                    'Display', 'iter', 'TolFun', optim.tolfun,
                    'user_interaction', userIntDEM,
                    'parallel_local', optimCPU);

% define cost function
costFunc = @(params)costFunction(params, @evaluateDEM);

% optimize
[p_DEM, resid_DEM, cvg_DEM, outp_DEM] = nonlin_residmin(costFunc, initParam, settings);


%*****************************************************************************
%//   DONE
%*****************************************************************************

% Print time
b = toc();

% get folder with results
optimFolderName = getOptimFolder(p_DEM);
disp('Results are stored in:');
for k = 1:max(size(Input.model))
  disp([path, 'optim/', Input.model{k}, '/', optimFolderName{k}]);
endfor

%disp("");
disp(["Finished runs in ", num2str(b/60), " minutes"]);

diary off
