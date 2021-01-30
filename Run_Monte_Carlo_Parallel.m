%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PURPOSE: Runs Monte Carlo simulation for particular scenario under a given configuration. 
%    in parallel across independent elements of the state-space.
% INPUT:
    % scenarioID = the string id of the scenario to use    
    % configurationID = the numeric id of the configuration to use
    % [file] : 
    %     /staging/{configurationID}/{scenarioID}/Bellman_complete.mat : a
    %     file containing results for all recursion steps
    % [optional "hot start" file] : 
    %       /staging/{configurationID}/{scenarioID}/Monte_Carlo_checkpoint.mat : 
    %      a file containing Monte Carlo Results for any completed confidence levels
% OUTPUT: 
    %   [file] (updated after each confidence level & deleted upon completion) :
    %       /staging/{configurationID}/{scenarioID}/Monte_Carlo_checkpoint.mat : 
    %       a file containing Monte Carlo Results for any completed confidence levels
    %   [file] (after all confidence levels) : 
    %       /staging/{configurationID}/{scenarioID}/Monte_Carlo_complete.mat : 
    %       a file containing Monte Carlo results for all confidence levels
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = Run_Monte_Carlo_Parallel(scenarioID, configurationID)
    
    % declare globals
    global config; 
    global scenario;
    global ambient;

    % check staging area for scenarioID, configurationID
    staging_area = get_staging_directory(scenarioID, configurationID); 
    
    bellman_file = strcat([staging_area,'Bellman_complete.mat']);
    
    mc_checkpoint_file = strcat([staging_area, 'Monte_Carlo_checkpoint.mat']); 
    mc_complete_file = strcat([staging_area, 'Monte_Carlo_complete.mat']); 
    
    if ~isfile(mc_complete_file)
    
        % if checkpoint file is available, load it, otherwise start fresh
        if isfile(mc_checkpoint_file)

            load(mc_checkpoint_file); 
            [any_nans, if_any_nans_first_row_with_nan] = max(arrayfun(@isnan,J0_MC));

            % determine start point for monte carlo session
            if any_nans

                start_point = min(if_any_nans_first_row_with_nan);

            end

        % start fresh monte carlo session
        elseif isfile(bellman_file)

            load(bellman_file); 

            start_point = 1;

            muInterpolants = get_mu_interpolants(mus); 

            nw = length(scenario.ws); tick_P = zeros( nw + 1, 1 );                     % nw : number of possible values of wk

            for i = 1 : nw, tick_P(i+1) = tick_P(i) + scenario.P(i); end               % tick_P = [ 0, P(1), P(1)+P(2), ..., P(1)+...+P(nw-1), 1 ]

            nl = length(config.monte_carlo_levels); 
            % for strcmp(scenario.risk_functional,'RNE'), we want to estimate
            % CVAR_alpha(max g(Xt)) at multiple alphas. The alphas to do monte carlo are defined
            % in get_config.m (monte_carlo_levels).

            if strcmp(scenario.risk_functional,'EXP')
               nl = 1;  
            end

            amb = ambient; 
            cfg = config; 
            scn = scenario; 

            nt = config.monte_carlo_trials; 
            N = config.T / config.dt; % number of timesteps per trial

            % initialize J0_MC with NaNs
            J0_MC = NaN( nl, ambient.nx);

        else    

            error('No results available for this scenario and configuration. Please Run_Bellman first.');

        end

        % begin Monte Carlo Session
        disp('start time:');
        display(datestr(datetime('now'),'HH:MM:SS'));
        
        parfor x_index = 1 : amb.nx  % for each grid point

            % for reproducibility
            rng('default'); 

            disp(x_index); 
            disp(datestr(datetime('now'),'yyyy-mm-dd HH:MM:SS'))

            stage_costs_by_trial = zeros(N+1, nt); 

            for q = 1:nt
                [myTraj, myCtrl, myCosts] = sample_trajectory(amb.xcoord(x_index,:), tick_P, muInterpolants, scn, cfg, amb);             % get trajectory sample
                stage_costs_by_trial(:, q) = myCosts; 
            end

            % stage_costs_by_trial is a N-row, nt-column matrix
            % calling 'sum' or 'max' via
            % scenario.cost_function_aggregation applies the
            % aggregation across all the rows in each column, leaving a
            % summarized per trial result
            trajectory_costs_by_trial = scn.cost_function_aggregation(stage_costs_by_trial); 
            
            % No need to run MC for all confidence levels for RNE.
            % We can calculate remaining confidence levels based on
            % results from oen pass of MC.

            J0_MC_x = NaN( nl, 1);
            for l_index = start_point : nl
                y = cfg.monte_carlo_levels(l_index);
                var = quantile(trajectory_costs_by_trial, 1-y);
                J0_MC_x(l_index)= estimate_CVaR_from_emperical_data(trajectory_costs_by_trial, y, var);
            end
            
            J0_MC(:, x_index) = J0_MC_x;
            
        end
        
        disp(strcat('Monte carlo complete.'));
        disp(datestr(datetime('now'),'HH:MM:SS'))

        save(mc_complete_file);

    else 
        disp('Monte Carlo is already complete.');
    end
    
end