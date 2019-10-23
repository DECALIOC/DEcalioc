function writeJob(model, folderName) 
  
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
  
  path = 'path';
  model = 'model';
  folderName='test';

  %% Read proc, walltime info from data.head
  simData = simDataFromHead(model, folderName);
  
  walltime   = simData{1,1};
  processors = simData{2,1};
  queue      = simData{3,1};
  nodes      = simData{4,1};
  mpiProc    = simData{5,1};
  
  % open job.sh
%  fd = fopen([path, 'optim/', model, '/', folderName, '/job.sh'], 'r');
  fd = fopen('/data/home/church70/GitHub/DEcalioc/DEcalioc/DEMmodels/Lift100/job.sh','r');
%  fd = fopen('M:\fwdf\members\church70\GitHub\DEcalioc\DEcalioc\DEMmodels\Lift100\job.sh','r');

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
  A{5} = strrep(A{5},'DEM',folderName);
  
  % Change path (line 8)
  A{8} = strrep(A{8},'path',[path, 'optim/', model, '/', folderName]);
  
  % Write cell A into job.sh 
%  fd = fopen([path, 'optim/', model, '/', folderName, '/job.sh'], 'w'); 
  fd = fopen('/data/home/church70/GitHub/DEcalioc/DEcalioc/DEMmodels/Lift100/job.sh','w');
%  fd = fopen('M:\fwdf\members\church70\GitHub\DEcalioc\DEcalioc\DEMmodels\Lift100\job.sh','w');

  for i = 1:numel(A)
      if A{i+1} == -1
          fprintf(fd,'%s', A{i});
          break
      else
          fprintf(fd,'%s\n', A{i});
      end
  end
  
  % Close job.sh
  fclose(fd);
  
endfunction