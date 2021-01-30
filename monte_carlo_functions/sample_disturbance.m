%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DESCRIPTION: Samples the disturbance at time k according to P
% INPUT:
    % ws(i) : ith possible value of wk
    % tick_P = [ 0, P(1), P(1)+P(2), ..., P(1)+...+P(nw-1), 1 ], nw = length(ws)
        % P(i) : probability that wk = ws(i)
 % OUTPUT:
    % wk : realization of the disturbance at time k
 % AUTHOR: Margaret Chapman
 % DATE: September 6, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function wk = sample_disturbance( ws, tick_P )

nw = length(ws);                           % number of possible values of wk

myrand = rand(1);                          % pseudorandom value drawn from the standard uniform distribution on (0,1)

for i = 1 : nw
    
    if myrand > tick_P(i) && myrand <= tick_P(i+1)
        
        wk = ws(i);
        
    end
    
end
