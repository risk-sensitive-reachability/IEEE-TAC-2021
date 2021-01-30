%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DESCRIPTION: Initializes the stage cost for each element in the state-space
% INPUT: 
%	globals: 
%		ambient struct 
%		config struct
%		scenario struct
% OUTPUT: Stage cost
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function c = initialize_stage_cost_matrix() 

global scenario 
global config
global ambient

% assumes cost is only based on X
gx = scenario.cost_function(ambient.xcoord, scenario); 

%RNE - risk neutral, the stage cost is: exp( m * g(Xt) ), which we sum over time.
c = exp( config.m * gx);
