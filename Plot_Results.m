%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PURPOSE: Plots relavent experimental results for a given scenario and configuration.
% INPUT:
%   scenarioID = the string id of the scenario to use
%   configurationID = the numeric id of the configuration to use
%   [file]
%       /staging/{configurationID}/{scenarioID}/Monte_Carlo_complete.mat : a
%       file containing Monte Carlo results for all confidence levels
% OUTPUTS:
%   [file](s)
%       /staging/{configurationID}/{scenarioID}/level_sets.png :
%       Portable Network Graphics figure for level sets
%   [file](s)
%       /staging/{configurationID}/{sceanrioID}/level_sets.fig :
%       Matlab figure for level sets
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [S, U] = Plot_Results(scenarioID, configurationID)

staging_area = get_staging_directory(scenarioID, configurationID);
monte_carlo_file = strcat([staging_area,'Monte_Carlo_complete.mat']);

% if MC file is available, load it, otherwise prompt to Run_Monte_Carlo.
if isfile(monte_carlo_file)
    
    load(monte_carlo_file);
    
else
    
    error(strcat('No results available for this scenario (',scenarioID, ') and configuration (', mat2str(configurationID),'). Please Run_Bellman_Recursion and Run_Monte_Carlo first.'));
    
end

% load globals
global scenario;
global config;
global ambient;

if ~strcmp(scenario.risk_functional, 'RNE')
    error('Plot_Level_Sets.m dim = 1 is only written for RNE now');
end

if scenario.dim == 2
    
    rs_to_show = [0.5, 1.0, 1.5];
    percentage_full = zeros(length(rs_to_show), nl);
    
    J0_MonteCarlo = J0_MC';
    
    J0_cost_sum_scaled_by_y_with_log_etc = zeros(nl, ambient.x2n, ambient.x1n);
    
    J0_Bellman = Js{1};
    J0_Bellman_grid = reshape(J0_Bellman, [ambient.x2n, ambient.x1n]);
    
    for l_index = 1 : nl
        y = config.monte_carlo_levels(l_index);
        J0_cost_sum_scaled_by_y_with_log_etc(l_index,:,:) = log( J0_Bellman_grid / y ) / config.m;
    end
    
    for l_index = 1:length(config.monte_carlo_levels)
        
        J0_MonteCarlo_grid = reshape(J0_MonteCarlo(:,l_index), [ambient.x2n, ambient.x1n]);
        
        % begin plotting section
        set(gcf,'color','w');
        subplot(1, length(config.monte_carlo_levels), l_index);
        
        [C, h] = contour(ambient.x2g, ambient.x1g, squeeze(J0_cost_sum_scaled_by_y_with_log_etc(l_index,:,:)), rs_to_show);
        clabel(C,h);
        h.LineWidth = 1;
        h.LineColor = 'magenta';
        hold on;
        
        [C, h] = contour(ambient.x2g, ambient.x1g, J0_MonteCarlo_grid, rs_to_show);
        clabel(C,h);
        h.LineWidth = 1;
        h.LineColor = 'blue';
        h.LineStyle = '--';
        
        for r = 1:length(rs_to_show)
            percentage_full(r, l_index) = (sum(sum(J0_cost_sum_scaled_by_y_with_log_etc(l_index,:,:) <= rs_to_show(r))) / sum(sum(J0_MonteCarlo_grid <= rs_to_show(r)))) * 100;
        end
        
        %title(['$\alpha$ = ', num2str(config.monte_carlo_levels(i)), ', $r \in \{$', num2str(rs_to_show(1)), ', ',num2str(rs_to_show(2)), '\}'], 'Interpreter','Latex', 'FontSize', 22);
        title(['$\alpha$ = ', num2str(config.monte_carlo_levels(l_index))], 'Interpreter','Latex', 'FontSize', 16);
        
        %if l_index == length(config.monte_carlo_levels) 
         %   legend({'$\partial\hat{\mathcal{U}}_\alpha^r$', '$\partial \hat{\mathcal{S}}_\alpha^r$'},'Interpreter','Latex','FontSize', 16, 'Location','southwest');
        %end
        xlabel('$x_2$','Interpreter','Latex','FontSize', 16);
        ylabel('$x_1$','Interpreter','Latex','FontSize', 16);
        grid on;
        
        hold off;
    end
    
    % uncomment to generate Table III 
    %disp(percentage_full); 
    
    path_to_png = strcat(staging_area,'level_sets.png');
    path_to_fig = strcat(staging_area,'level_sets.fig');
    saveas(gcf,path_to_fig);
    
    saveas(gcf,path_to_fig);
    f = gcf;
    f.PaperUnits = 'inches';
    f.PaperPosition = [0 0 18 3.2];
    print(path_to_png,'-dpng','-r0');
    
    %close all ;
    
else
    
    nl = length(config.monte_carlo_levels); % # discretized confidence levels
    
    J0_cost_sum = Js{1}';
    % approximates E( sum_{t=0}^T exp^(m * gK(Xt) ) for each initial condition under best Markov policy
    % row vector 1 x 51
    
    %J0_cost_sum(J0_cost_sum <= 0) = 0.00001; Might need to use for a larger example
    
    % J0_cost_sum_scaled_by_y_with_log_etc(l_index, x_index) is computed
    % 1/m * log( E( sum_{t=0}^T exp^(m * gK(Xt))/y ) for
    % X0 = ambient.x1s(x_index), y = config.monte_carlo_levels(l_index)
    % under computed Markov policy
    
    J0_cost_sum_scaled_by_y_with_log_etc = zeros(nl,ambient.nx);
    
    for l_index = 1 : nl
        y = config.monte_carlo_levels(l_index);
        J0_cost_sum_scaled_by_y_with_log_etc(l_index,:) = log( J0_cost_sum / y ) / config.m;
    end
    % row 1 of J0_cost_sum_scaled_by_y_with_log_etc corresponds to config.monte_carlo_levels(1)
    % row 2 of J0_cost_sum_scaled_by_y_with_log_etc corresponds to config.monte_carlo_levels(2)
    
    % row l_index: refers to y = config.monte_carlo_levels(l_index)
    % col x_index: refers to initial state x = ambient.x1s(x_index)
    % estimate of CVAR_y( max g(Xk) ) initialized at x
    J0_cost_max = J0_MC;
    % row 1 of J0_MC corresponds to config.monte_carlo_levels(1)
    % row 2 of J0_MC corresponds to config.monte_carlo_levels(2)
    
    IC_Of_Interest = [20 20.2 20.4 20.6 20.8 21]; thres_IC = 0.001; IC_index = 1;
    figure(1); set_figure_properties;
    
    for x_index = 1 : ambient.nx
        
        % locates ambient.x1s(x_index) close to IC_Of_Interest(IC_index)
        if (ambient.x1s(x_index) <= IC_Of_Interest(IC_index) + thres_IC) && (ambient.x1s(x_index) >= IC_Of_Interest(IC_index) - thres_IC)
            subplot( 1, ceil(length(IC_Of_Interest)), IC_index );
            %each row of the matrices below correspond to a different alpha
            plot( J0_cost_max(:,x_index), J0_cost_sum_scaled_by_y_with_log_etc(:,x_index), '-*'); hold on;
            %for comparison, if bound was perfect
            plot( linspace(-0.5,2,length(IC_Of_Interest)), linspace(-0.5,2,length(IC_Of_Interest)), ':', 'Color', [210 210 210]/255 ); % light gray
            title(['x = ',num2str(IC_Of_Interest(IC_index))]);
            %xlabel('Approx. CVAR of MAX at alpha');
            %if IC_index == 1, ylabel('Approx. Upper Bound at alpha'); end
            axis square;
            grid on;
            axis([-0.5 2 -0.5 2]);
            IC_index = IC_index + 1;
        end
        if IC_index > length(IC_Of_Interest); break; end
        
    end
    path_to_png = strcat(staging_area,'/bounds.png');
    path_to_fig = strcat(staging_area,'/bounds.fig');
    saveas(gcf,path_to_png);
    saveas(gcf,path_to_fig);
    
    figure(2); set_figure_properties;
    
    nr = 6; % # discretized risk levels
    rs = linspace( 0.25, 1.5, nr ); % risk levels to be plotted, choose min to be slightly bigger than min(min(J0_cost_max))
    %rs = [rs(1), rs(4), rs(2), rs(5), rs(3), rs(6)]; % so risk levels decrease sequentially along each column in figure
    
    for r_index = 1 : nr
        r = rs(r_index);
        for l_index = 1 : nl
            y = config.monte_carlo_levels(l_index); U_ry = []; S_ry = [];
            subplot(nr, nl, (r_index-1)*nl + l_index);
            for x_index = 1 : length(ambient.x1s)
                
                if J0_cost_sum_scaled_by_y_with_log_etc(l_index, x_index) <= r,   U_ry = [ U_ry, ambient.x1s(x_index) ]; end
                
                if J0_cost_max(l_index, x_index) <= r,   S_ry = [ S_ry, ambient.x1s(x_index) ]; end
                
            end
            
            y_values_line_U_ry = ones(1);
            if ~isempty(U_ry)
                
                switch(scenarioID)
                    case 'THNS'
                        y_values_line_U_ry = ones((size(U_ry)));
                    case 'THLS'
                        y_values_line_U_ry = ones((size(U_ry))) * 2;
                    case 'THRS'
                        y_values_line_U_ry = ones((size(U_ry))) * 3;
                    otherwise
                        y_values_line_U_ry = ones((size(U_ry)));
                end
            end
            
            y_values_line_S_ry = ones(1);
            if ~isempty(S_ry)
                
                switch(scenarioID)
                    case 'THNS'
                        y_values_line_S_ry = ones((size(S_ry)));
                    case 'THLS'
                        y_values_line_S_ry = ones((size(S_ry))) * 2;
                    case 'THRS'
                        y_values_line_S_ry = ones((size(S_ry))) * 3;
                    otherwise
                        y_values_line_S_ry = ones((size(S_ry)));
                end
            end
            
            if ~isempty(S_ry), percentfull_ry = length(U_ry)/length(S_ry)*100; end
            
            if ~isempty(S_ry), plot(S_ry, y_values_line_S_ry, 'ob', 'linewidth', 1); hold on; end
            
            S{r_index}{l_index} = S_ry;
            
            if ~isempty(S_ry), text(max(ambient.x1s),y_values_line_S_ry(1),[num2str(round(percentfull_ry,0)),'%']); end
            
            if ~isempty(U_ry), plot(U_ry, y_values_line_U_ry, 'o', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r'); hold on; end;
            
            U{r_index}{l_index} = U_ry;
            
            % if r_index == nr && l_index == nl, legend('Approx. U set','Approx. S set','Location','bestoutside'); end
            
            title(['r = ', num2str(r), ', alpha = ', num2str(y)]);
            
            if r_index == nr, xlabel('Temperature (deg C), x'); end
            
            set(gca,'YTickLabel',[]);
            
            ylim([0 4]);
            xlim([min(ambient.x1s) max(ambient.x1s)+2]); grid on; %xticks(ambient.x1s);
            
            % hard-coded
            % xticklabels({'0','','','','','0.5','','','','','1','','','','','1.5','','','','','2','','','','','2.5'});
            
        end
        
    end
    path_to_png = strcat(staging_area,'/level_sets.png');
    path_to_fig = strcat(staging_area,'/level_sets.fig');
    
    saveas(gcf,path_to_fig);
    f = gcf;
    f.PaperUnits = 'inches';
    f.PaperPosition = [0 0 16 9];
    print(path_to_png,'-dpng','-r0');
    
end

