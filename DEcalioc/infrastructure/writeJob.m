%function [] = writeJob() 
  
  % writeJob.m
  %
  % Function to read in the bash script job.sh and edit the required sections to
  % successfully submit a LIGGGHTS simulation as a separate job to the cluster.
  %
  %
  % Tim Churchfield
  %
  % Last edited: 23/10/2019
  
  
  global path;
  model =1;
  newFolderName=2;
  %% Read proc, walltime info from data.head
  simData = simDataFromHead(model, newFolderName);
  
  simData = {walltime; processors; queue; nodes; mpiProc};
  
  walltime   = simData{1,1};
  processors = simData{2,1};
  queue      = simData{3,1};
  nodes      = simData{4,1};
  mpiProc    = simData{5,1};
  
  % open job.sh
%  fd = fopen([path, 'optim/', model, '/', folderName, '/job.sh'], 'r');
  
  fd = fopen('M:\fwdf\members\church70\MATLAB_Integration\start\job.sh','r');
  
  % Read job.sh into cell A
  i = 1;
  tline = fgetl(fd);
  A{i} = tline;
  while ischar(tline)
    i = i+1;
    tline = fgetl(fd);
    A{i} = tline;
  end
  
  % Close job.sh
  fclose(fd);
  
  % Change walltime (line 4)
  A{4} = strrep(A{4},'walltime=00:00:00',['walltime=',walltime]);
  
  % Change processors (lines 4, 10)
  A{4} = strrep(A{4},'ppn=0',['ppn=',num2str(processors)]);
  A{10} = strrep(A{10},'-np 0',['-np ',num2str(mpiProc)]);
  
  % Change queue (line 2)
  A{2} = strrep(A{2},'-q default',['-q ',queue]);
  
  % Change nodes (line 4)
  A{4} = strrep(A{4},'nodes=1',['nodes=',num2str(nodes)]);
  
  % Change job name (line 5)
  
  % Change path (line 8)
  


%  % Set qsub submission name to project name
%  string5 = cellstr(['sed -i ''s/DEM/' projectname '/'' job.script']);
%
%
%  % Set path to simulation directory
%  string8 = cellstr(['sed -i ''s/cd path/cd ' replace(path_hypnos_sim,...
%      '/','\/') projectname '\//'' job.script']);

  % Write cell A into job.sh 
  %  fd = fopen([path, 'optim/', model, '/', folderName, '/job.sh'], 'w');
  
  fd = fopen('M:\fwdf\members\church70\MATLAB_Integration\start\job.sh','w');
  fid = fopen('test2.txt', 'w');
  for i = 1:numel(A)
      if A{i+1} == -1
          fprintf(fid,'%s', A{i});
          break
      else
          fprintf(fid,'%s\n', A{i});
      end
  end
  
  fclose(fd)
  



  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  % close job.sh 
%  fclose(fd);
  
%%  % open data.head
%%  fd = fopen([path, 'optim/', model, '/', folderName, '/data.head'], "a");
%  
%  % append modelVars to data.head 
%  fdisp(fd, '');
%  
%  fields = fieldnames(modelVars);
%  for i = 1:length(fields)
%    newline = ['variable ', fields{i}, ' equal ', num2str(modelVars.(fields{i}))];
%    fdisp(fd, newline);
%  endfor
%  
%  % close data.head
%  fclose(fd);
  
%endfunction