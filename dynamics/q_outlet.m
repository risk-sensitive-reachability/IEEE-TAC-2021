%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PURPOSE: Computes outflow through an orifice using orifice equation
% INPUT:
    %x = pond stage vector measured from pond base [ft]
    %u = valve setting vector, a proportion   
    %R = outlet radius [ft]
    %Z = outlet invert elevation [ft]
% OUTPUT: Outflow vector [ft^3/s]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function q = q_outlet(x, u, R, Z)

	Cd = 0.61;  % discharge coefficient
	g = 32.2;   % acceleration due to gravity [ft/s^2]

	q_forBigX = (Cd*pi*R^2) .* u .* sqrt( (2*g) .* (x-Z) );

	q_forSmallX = 0;

	q = ( x >= Z ).*q_forBigX + ( x < Z ).*q_forSmallX;

end