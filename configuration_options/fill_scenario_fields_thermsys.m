%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PURPOSE: 
%    Fills several fields of scenario struct for therm_ctrl_load system
% INPUT:
%   scenarioId = the string id of the scenario to use
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function scenario = fill_scenario_fields_thermsys(scenarioId)

	scenario = []; scenario.dim = 1; scenario.id = scenarioId;

	scenario.title = ['Scenario ', scenarioId];

    scenario.K_max = 21;  % [deg C]
    scenario.K_min = 20;  % [deg C]
    
    switch(scenarioId)
        case 'THLS'
            [scenario.ws, scenario.P, scenario.nw] = get_temperature_disturbance_profile('left skew'); 
        case 'THRS'
            [scenario.ws, scenario.P, scenario.nw] = get_temperature_disturbance_profile('right skew');
        case 'THNS'
            [scenario.ws, scenario.P, scenario.nw] = get_temperature_disturbance_profile('no skew'); 
        otherwise
            error('no disturbance defined for scenario')
    end

    % stage_cost_temp is: gx = max( scenario.K_min - x, x - scenario.K_max );
	scenario.cost_function = str2func('stage_cost_temp'); 
	scenario.dynamics = str2func('therm_ctrl_load');

end
