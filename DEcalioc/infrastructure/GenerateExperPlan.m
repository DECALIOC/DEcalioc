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

function ExPlan = GenerateExperPlan(factorLimits,N, pathExPlan)
  % INFO
  % Generates a latin hypercube experimental plan, according to the
  % MAXIMIN design principle
  % 
  % args:
  %   - factorLimits: upper and lower limits of the factors
  %                  [lower_fac1   lower_fac2    lower_faci]
  %                  [upper_fac1   upper_fac2    upper_faci]
  %   - N: number of sample points to be generated
  %   - pathExPlan: absolute path for saving ExperimentalPlan.csv
  
  DIM = columns(factorLimits);
  % generate 5,000 LHS designs per factor to have more designs to choose from
  NITER = 5000*DIM;
  ExPlan = stk_sampling_maximinlhs(N,DIM,factorLimits,NITER);
  % fix compatibility with stk 2.5.0
  ExPlan = struct2cell(ExPlan);
  ExPlan = ExPlan{1,1};
  
  % write experimental plan to csv file
  %csvwrite([pathExPlan,"/ExperimentalPlan.csv"],ExPlan);
  
endfunction
