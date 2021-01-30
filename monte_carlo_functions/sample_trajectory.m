%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DESCRIPTION: Generates one sample trajectory, pond dynamics
% INPUT:
    % x0 : initial state, real number
    % tick_P = [ 0, P(1), P(1)+P(2), ..., P(1)+...+P(nw-1), 1 ], nw = length(ws)
        % P(i) : probability that wk = ws(i)
    % muInterpolants : a vector of N cells containing gridded interpolant of 
        % the optimal policy for each timestep
    % globals
    %   scenario struct 
    %   config struct 
    %   ambient struct 
% OUTPUT:
    % myTraj(1) = x0, myTraj(2) = x1, ..., myTraj(N+1) = xN
    % myConf(1) = l0, myConf(2) = l1, ..., myConf(N+1) = lN
    % myCtrl(1) = u1, myCtrl(2) = u2, ..., myCtrl(N) = uN
    % myCost(1) = cost(x0); myCost(2) = cost(x2); ..., myCost(N+1) = cost(xN)
% If xk+1 > max(xs), we set xk+1 = max(xs). This ensures that scenario tree is equivalent to that used in dynamic programming.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [myTraj, myCtrl, myCosts] = sample_trajectory( x0, tick_P, muInterpolants, scenario, config, ambient )       

N = config.T/config.dt;

myCtrl = zeros(N, 1); 
myCosts = [ scenario.cost_function(x0, scenario) ; zeros(N, 1)];

if scenario.dim == 1
    myTraj = [ x0; zeros(N, 1) ];                                 % initialize trajectory 
else    
    myTraj = [ x0; zeros(N, 2) ];
end

for k = 0 : N-1                                                    % for each time point
    
    xk = myTraj(k+1,:);                                            % state at time k
        
    wk = sample_disturbance(scenario.ws, tick_P );                 % sample the disturbance at time k according to P

    if scenario.dim == 1
            u = muInterpolants{k+1}(xk(1));
    elseif scenario.dim == 2                                     
            u = muInterpolants{k+1}(xk(2), xk(1));
    else
        error('scenario.dim not defined properly!');
    end
    
    if u > 1
        u = 1; 
    end
    
    if u < 0
        u = 0; 
    end
    
    myCtrl(k+1) = u; 
                                                                % get next state realization
    x_kPLUS1 = scenario.dynamics(xk, u, wk, config, scenario);
                                                                
    x_kPLUS1 = snap_to_boundary( x_kPLUS1, ambient );               % snap to grid on boundary
    
    myTraj(k+2,:) = x_kPLUS1;                                   % state at time k+1
    
    myCosts(k+2) = scenario.cost_function(x_kPLUS1, scenario);  % stage cost at time k+1
     
end