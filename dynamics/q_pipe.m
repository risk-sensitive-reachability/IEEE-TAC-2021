%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PURPOSE: Computes outflow through an orifice using orifice equation
% INPUT:
    %h1 = head above pipe inlet in tank 1 [ft]
    %h2 = head above pipe inlet in tank 2 [ft]  
    %u = control position [ft]
    %R = outlet radius [ft]
% OUTPUT: Flow vector [ft^3/s] 
%	(+ implies flow from tank 1 into tank 2)
%	(- implies flow from tank 2 into tank 1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function q = q_pipe(h1, h2, u, R)

g = 32.2;   % acceleration due to gravity [ft/s^2]

% +1 => flow out of x1 into x2
% -1 => flow out of x2 into x1
% 0 => no flow, equalized pressure

absolute_head_difference = abs(h1 - h2);

flow_direction = sign(h1 - h2);

flow_velocity = sqrt(2 * g * absolute_head_difference);

flow_area = u * pi * R^2; 

q = flow_area * flow_velocity * flow_direction;

end