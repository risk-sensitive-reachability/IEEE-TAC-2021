%% Investigates "fat" tail condition in Section III

close all; clearvars; clc;

mysigma = 2;

mymu = 0;

% 2926
variance_log_normal = (exp(mysigma^2) - 1) * exp(2 * mymu + mysigma^2);

% 7.390
mean_log_normal =  exp(mymu + (mysigma^2)/2);

pd = makedist('Lognormal','mu',mymu,'sigma',mysigma);

x = (.001:1:200)';
y = pdf(pd,x);
plot(x,y);

myalpha = 0.05;

rng('default');  % For reproducibility
samples = random(pd,1000000,1);

histogram(samples)

% 7.4347
myempiricalmean = mean(samples);

% 2659
myempiricalvar = var(samples);

% 26.8454
quantile(samples, 1-myalpha) % VaR_{myalpha}(Y), 5% of samples are above this value

% 0.0374
quantile(samples, myalpha) % VaR_{1-myalpha}(Y), 95% of samples are above this value

%%
deltaP = 0.00001;

lower_int_limits = 0:deltaP:(1-myalpha);

upper_int_limits = (1-myalpha):deltaP:1;

lower = 0;
upper = 0;

for i = 1 : length(lower_int_limits)
   
    % print progress
    if mod(i,100) == 0
        disp(strcat('LowerLimitProgress: ', mat2str(i), {' out of '}, mat2str(length(lower_int_limits))))
    end
    
    lower = lower + quantile(samples, lower_int_limits(i)) * deltaP; 
    % approx. lower + VaR_{1-lower_int_limits(i)}(Y)
    % sum from lower_int_limits(i) = 0 to lower_int_limits(i) = 1-alpha
end

for i = 1 : length(upper_int_limits)
    
    upper = upper + quantile(samples, upper_int_limits(i)) * deltaP;
    % approx. upper + VaR_{1-upper_int_limits(i)}(Y)
    % sum from upper_int_limits(i) = 1-alpha to upper_int_limits(i) = 1
    
end

upper/lower

% upper/lower = 4.82 / 2.67 = m ~ 1.8051
% compare with numerical solution from Mathematica, which gives m ~ 1.7682
% Integrate[InverseCDF[LogNormalDistribution[0, 2], q], {q, 0.95, 1}]/
% Integrate[InverseCDF[LogNormalDistribution[0, 2], q], {q, 0, 0.95}]