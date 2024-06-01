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

d = params.antenna_distance * params.lambda;
delta_d_list = (0:d:(params.N_Tx - 1) * d)'; 
theta = angles * pi / 180;

transmitted_data = randn(1, params.packet_length);
signal_from_paths = zeros(params.N_subcarriers, params.N_Tx, params.packet_length, params.N_signals);

for i = 1:params.N_signals
    % Time of Flight (ToF)
    tof = delta_f_list * delays(i);
    % Angle of Arrival (AoA)
    aoa = delta_d_list * sin(theta(i)') / params.lambda;
    
    % Merge ToF and AoA
    tmp1 = exp(-1i * 2 * pi * tof);
    tmp2 = exp(-1i * 2 * pi * aoa);
    tmp = zeros(params.N_subcarriers, params.N_Tx, params.packet_length);
    for j = 1:params.packet_length
        tmp(:, :, j) = tmp1 * tmp2' * transmitted_data(j);
    end
    tmp = awgn(tmp, params.SNR, "measured");
    signal_from_paths(:, :, :, i) = tmp;
    if i ~= 1
        signal_from_paths = signal_from_paths * 0.3;
    end
end
received_data = sum(signal_from_paths, 4);

% Add path delay
t_pdd = (100e-9 - 10e-9).*rand + 10e-9;
t_pdd = 0;

for i = 1:params.N_subcarriers
    received_data(i, :, :) = exp(-1i * 2 * pi * delta_f_list(i) * t_pdd) * received_data(i, :, :);
end

end
