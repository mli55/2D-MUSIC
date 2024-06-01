function main_simulation()
% ----------------------------------------------
% Main simulation. 
% Inputs: None
% Outputs: None
% ----------------------------------------------

clear;
close all;

% Set boolean variable flag
flag = false;  % Use simulation data
flag = true;   % Use real data

params = parameters();
    
if flag == 0 % Simulation
    [delays, ~] = path_delays(params);
    angles = target_orientations(params);
    received_data = receive_data_simulation(params, delays, angles);
else % Real
    reshaped_data = load('./receiver_200.mat').reshapedData;
    received_data = squeeze(reshaped_data(1:50, :, :, :));
    received_data = permute(received_data, [3, 2, 1]);
end

received_data = pdd_remove(params, received_data);
received_aoa = squeeze(received_data(1, :, :));
received_tof = squeeze(received_data(:, 1, :));

combined_matrix = reshape(received_data, params.N_subcarriers * params.N_Tx, params.packet_length);

estimate_aoa_music(received_aoa, params);
estimate_tof_music(received_tof, params);
music_2d(combined_matrix, params);

end
