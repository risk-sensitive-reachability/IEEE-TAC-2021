%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DESCRIPTION: Performs the Risk-Neutral (Expectation) Bellman backwards
% recursion, uk \in {0,1}, with stage cost = exp(m * gK(Xt))
% INPUT: 
    % J_k+1 : optimal cost-to-go at time k+1, array
    % globals: 
    %   ambient struct
    %   config struct 
    %   scenario struct
% OUTPUT: 
    % J_k : optimal cost-to-go starting at time k, array
    % mu_k : optimal controller at time k, array
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ J_k, mu_k ] = Expectation_with_expmgK_stage_cost_backup(J_kPLUS1)

    global ambient; 
    global config; 
    global scenario;
    
    amb = ambient; 
    cfg = config; 
    scn = scenario; 

    if scenario.dim == 1
            J_kPLUS1_grid = J_kPLUS1; 
            F = griddedInterpolant(ambient.x1g, J_kPLUS1_grid, 'linear'); 
    else 
        % in J_kPLUS1_grid each column represents a fixed value of x1
        % and the values of x2 change along the entries of this column (rows)
        J_kPLUS1_grid = reshape(J_kPLUS1, [ambient.x2n, ambient.x1n]); 

        % F([x2,x1]) finds the linear interpolated value of J_kPLUS1 at
        % state x1, x2
        F = griddedInterpolant(ambient.x2g, ambient.x1g, J_kPLUS1_grid, 'linear'); 

    end
    
    J_k = J_kPLUS1; 
    mu_k = J_kPLUS1;
    
    % ambient.c is set to initialize_stage_cost_matrix() in setup_reachability.
    % initialize_stage_cost_matrix() is set to exp( config.m * gx) since 'RNE' is the risk functional
    % gx is cost_function, which is max(Xt - 21, 20 - Xt) for temperature example
    stage_cost = ambient.c; 
    us = scenario.allowable_controls;
            
    for z = 1 : amb.nx
        
        J_k_all_us = zeros(length(us),1);
        
        for m = 1 : length(us)
            
            u = us(m); 
            inside_expected_value_k_wk = zeros(scn.nw,1); 
            
            for i = 1 : scn.nw
        
                % get next state realization
                x_kPLUS1 = scn.dynamics(amb.xcoord(z,:), u, scn.ws(:,i), cfg, scn);                
                
                x_kPLUS1 = snap_to_boundary( x_kPLUS1, amb );
                J_kPLUS1 = F(fliplr(x_kPLUS1)); %comes from griddedInterpolant
                
                inside_expected_value_k_wk(i) = J_kPLUS1;  
                
            end
            
            our_expected_value = sum(inside_expected_value_k_wk .* scn.P); 
           
            J_k_all_us(m) = stage_cost(z) + our_expected_value;
            
        end
        
        [optVal, optIdx] = min(J_k_all_us); 
        J_k(z) = optVal; 
        mu_k(z) = us(optIdx); 
        
    end
end
