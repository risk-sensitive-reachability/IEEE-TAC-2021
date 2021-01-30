%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PURPOSE: 
%    Fills several fields of scenario struct for stormwater system
% INPUT:
%   scenarioId = the string id of the scenario to use
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function scenario = fill_scenario_fields_watersys(scenarioId) 
    
    scenario = []; scenario.dim = 2; scenario.id = scenarioId;
    
    scenario.K_min = zeros( 2, 1 );   % [ft]
    scenario.K_max = [ 3.5; 5 ];      % [ft]
    
    scenario.outlet_elevation_s1 = 1;   % [ft] from pond base
    scenario.outlet_elevation_s2 = 1;   % [ft] from pond base
    scenario.inlet_elevation_s2 = 2.5;  % [ft] from pond base
    
    scenario.surface_area_s1 = 28292;   % [ft^2]
    scenario.surface_area_s2 = 25965;   % [ft^2]
    
    scenario.outlet_radius_s1 = 1;      % [ft]   
    scenario.outlet_radius_s2 = 2/3;    % [ft] 

    scenario.stream_slope = 0.01;
    scenario.mannings_n = 0.1;            % Manning's roughness coefficient [s/m^(1/3)]
    scenario.stream_length = 1820;        % [ft]
    scenario.side_slope = 1/4;            % side slope, stream [dimensionless]
    scenario.outlet_elevation_stream = 1; % [ft]

    scenario.runoff_mean = 12.16;         % [cfs]
    scenario.runoff_variance = 3.22;      % [(cfs)^2]
    scenario.runoff_skewness = 1.68;      % [dimensionless]
    
    [scenario.ws, scenario.P, scenario.nw] = get_runoff_disturbance_profile('right skew');

    scenario.cost_function = str2func('max_flood_level'); 
    scenario.dynamics = str2func('bidirectional_flow_by_gravity'); 
    
end