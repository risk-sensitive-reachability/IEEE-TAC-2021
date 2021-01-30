%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PURPOSE: Generates applicable figures in
%   https://arxiv.org/abs/2101.12086
% INPUT:
    % figureNumber = the numeric id of the figure to generate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Generate_Figure(figureNumber)

   switch(figureNumber)

       case 3
           close all; 
           % plot cost function over state space for temperature system
           global scenario; 
           global config; 
           global ambient; 
           
           scenario = get_scenario('THRS');
           config = get_config(101); 
           calculate_ambient_variables();
           figure(3);
           plot(ambient.x1s, scenario.cost_function(ambient.xcoord, scenario), 'LineWidth', 3); 
           xlabel('Temperature (deg C), x'); 
           ylabel('gK');
           
       case 4
           close all; 
           figure(4); 
           % plot disturbance distributions for the temperature system
           subplot(1, 3, 1); 
           Plot_Disturbance_Profile('THLS'); 
           subplot(1, 3, 2); 
           Plot_Disturbance_Profile('THNS', false); 
           subplot(1, 3, 3); 
           Plot_Disturbance_Profile('THRS', false); 
           
       case 5
           % plot results by gamma and initial condition
           disp('Generating supporting graphics... this may take a moment.');
           configs_to_plot = [ 110, 114, 118 ]; 
           for i = 1:length(configs_to_plot)
                generate_supporting_graphics_for_figures_5_and_6(configs_to_plot(i));
           end
            close all; 
            gamma_10 = hgload(strcat(get_staging_directory('THNS', 110),'bounds.fig'));
            gamma_14 = hgload(strcat(get_staging_directory('THNS', 114),'bounds.fig'));
            gamma_18 = hgload(strcat(get_staging_directory('THNS', 118),'bounds.fig'));
            
            figure(5); set_figure_properties;
            tcl = tiledlayout(3, 7); 
            
            % add first row of plots for gamma = 10
            for child = 1:6
                 ref = gamma_10.Children(1);
                 ref.Parent = tcl; 
                 ref.Layout.Tile = 6 - child + 2;    
            end
            
            % add second row of plots for gamma == 14
            for child = 1:6
                 ref = gamma_14.Children(1);
                 ref.Parent = tcl; 
                 ref.Layout.Tile = 12 - child + 3;    
            end
            
            % add third row of plots for gamma == 18
            for child = 1:6
                 ref = gamma_18.Children(1);
                 ref.Parent = tcl; 
                 ref.Layout.Tile = 18 - child + 4;    
            end
            
            % add gamma levels to first column (gamma := cfg.m)
            for i = 1:length(configs_to_plot)
                cfg = get_config(configs_to_plot(i)); 
                figure(4);
                row1 = gca; 
                set(row1, 'visible', 'off'); 
                text(-3,2.5,strcat('\gamma =',{''},mat2str(cfg.m)),'FontSize',20);
                xlim([0,5]);
                ylim([0,5]); 
                row1.Parent = tcl; 
                row1.Layout.Tile = i*6 - 6 + i;
                close(figure(4));
            end
            
            close(figure(1)); 
            close(figure(2)); 
            close(figure(3)); 

       case 6
           disp('Generating supporting graphics... this may take a moment.');
           close all; 
           generate_supporting_graphics_for_figures_5_and_6(114); 
           gamma_14 = hgload(strcat(get_staging_directory('THNS', 114),'level_sets.fig'));
           
           figure(6); set_figure_properties;
           tcl = tiledlayout(6, 5); 
           
           for child = 1:30
                 ref = gamma_14.Children(1);
                 ref.Parent = tcl; 
                 ref.Layout.Tile = 30 - child + 1;    
            end
           
           close(figure(1)); 
           
       case 7
           close all; 
           figure(7); 
           % plot disturbance distribution for the water system
           Plot_Disturbance_Profile('WRS');         
         
       case 8
           close all; 
           figure(8); 
           Plot_Results('WRS',22); 
           
           
       otherwise
           disp(strcat({'Not applicable to figure '}, mat2str(figureNumber)));  
       
   end 
   
end

function generate_supporting_graphics_for_figures_5_and_6(configId)
    
    
    close all; 
    Plot_Results('THRS', configId);
    Plot_Results('THLS', configId);
    Plot_Results('THNS', configId); 
    close all; 
        
end