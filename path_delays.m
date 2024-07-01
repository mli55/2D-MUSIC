function [delays, path_losses] = path_delays(params)
% ----------------------------------------------
% Calculates the direct and reflected path delays
% Inputs:
%   - params
% Outputs:
%   - delays [1 + params.N_targets, 1]
%   - path_losses [1 + params.N_targets, 1] (empty for now)
% ----------------------------------------------

% Direct path distance
d_direct = norm(params.Tx - params.Rx);

% Initialize reflection path delays
reflect_delays = zeros(1, params.N_targets);

disp('Path differences (m):');
% Calculate distances and delays for each reflection path
for i = 1:params.N_targets
    target = params.Targets(i, :);
    d_reflect = norm(params.Tx - target) + norm(target - params.Rx);
    reflect_delays(i) = d_reflect / params.c;
    disp(d_reflect - d_direct);
end

if params.flag_same_side == 0 % Combine direct path and reflection path delays
    delays = [d_direct / params.c; reflect_delays'];
else
    delays = reflect_delays';
end

disp('Theoretical path lengths (m):');
disp(delays * 3e8);

% Initialize path losses (empty for now)
path_losses = [];
end
