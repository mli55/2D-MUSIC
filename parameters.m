function params = parameters()
% ----------------------------------------------
% Defines and returns the simulation parameters
% Inputs:
%   - None
% Outputs:
%   - params: structure containing all the simulation parameters
% ----------------------------------------------


% ===============================
% Flag Parameters
% ===============================
params.flag_real_data = false;  % Use simulation data
params.flag_same_side = true; % Transceiver same side & syncrhonized

params.fig = false;

% ===============================
% Router and Target Implementation Parameters
% ===============================
params.N_Tx = 4;
params.N_Rx = 1;
params.Tx = [0, 0];             % Transmitter coordinates
params.Rx = [0, 0];             % Receiver coordinates
params.N_targets = 4;
params.Targets = [2, 3; 2, -3; 1, 2; 1,-2]; % Target object coordinates

if params.flag_same_side == 0
    params.N_signals = params.N_targets + 1;
else
    params.N_signals = params.N_targets;
end


% ===============================
% Data Search Space Parameters
% ===============================
params.search_space_aoa = 360; % angle space
params.search_space_tof = 500; % distance space

% ===============================
% Data Range Parameters
% ===============================
params.data_start_point = 1;
params.data_end_point = 2;
params.N_packets = 2;

% ===============================
% OFDM Parameters
% ===============================
params.N_subcarriers = 64;       % Number of OFDM subcarriers
params.f_c = 24e9;              % Carrier frequency (Hz)

% ===============================
% Physical Parameters
% ===============================
params.c = 3e8;                 % Speed of light (m/s)
params.lambda = params.c / params.f_c;
params.antenna_distance = 0.5;

% ===============================
% Simulation Parameters
% ===============================
params.SNR = 20;                 % Signal to noise ratio in dB
params.Fs = 8000;                % Sampling frequency in Hz
params.Bandwidth = 125e6;

end
