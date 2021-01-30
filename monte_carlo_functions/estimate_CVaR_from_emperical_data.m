%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DESCRIPTION: Estimate CVaR from empirical data
% INPUT:
    % Z(i): ith sample of random variable Z
    % y: confidence level
    % var: approx. VaR_y[Z] using the empirical distribution of Z
% OUTPUT:
    % approx. CVaR_y[Z] using the empirical distribution of Z
% NOTE:
    % Uses esimator provided by Shapiro's text
    % Sec. 6.5.1 Average Value-at-Risk, p. 300, Lectures on Stochastic Programming Modeling and Theory, 2009, SIAM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function cvar = estimate_CVaR_from_emperical_data( Z, y, var )

ind = (Z >= var);       % ind(i) = 1 if Z(i) >= var
                                 % ind(i) = 0 if Z(i) < var
N = length(Z);           % number of samples of Z

if y == 0 
    cvar = max(Z); 
else 
    cvar = var + sum((Z-var).*ind) / (y*N);
end
