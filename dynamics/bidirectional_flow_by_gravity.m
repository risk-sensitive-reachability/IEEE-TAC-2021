%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DESCRIPTION: Defines discrete-time dynamics of two tanks connected by a pipe
% INPUT:
    % xk : water elevation at time k [ft]
    % uk : valve setting at time k [no units]
    % wk : average surface runoff rate on [k, k+1) [ft^3/s]
   	% config struct 
   	% scenario struct 
% OUTPUT:
    % xkPLUS1 : water elevation at time k+1 [ft]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function xkPLUS1 = bidirectional_flow_by_gravity( xk, uk, wk, config, scenario)

if scenario.dim == 1
    error('bidirecitonal flow model requires two dimensions'); 
else 

% each tank will receive the same disturbacne    
wk = [wk, wk]; 

% Assumptions
%   flow through horizontal pipe driven by differences in hydrostatic pressure
%   no energy loss due to friction
%   flow is immediately reversible

% xk is a row vector where
% xk(1) is x1 at current time step
% xk(2) is x2 at current time step

f = ones(scenario.dim,1);

SA1 = scenario.surface_area_s1;        % [ft^2]
SA2 = scenario.surface_area_s2;        % [ft^2]

R1 = scenario.outlet_radius_s1;        % [ft] pipe radius (bidirectional flow s1 <=> s2)
R2 = scenario.outlet_radius_s2;        % [ft] orifice radius (unidirectional flow s2 => void)

% these refer to the same absolute elevation, but have different relative
% values becuase the bottoms of the storage units are not assumed to be at 
% the same absolute elevation
Z1 = scenario.outlet_elevation_s1;     % [ft] invert elevation of pipe from s1 bottom (outlet of s1)
Z_in1 = scenario.inlet_elevation_s2;   % [ft] invert elevation of pipe from s2 bottom (inlet of s2)

Z2 = scenario.outlet_elevation_s2;     % [ft] invert elevation from common datum

% head in x1
h1 = max(xk(1)-Z1,0); 
% head in x2
h2 = max(xk(2)-Z_in1,0); 

q_valve = q_pipe(h1, h2, uk, R1);
q_drain = q_outlet( xk(2), 1, R2, Z2);

% f is a column vector where
% f(1) is x1_dot
% f(2) is x2_dot
f(1) = ( wk(1) - q_valve ) / SA1;  % time-derivative of x [ft/s]

if scenario.dim > 1
    f(2) = (wk(2) + q_valve - q_drain) / SA2; 
end

% xkPLUS1 is a row vector where
% xkPLUS1(1) is x1 at next time step
% xkPLUS1(2) is x2 at next time step
xkPLUS1 = xk + f'*config.dt;

end


        
        
