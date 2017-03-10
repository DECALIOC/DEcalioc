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

function [results] = evaluateKriging(params, varargin)
  % INFO
  % Evaluates the Krigingfunctions
  % 
  % args:
  %   - params: row vector containing the parameters for evaluating the model
  %   - optional: additional arguments used for evaluation
  %               NOTE: you have to pass "KrigingFunNames" as the first optional
  %                     variable!
  %                     We just use varargin here because this function gets 
  %                     further wrapped...
  % returns:
  %   - results: results gained by evaluating the Kriging model
  %              (:,1) = kriging predictor
  %              (:,2) = kriging variance
  
  global path;
  
  % check varargin
  if nargin() > 2
    disp("WARNING: to many arguments passed into evaluateKriging()!!!");
  elseif nargin() == 2
    KrigingFunNames = varargin{1}{:};
  endif
  
  % add directory with Kriging functions
  addpath([path 'KrigingFuns/']);
  warning('off','Octave:data-file-in-path');
  
  for i = 1:rows(KrigingFunNames)
    evalFunc = str2func(KrigingFunNames{i,1});
    resultsKriging = evalFunc(params');
    results(i,1) = resultsKriging.mean;
    %results(i,2) = resultsKriging.var;
  end
  
  % remove directory with Kriging functions
  rmpath([path 'KrigingFuns/']);
  warning('on','Octave:data-file-in-path');
  
endfunction