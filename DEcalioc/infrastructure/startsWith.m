% Check if a string starts with a given prefix
% Returns 1 if s starts with prefix, 0 else
% Ref: https://techoverflow.net/2018/11/29/string-startswith-function-in-octave/
function retval = startsWith(s, prefix)
    n = length(prefix);
    if n == 0 # Empty prefix
      retval = 1; # Every string starts with empty prefix
      return
    endif
    retval = strncmp(s, prefix, n);
  endfunction