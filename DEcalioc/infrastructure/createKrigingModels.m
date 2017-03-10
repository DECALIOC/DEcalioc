% This file is part of DEcalioc.
% 
% Main contributor(s) of this file:
% Michael Rackl
% 
% Copyright 2015           Institute for
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

function [KrigingFunNames,varargout] = createKrigingModels(ExPlanFiles,RespFiles,ParamLims,varargin)
  % INFO:
  % Sets up the Kriging models from given experimental plans and responses
  %
  % args:
  %   - ExPlanFiles: row cell vector with names of .csv files containing the Lhs plans
  %                  line 1:     Factor 1    Factor 2    Factor N
  %                  line 2:     Factor 1    Factor 2    Factor N
  %                  line K:     Factor 1    Factor 2    Factor N
  %   - respFiles: row cell vector with names of .csv files with the measured response
  %                Response 1
  %                Response 2
  %                Response K
  %   - ParamLims: upper and lower limits for the factors
  %                       Factor1     Factor2     FactorN
  %                [     lowerLim    lowerLim    lowerLim    ]
  %                [     upperLim    upperLim    upperLim    ]
  %   - optional (4): specify the model's trend; 1--> linear, 2--> quadratic
  %                   default setting is 1
  %   - optional (5): specify the covariance function to use (string);
  %                   default setting is 'stk_materncov_aniso'; 
  %                   see stk toolbox documentation for help on this argument
  % returns:
  %   - KrigingFunNames: two colum cell with the names and relative path the the source
  %                      files of the Kriging models
  %   - varargout (optional): path to the directory of the function files
  %
  % NOTE:
  %     This function requires stk toolbox, however this function is supposed 
  %     to be called by a function, which already loaded package stk; 
  %     see command in the line below
  %     pkg load stk;
  
  global path;
  
  %###########################################################################
  % read experimental plan and responses
  %###########################################################################
  % sanity checks
  for i = 1:length(RespFiles)
  % compare the number of parameters between ParamLims and the LHS plans
    if size(csvread(ExPlanFiles{i}),2)==size(ParamLims,2)
      % everything is fine
    else
      disp(['WARNING: The number of Parameters in ParamLims is ' num2str(size(ParamLims,2)) ...
        ', while it is ' num2str(size(csvread(ExPlanFiles{i}),2)) ' in the LHS plan.']);
      disp('This message was generated from function createKrigingModels.m')
    endif
  % compare the length of the result files with the length of the LHS plans
    if length(csvread(RespFiles{i}))==size(csvread(ExPlanFiles{i}),1)
      % everything is fine
    else
      disp(['WARNING: The result vector for result number ' num2str(i) ' is shorter or longer than the LHS plan.'])
      disp('This indicates that there are missing results.')
      disp('This message was generated from function createKrigingModels.m')
    endif
  endfor
  % sanity checks done
  
  %###########################################################################
  % select a Kriging model
  %###########################################################################
  NoFact = columns(ParamLims);
  if nargin() == 5
    model = stk_model(varargin{2}, NoFact);
    disp(['Kriging model is ' varargin{2}])
  else
    % no optional arguments --> use default model
    % initiate a generic anisotropic Matern covariance function as default
    model = stk_model('stk_materncov_aniso', NoFact);
    disp('Kriging model is stk_materncov_aniso (default)')
  end
  
  %###########################################################################
  % specify if trend is to be used
  %###########################################################################
  if nargin() > 3
    % if at least the model order is specified
    model.order = varargin{1};
    disp(['with trend=' num2str(varargin{1})])
  else
    % no extra arguments
    model.order = 1;  % linear trend as default
    disp('with linear trend.')
    disp(' ')
  end
  
  %###########################################################################
  % delete and recreate function folder
  %###########################################################################
  confirm_recursive_rmdir(0, "local")
  rmdir('KrigingFuns','s');
  mkdir('KrigingFuns');
  
  %###########################################################################
  % Create the Kriging functions
  %###########################################################################
  for i = 1:length(ExPlanFiles)
    ExPlan = csvread(ExPlanFiles{i});
    Resp = csvread(RespFiles{i});
    
    %disp(model)
    %disp(ExPlan)
    %disp(Resp)
    %disp(ParamLims)
    
    % include an estimate for the noise; implicitly switches the Kriging
    % models from interpolation to approximation
    [param_init, model.lognoisevariance] = stk_param_init(model, ExPlan, Resp, ParamLims, true);
    
    % determine the parameters for the Kriging model
    [model.param, model.lognoisevariance] = stk_param_estim(model, ExPlan, Resp, param_init,model.lognoisevariance);
    
    % create the function files
    KrigingFunNames{i,1} = ['KM_fun_' num2str(i)];
    KrigingFunNames{i,2} = RespFiles{i};
    createKrigingFun(KrigingFunNames{i}, model, ExPlan, Resp);
  end
  
  % return directory path, where the functios are saved
  if nargout==2
    varargout{1} = [path, '/KrigingFuns'];
  end
  
endfunction
%###########################################################################
%###########################################################################
%###########################################################################
% FOLLOWING UP IS A SECOND FUNCTION
%###########################################################################
%###########################################################################
%###########################################################################

function [] = createKrigingFun(funName,model,ExPlan,Response)
  % INFO
  % Creates a function and a datafile, which hold all information for the Kriging
  % prediction; funtions will be stored in the folder KrigingFuns
  %
  % args:
  %   - funName: name of the Kriging functions
  %   - model: data structure containing model informations (created by stk_model)
  %   - ExPlan: row cell vector containing the Lhs plans
  %             line 1:     Factor 1    Factor 2    Factor N
  %             line 2:     Factor 1    Factor 2    Factor N
  %             line K:     Factor 1    Factor 2    Factor N
  %   - respFiles: row cell vector containing the measured responses
  %                Response 1
  %                Response 2
  %                Response K
  %
  % NOTE:
  %     This function requires stk toolbox, however this function is supposed 
  %     to be called by a function, which already loaded package stk; 
  %     see command in the line below
  %     pkg load stk;
  
  % write Kriging model functions to subfolder KrigingFuns
  % enter subfolder
  krigingFolder = 'KrigingFuns';
  
  % save model parameters, experimental plan and response to subfolder
  modelfilename = [funName '.model'];
  save([krigingFolder, '/', modelfilename], 'model', 'ExPlan', 'Response');
  
  % write Kriging model function
  fid = fopen([krigingFolder, '/', funName '.m'], 'w');
  fprintf(fid,['function y = ' funName '(x)\n']);
  fprintf(fid,'%% this function was automatically generated from a function\n');
  fprintf(fid,'%% called SetUpkrigingModels\n');
  fprintf(fid, ['load ' funName '.model;\n']);
  fprintf(fid, 'y = stk_predict(model, ExPlan, Response, x);\n');
  fprintf(fid, 'endfunction');
  fclose(fid);
  
endfunction
