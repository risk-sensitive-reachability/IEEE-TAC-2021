%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PURPOSE: Generates a path to store outputs of the form
%   '{MatlabWorkingDirectory}/staging/{scenarioID}/{configurationID}/'
%
% INPUT:
%   scenarioID = the string id of the scenario to use    
%   configurationID = the numeric id of the configuration to use
%
% OUTPUT:
%   directory: a string representing the path to the staging directory
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function directory = get_staging_directory(scenarioID, configurationID)

    slash = '/';
    if (ispc); slash = '\'; end 

    directory = 'staging';
    if (~exist(directory, 'dir')); mkdir(directory); end

    directory = strcat(directory,slash,num2str(configurationID));
    if (~exist(directory, 'dir')); mkdir(directory); end

    directory = strcat(directory,slash,num2str(scenarioID));
    if (~exist(directory, 'dir')); mkdir(directory); end
    
    directory = strcat(directory,slash);

end