%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PURPOSE: 
%   Runs Bellman recursion for a particular scenario and configuration
%   in parallel across independent elements of the state-space.
% INPUT:
    % scenarioID = the string id of the scenario to use    
    % configurationID = the numeric id of the configuration to use
    % [optional "hot start" file)
    %    /staging/{configurationID}/{scenarioID}/checkpoint.mat : 
    %        a file containing any previously completed recursion steps
% OUTPUT: 
    %   [file] (updated after each recursion step & deleted upon completion) :
    %       /staging/{configurationID}/{scenarioID}/Bellman_checkpoint.mat - 
    %       a file containing results for any completed recursion steps
    %   [file] (after each recursion step) :
    %       /staging/{configurationID}/{scenarioID}/times.txt - 
    %       a file containing the bellman 
    %   [file] (after all recursion steps)
    %       /staging/{configurationID}/{scenarioID}/Bellman_complete.mat : a
    %       file containing results for all recursion steps
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function[] = Run_Bellman_Recursion_Parallel(scenarioID, configurationID)

    % declare globals so they are saved with results 
    global ambient;
    global scenario;
    global config;

    % check staging area for scenarioID, configurationID
    staging_area = get_staging_directory(scenarioID, configurationID); 
    checkpoint_file = strcat([staging_area,'Bellman_checkpoint.mat']);
    complete_file = strcat([staging_area,'Bellman_complete.mat']);

    % if checkpoint file is available, load it, otherwise start fresh
    if isfile(checkpoint_file)
        
        load(checkpoint_file); 
        
    else
        
        % Initialize variables used in value iteration
        [Js, mus, N] = setup_reachability(scenarioID, configurationID);   
        
        base_method = func2str(scenario.bellman_backup_method); 
        disp(base_method); 
        scenario.bellman_backup_method = str2func(strcat(['Parallel_',base_method])); 
        
    end

    start_point = max(find(cellfun(@isempty,Js),N+1));

    for k = start_point: -1: 1

        % record stage start
        write_log_start_stage(staging_area, k); 
        
        % run stage
        [ Js{k} , mus{k} ] = perform_Bellman_backup_step(Js{k+1}); 
        
        % save checkpoint
        save(checkpoint_file);
        
        % record stage complete
        write_log_end_stage(staging_area, k); 
        
    end 

    % save complete file
    save(complete_file);
    
    % cleanup
    if isfile(complete_file) && isfile(checkpoint_file)
        delete(checkpoint_file); 
    end

end