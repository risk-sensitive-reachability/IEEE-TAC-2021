%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PURPOSE: Writes stage start progress to console and log file 
% INPUT:
    % staging_area: directory where log file will live  
    % k: stage 
% OUTPUT: 
    % /{path_to_staging_area}/times.txt : log file of times and stages
    %       completed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function[] = write_log_start_stage(staging_area, k)
    
    stage_start_time = datestr(datetime('now'),'yyyy_mm_dd_HH_MM_SS');
    
    % write to console
    disp(strcat(['Stage ', num2str(k), ' begun:']));
    disp(stage_start_time); 
    
    % write to log file
    fid = fopen(strcat([staging_area,'/','Bellman_times.txt']),'a+');
    fprintf(fid, '\n');
    fprintf(fid, strcat(['Stage ', num2str(k), ' begun:']));
    fprintf(fid, '\n');
    fprintf(fid, stage_start_time);
    fprintf(fid, '\n');
    fclose(fid);

end
