function simData = simDataFromHead(model, folderName)
  
  % simDataFromHead.m
  %
  % Function to obtain simulation settings from data.head.
  %
  %
  % Tim Churchfield
  %
  % Last edited: 23/10/2019
  
  
  
  global path;
  
  % open data.head
%  fd = fopen([path, 'optim/', model, '/', folderName, '/data.head'], 'r');
  fd = fopen('/data/home/church70/GitHub/DEcalioc/DEcalioc/DEMmodels/Lift100/data.head','r');
%  fd = fopen('M:\fwdf\members\church70\GitHub\DEcalioc\DEcalioc\DEMmodels\Lift100\data.head','r');
  
  str = fgets(fd);   
  % Walltime
  while ~startsWith(str,'variable walltime')
      str = fgets(fd);
  end
  walltime = sscanf(str,'variable walltime string "%s');
  walltime = walltime(1:end-1);

  % Processors
  frewind(fd); % Reset read position in data.head
  while ~startsWith(str,'variable proc ')
      str = fgets(fd);
  end
  processors = sscanf(str,'variable proc equal %d');

  % Queue
  frewind(fd); % Reset read position in data.head
  while ~startsWith(str,'variable queue ')
      str = fgets(fd);
  end
  queue = sscanf(str,'variable queue string "%s');
  queue = queue(1:end-1);

  % Nodes
  frewind(fd); % Reset read position in data.head
  while ~startsWith(str,'variable nodes ')
      str = fgets(fd);
  end
  nodes = sscanf(str,'variable nodes equal %d');

  mpiProc = processors*nodes;
  
  % Record simulation settings
  simData = {walltime; processors; queue; nodes; mpiProc};

  % Close data.head
  fclose(fd);

endfunction