%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DESCRIPTION: Computes signed distance to temperature constraints
% INPUT: 
%	State vector X
% 	Scenario sruct
% OUTPUT: Signed distance w.r.t. constraints K
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function gx = stage_cost_temp(x, scenario) 

gx = max( scenario.K_min - x, x - scenario.K_max );


