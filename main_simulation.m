function main_simulation()
% ----------------------------------------------
% Main simulation. 
% Inputs: None
% Outputs: None
% ----------------------------------------------

clear;
close all;


params = parameters();



    
if params.flag_real_data == 0 % Simulation
    [delays, ~] = path_delays(params);
    angles = target_orientations(params);
    received_data = receive_data_simulation(params, delays, angles); % [subcarrier, Tx, packets]
else % Real
    reshaped_data = load('radar_200.mat').reshapedData; %[packets, Tx, Rx, subcarrier]
    received_data = squeeze(reshaped_data(params.data_start_point:params.data_end_point, :, 1, :)); %[packets, Tx, Subcarrier]
    received_data = permute(received_data, [3, 2, 1]); % [Subcarrier, Tx, packets]
end
params.N_packets = size(received_data, 3);

% Optional common packet-delay alignment; not per-sensor calibration.
if params.align_packet_delays
    packet_delays = zeros(params.N_packets, 1);
    for i = 1:params.N_packets
        peaks = estimate_tof_music(received_data(:, :, i), params, false);
        packet_delays(i) = peaks(1);
    end
    frequencies = (0:params.N_subcarriers-1)' * params.Bandwidth / params.N_subcarriers;
    for i = 2:params.N_packets
        dt = packet_delays(i) - packet_delays(1);
        received_data(:, :, i) = received_data(:, :, i) .* exp(1i*2*pi*frequencies*dt);
    end
end

combined_matrix = reshape(received_data, params.N_subcarriers * params.N_Tx, params.N_packets);

if params.N_signals < params.N_Tx
    estimate_aoa_music(reshape(received_data(6,:,:), params.N_Tx, []), params);
end
music_2d(combined_matrix, params);

end
