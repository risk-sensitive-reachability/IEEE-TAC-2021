%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DESCRIPTION: Computes maximum flood level of any Xi in excess of K_max_i
% INPUT: 
%	State vector X
% 	Scenario sruct
% OUTPUT: Stage cost w.r.t. constraints K
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function gx = max_flood_level(x, scenario) 

if scenario.dim == 1
    gx = max(x - scenario.K_max,0); 
else 
    gx = max(max(x - scenario.K_max',0),[],2);
end
