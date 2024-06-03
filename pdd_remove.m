function corrected_csi = pdd_remove(params, raw_csi)
% ----------------------------------------------
% Removes PDD-induced errors from raw CSI
% Inputs:
%   - params
%   - raw_csi [params.N_subcarriers, params.N_Tx, params.packet_length]
% Outputs:
%   - corrected_csi [params.N_subcarriers, params.N_Tx, params.packet_length]
% ----------------------------------------------

% Compute subcarrier frequency interval
f_sub = params.Bandwidth / params.N_subcarriers;  
delta_f_list = (0:f_sub:f_sub*(params.N_subcarriers-1))';
corrected_csi = zeros(size(raw_csi));

% Iterate through each packet
for k = 1:params.N_packets
    for i = 1:params.N_Tx
        % Extract CSI phase of the current packet
        packet_csi = raw_csi(:, i, k);
        unwrapped_phase = unwrap(angle(packet_csi));  % Unwrap phase
        
        % Define cost function
        cost_function = @(tau) sum((unwrapped_phase + 2 * pi * delta_f_list * tau).^2);
        
        % Initialize tau estimate
        tau_estimate = 0;
        
        % Find tau that minimizes the cost function
        options = optimset('Display', 'off');  % Turn off optimization display
        tau_estimate = fminsearch(cost_function, tau_estimate, options);
        
        sto_phase_offset = 2 * pi * delta_f_list * tau_estimate;
        corrected_phase = unwrapped_phase + sto_phase_offset;
        
        % Construct corrected CSI
        corrected_csi(:, i, k) = abs(packet_csi) .* exp(-1i * corrected_phase);
    end
end
end
