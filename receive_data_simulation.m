function received_data = receive_data_simulation(params, delays, angles)
% ----------------------------------------------
% Simulates received data using delays and angles
% Inputs:
%   - params
%   - delays [params.N_signals, 1]
%   - angles [params.N_signals, 1]
% Outputs:
%   - received_data [params.N_subcarriers, params.N_Tx, params.packet_length]
% ----------------------------------------------

f_sub = params.Bandwidth / params.N_subcarriers;  % Subcarrier frequency interval
delta_f_list = (0:params.N_subcarriers-1)' * f_sub;  % Frequency interval sequence


transmitted_data = (randn(params.N_signals, params.N_packets) + ...
    1i*randn(params.N_signals, params.N_packets))/sqrt(2);
signal_from_paths = zeros(params.N_subcarriers, params.N_Tx, params.N_packets, params.N_signals);

for i = 1:params.N_signals
    tof = delta_f_list * delays(i); % Time of Flight
    
    % Merge ToF and AoA
    tmp1 = exp(-1i * 2 * pi * tof);
    spatial = array_response(params, angles(i), 'truth');
    tmp = zeros(params.N_subcarriers, params.N_Tx, params.N_packets);
    for j = 1:params.N_packets
        tmp(:, :, j) = tmp1 * spatial.' * transmitted_data(i, j);
    end

    % if i ~= 1
    %     tmp = tmp * 0.3;
    % end
    signal_from_paths(:, :, :, i) = tmp;
end
received_data = sum(signal_from_paths, 4);
noise_power = mean(abs(received_data(:)).^2) / 10^(params.SNR/10);
received_data = received_data + sqrt(noise_power/2) * ...
    (randn(size(received_data)) + 1i*randn(size(received_data)));

% Add path delay
for k = 1:params.N_packets
    t_pdd = (100e-9 - 10e-9).*rand + 10e-9;
    t_pdd = 0;
    for i = 1:params.N_subcarriers
        received_data(i, :, k) = exp(-1i * 2 * pi * delta_f_list(i) * t_pdd) .* received_data(i, :, k);
    end
end
end