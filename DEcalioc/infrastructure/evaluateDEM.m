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

function [results] = evaluateDEM(params, varargin)
  % INFO
  % Evaluates the Krigingfunctions
  % 
  % args:
  %   - params: row vector containing the parameters for evaluating the model
  %   - optional: additional arguments used for evaluation 
  %               NOTE: no additional arguments used here!
  % returns:
  %   - results: results gained by evaluating the DEM-model
  
  global path;
  
  % check varargin
  if (nargin() > 1) && !(isempty(varargin{:}))
    disp("WARNING in evaluateDEM(): to many arguments passed into evaluateDEM()!");
  endif
  
  % load input
  [Input, ~, ~, ~, ~] = loadInput();
  
  % generate cell struct with runs
  for i = 1:max(size(Input.model))    
    % evalRuns, same structure as 'runs' in Script.m
    % rows: runs
    % columns: parameters  +  end-1: ExPlan row nr (here: =0)  +  end: model nr.
    evalRuns{i} = [params', 0, i];
  endfor
  
  % create anonymous function to pass additional arguments when using parcellfun()
  anonym_Start = @(evalRuns)Start(evalRuns, Input.model);
  
  % determine number of cpus to be used and start simulation
  if ((Input.maxCPU - sum(Input.cpu)) > 0)
    % enough free cpus
    n_cpu = Input.maxCPU;
    % perform runs
    results = parcellfun(n_cpu, anonym_Start, evalRuns, 'VerboseLevel', 0);
  else
    % not enough free cpus
    results = cellfun(anonym_Start, evalRuns);
  endif
  
  % reshape 'results'-matrix into row vector
  % 1 3 5   =>  (1 2 3 4 5 6)'
  % 2 4 6
  results = reshape(results, numel(results), 1);
  
endfunction  