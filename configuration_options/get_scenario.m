%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PURPOSE: 
%   Create a structure containing scenario-specifc details
% INPUT:
%   scenarioID = the string id of the scenario to use
% OUTPUT:
%   scenario = a structure containing scenario-specific details
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\

function scenario = get_scenario(scenarioID)

    % initialize base scenario
    switch scenarioID
        
        %   thermostatically controlled load example, 
        %   risk-neutral with random cost sum_{t=0}^T e^(m*gK(X_t))
        case 'THRS'
            scenario = fill_scenario_fields_thermsys(scenarioID);

        case 'THLS'
            scenario = fill_scenario_fields_thermsys(scenarioID);

        case 'THNS'
            scenario = fill_scenario_fields_thermsys(scenarioID);

        % Two tank stormwater example
        % risk-neutral with random cost sum_{t=0}^T e^(m*gK(X_t))
        case 'WRS'       
            scenario = fill_scenario_fields_watersys(scenarioID);

        otherwise
            error('no matching scenario found'); 
    end
    
    % setup common properties
    scenario.title = ['Scenario ', scenarioID];
    scenario.risk_functional = 'RNE';
     
    scenario.bellman_backup_method = str2func('Expectation_with_expmgK_stage_cost_backup');

    scenario.cost_function_aggregation = str2func('max'); 
    scenario.allowable_controls = 0: 0.1: 1;  

end



