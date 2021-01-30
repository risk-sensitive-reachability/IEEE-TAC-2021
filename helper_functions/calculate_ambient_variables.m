%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PURPOSE: Initializes the ambient struct which contains information about
%         the state-space and means of indexing it. 
% INPUTS: 
%    globals:
%        config struct
%        scenario struct 
% OUTPUT:
%    globals:
%        ambient struct 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function calculate_ambient_variables

global config; 
global scenario; 
global ambient; 

ambient = []; 
ambient.nu = length(scenario.allowable_controls);
ambient.nw = scenario.nw; 

if scenario.dim == 1
    ambient.x1s = scenario.K_min-config.grid_lower_buffer:config.grid_spacing:scenario.K_max+config.grid_upper_buffer;
    ambient.x1g = ndgrid(ambient.x1s); 
    ambient.x1n = length(ambient.x1s); 
    ambient.nx = ambient.x1n; 
    ambient.xcoord = ambient.x1s'; 
    ambient.xmax = max(ambient.x1s);
    ambient.xmin = min(ambient.x1s);
    
else 
    ambient.x1s = scenario.K_min(1)-config.grid_lower_buffer:config.grid_spacing:scenario.K_max(1)+config.grid_upper_buffer; 
    ambient.x2s = scenario.K_min(2)-config.grid_lower_buffer:config.grid_spacing:scenario.K_max(2)+config.grid_upper_buffer;
    [X1, X2] = ndgrid(ambient.x1s, ambient.x2s); 
    ambient.x1g = X1'; 
    ambient.x2g = X2'; 
    ambient.x1n = length(ambient.x1s); 
    ambient.x2n = length(ambient.x2s);
    ambient.nx = ambient.x1n * ambient.x2n; 
    ambient.xmax = [max(ambient.x1s), max(ambient.x2s)];
    ambient.xmin = [min(ambient.x1s), min(ambient.x2s)];
    
    z = 0; 
    xcoord = zeros(ambient.nx,2); 
    for i = 1:ambient.x1n
        for j = 1:ambient.x2n
            z = z + 1; 
            xcoord(z,1) = ambient.x1s(i); 
            xcoord(z,2) = ambient.x2s(j); 
        end
    end
    ambient.xcoord = xcoord; 
end



