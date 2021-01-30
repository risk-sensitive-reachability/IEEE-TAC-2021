%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PURPOSE: Plots disturbance profile for a given scenario
% INPUT:
    % scenarioID = the string id of the scenario to use    
    % useYLabel = (optional) if explicitly set to false, the yaxis will not
    % be labeled [useful for subplots]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Plot_Disturbance_Profile(scenarioID, useYLabel)

    global scenario;

    scenario = get_scenario(scenarioID); 
    
    set_figure_properties; set(gcf,'defaultaxesfontsize',16)
    
    if strcmp(scenario.risk_functional, 'WorstCase')
        wk = max(scenario.ws); 
        plot([wk, wk], [0, 1], '--');  
        hold on; 
        scatter(wk, 1, 'Black', 'Filled'); 
        hold off;
    else 
         for i = 1:length(scenario.ws)
            wk = max(scenario.ws(i)); 
            plot([wk, wk], [0, scenario.P(i)], '--');  
            hold on; 
         end
        scatter(scenario.ws, scenario.P, 25, 'Black', 'Filled');
        hold off; 
    end
    ylim([0, 0.15]); title(strcat(['Disturbance Profile for Scenario ', scenarioID]), 'FontSize',16); 
    
    if ~exist('useYLabel','var') || useYLabel == true
        ylabel('Probability', 'FontSize',16); 
    end
    
    xlabel('Disturbance value', 'FontSize',16); 
    

end 