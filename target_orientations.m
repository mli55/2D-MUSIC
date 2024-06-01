function angles = target_orientations(params)
% ----------------------------------------------
% Calculates the angles from Tx to Rx and each target
% Inputs:
%   - params
% Outputs:
%   - angles [1 + params.N_targets, 1]
% ----------------------------------------------

% Initialize angles array
angles = zeros(1 + params.N_targets, 1);  % Store angles from Tx to Rx and each target

% Calculate angle from Tx to Rx
delta_x = params.Rx(1) - params.Tx(1);
delta_y = params.Rx(2) - params.Tx(2);
angles(1) = atan2(delta_y, delta_x);  % Store angle from Tx to Rx

% Calculate angles from Tx to each target
for k = 1:params.N_targets
    target = params.Targets(k, :);  % Access target coordinates dynamically

    % Calculate angle from Tx to current target
    delta_x = target(1) - params.Tx(1);
    delta_y = target(2) - params.Tx(2);
    angle_tx_to_target = atan2(delta_y, delta_x);
    angles(1 + k) = angle_tx_to_target;  % Store angle in array
end

% Convert angles from radians to degrees
angles = rad2deg(angles);

% Output angles
disp('Angles from Tx to Rx and each target (degrees):');
disp(angles);
end
