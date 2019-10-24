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

function startSimulation(model,folderName)
  % INFO
  % Starts the simulation through the bash-file "runscript"
  %
  % args:
  %   - model: model name
  %   - folderName: folder in which runscript lies
  % returns:
  %   none
  
  global path;
  
  % change directory and start simulation
  % info: unix(...) waits until the simulation has finished
  chdir([path, 'optim/', model, '/', folderName, '/']);    
%  status= unix(['sh ', path, 'optim/', model, '/', folderName, '/runscript']);
  status = unix(['cd ', path, 'optim/', model, '/', folderName, ';',...
    ' /opt/torque/bin/qsub job.sh']);  
%  status = unix(['cd /data/home/church70/GitHub/DEcalioc/DEcalioc/DEMmodels/Lift100', ';',...
%    ' /opt/torque/bin/qsub job.sh']);


  % Query output.txt file existence
%  status = unix(['cd ', path, 'optim/', model, '/', folderName, ';',...
%    ' test -e ', folderName,'_output.txt && echo 1 || echo 0']);
  command = ['cd ', path, 'optim/', model, '/', folderName, ';',...
    ' test -e ', folderName,'_output.txt && echo 1 || echo 0'];
  j = [];
  while isempty(j)
    [~,cmd_out] = system(command);
    if str2double(cmd_out) == 1
      j = 1;
      disp('Log file found...');
      break
    end
    pause(60);
  end
   

  chdir(path);
  
endfunction
