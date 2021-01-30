%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DESCRIPTION: Initializes variables prior to running Bellman recursion
% INPUTs:
%  scenarioID: the string id of the scenario to use
%  configurationID: the numeric id of the configuration to use
%  globals: 
%   ambient struct 
%   scenario struct 
%   config struct 
% OUTPUTS: 
%   Js: a cell array for storing the values associated with optimal control policies
%   mus: a cell array for storing optimal control policies
%   N: the number of discrete time points in the simulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function[Js, mus, N] = setup_reachability(scenarioID, configurationID)

    global ambient; 
    global scenario;
    global config;
    
    % load scenario and configuration
    scenario = get_scenario(scenarioID); 
    config = get_config(configurationID); 

    display(strcat('Running scenario: (', scenarioID, ') \', scenario.title, '\', 'under simulator configuration (',num2str(configurationID) ,').'))

    N = config.T/config.dt;         % Time horizon: {0, 1, 2, ..., N} = {0, 5min, 10min, ..., 240min} = {0, 300sec, 600sec, ..., 14400sec}

    Js = cell( N+1, 1 );            % Contains optimal value functions to be solved via dynamic programming
                                    % Js{1} is J0, Js{2} is J1, ..., Js{N+1} is JN

    mus{N} = cell( N, 1 );          % Optimal policy, mus{N} is \mu_N-1, ..., mus{1} is \mu_0
                                    % mu_k(x,y) provides optimal control action at time k, state x, confidence level y
                                    
    calculate_ambient_variables(); 

    ambient.c = initialize_stage_cost_matrix();
    
    % Initial value function, JN(x,y) = beta*exp(g(x)) for each y
    Js{N+1} = ambient.c;  
    
end