%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PURPOSE: 
%   Create a structure containing scenario-agnostic simulation information
% INPUT:
%   configId = the numeric id of the configuration to use
% OUTPUT:
%   config = a structure containing scenario-agnostic simulation information
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function config = get_config(configId)

    config = []; 
    config.id = mat2str(configId);

    config.monte_carlo_trials = 100000; 				% number of trials per grid point for W_0* estimation
    config.monte_carlo_levels = [0.99, 0.05, 0.01, 0.005, 0.001]; 

    config.histogram_trials = 1000 * 1000;              % number of samples to use when generating histogram
    config.histogram_levels = [ 0.99, 0.05, 0.01 ];     % ls at which to initialize histogram 

    if configId <= 0 || configId > 200 || configId == 100
        
        error('only configurations 1-99 and 101-199 are supported'); 
    
    elseif configId > 100                  % configure for temperature system
        config.grid_spacing = 1/10;        % [degrees C]
        config.dt = 5/60;                  % Duration of [k, k+1) in hours, 5 min = 5/60 h
        config.T = 1;                      % length of time horizon in hours, 60 min = 1 h
        config.grid_upper_buffer = 2;      % [deg C]
        config.grid_lower_buffer = 2;      % [deg C]    
        config.m = configId - 100; 
    
    else                                   % configure for water system
        config.grid_spacing = 1/10;        % [ft] state discretization interval
        config.dt = 300;                   % Duration of [k, k+1) [sec], 5min = 300sec
        config.T = 3600 * 2;               % Design storm length [sec], 1h = 1h*3600sec/h
        config.grid_upper_buffer = 1.5;    % [ft]
        config.grid_lower_buffer = 0;      % [ft]
        config.m = configId; 
    end

end