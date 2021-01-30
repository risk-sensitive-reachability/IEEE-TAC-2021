%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DESCRIPTION: Snaps state transitions to the boundary of the state-space
% INPUTs: 
%	x_kPLUS1: the next state 
%	ambient struct 
% OUTPUTS: 
%	x_kPLUS1: the next state snapped to the boundary of the state-space
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function x_kPLUS1 = snap_to_boundary( x_kPLUS1, ambient )

	x_kPLUS1(x_kPLUS1 > ambient.xmax) = ambient.xmax(x_kPLUS1 > ambient.xmax);

	x_kPLUS1(x_kPLUS1 < ambient.xmin) = ambient.xmin(x_kPLUS1 < ambient.xmin);

end