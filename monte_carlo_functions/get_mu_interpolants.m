%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DESCRIPTION: Gets a griddedInterpolant for the mus
% INPUT:
    % mus: optimal policies
    % globals: 
    %   config struct 
    %   ambient struct 
    %   global struct 
% OUTPUT:
    % F: griddedInterpolant of the mus
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function F = get_mu_interpolants(mus)

    global config; 
    global ambient; 
    global scenario; 
    
    N = config.T/config.dt;

    F = cell(N, 1); 

    if scenario.dim == 1
        
        if strcmp(scenario.id,'TC') && strcmp(scenario.risk_functional,'CVAR')
            for i = 1:N
                mu_k = mus{i}; 
                mu_grid_k = ones(ambient.nl, ambient.x1n); 
                for j = 1:ambient.nl
                    reverse = fliplr(1:ambient.nl);
                    mu_grid_k(reverse(j),:) = (mu_k(:,j))';
                    % 9th row of mu_grid_k corresponds to ls(1) = 0.999
                    % 1st col of mu_grid_k corresponds to xs(1)
                end
                [L, X1] = ndgrid(fliplr(config.ls'), ambient.x1s); 
                                % [0.001 ... 0.999]  [20.5 ... 23.5]
                F{i} = griddedInterpolant(L, X1, mu_grid_k, 'linear');
                % ls increase down the rows, xs increase across cols left-to-right
                %   in L, X1, mu_grid_k
            end
        elseif strcmp(scenario.risk_functional,'EXP') || strcmp(scenario.risk_functional,'RNE')
            for i = 1:N
                mu_k = mus{i}; 
                mu_grid_k = mu_k;
                F{i} = griddedInterpolant(ambient.x1g, mu_grid_k, 'linear');
            end
        else
            for i = 1:N, F{i} = griddedInterpolant(ones(2), 'linear'); end
        end
        
    else 
        
        if strcmp(scenario.risk_functional,'CVAR')
        
            for i = 1:N
            mu_k = mus{i}; 

            mu_grid_k = ones(ambient.nl, ambient.x2n, ambient.x1n); 

                for j = 1:ambient.nl

                    reverse = fliplr(1:ambient.nl);
                    mu_grid_k(reverse(j),:,:) = reshape(mu_k(:,j), [ambient.x2n, ambient.x1n]); 

                end

           % F{i} = griddedInterpolant(ambient.x2g, ambient.x1g, mu_grid_k); 

            [L, X2, X1] = ndgrid(fliplr(config.ls'), ambient.x2s, ambient.x1s); 

            % to not allow extrapolation, need 'none'
            % unfortunately we need extrapolation to estimate ls = 0 or 1
            %  F{i} = griddedInterpolant(L, X2, X1, mu_grid_k, 'linear', 'none');
            %
            F{i} = griddedInterpolant(L, X2, X1, mu_grid_k, 'linear');
       
            end
        
        else 
            
            for i = 1:N
                mu_k = mus{i}; 

                mu_grid_k = reshape(mu_k, [ambient.x2n, ambient.x1n]); 

                % F{i} = griddedInterpolant(ambient.x2g, ambient.x1g, mu_grid_k); 

                [X2, X1] = ndgrid(ambient.x2s, ambient.x1s); 

                % to not allow extrapolation, need 'none'
                % unfortunately we need extrapolation to estimate ls = 0 or 1
                %  F{i} = griddedInterpolant(L, X2, X1, mu_grid_k, 'linear', 'none');
                %
                F{i} = griddedInterpolant(X2, X1, mu_grid_k, 'linear');
            end
            
        end
        
    end 


end