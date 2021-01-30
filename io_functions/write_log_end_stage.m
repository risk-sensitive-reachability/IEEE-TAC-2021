%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PURPOSE: Writes stage end progress to console and log file 
% INPUT:
    % staging_area: directory where log file will live  
    % k: stage 
% OUTPUT: 
% /{path_to_staging_area}/times.txt : log file of times and stages
%       completed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function[] = write_log_end_stage(staging_area, k)

    stage_complete_time = datestr(datetime('now'),'yyyy_mm_dd_HH_MM_SS');
    
    % write to console
    disp(strcat(['Stage ', num2str(k), ' complete:']));
    disp(stage_complete_time); 
    
    % write to log file
    fid = fopen(strcat([staging_area,'/','Bellman_times.txt']),'a+');
    fprintf(fid, '\n');
    fprintf(fid, strcat(['Stage ', num2str(k), ' complete:']));
    fprintf(fid, '\n');
    fprintf(fid, stage_complete_time);
    fprintf(fid, '\n');
    fclose(fid);

end