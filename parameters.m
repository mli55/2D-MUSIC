function params = parameters()
% ----------------------------------------------
% Defines and returns the simulation parameters
% Inputs:
%   - None
% Outputs:
%   - params: structure containing all the simulation parameters
% ----------------------------------------------

% OFDM Parameters
params.N_subcarriers = 64;       % Number of OFDM subcarriers
params.N_Tx = 4;
params.N_Rx = 1;
params.Tx = [0, 0];             % Transmitter coordinates
params.Rx = [4, 0];              % Receiver coordinates
params.N_targets = 1;
params.Targets = [2, 3; 2, -3]; % Target object coordinates
params.N_signals = params.N_targets + 1;
params.f_c = 24e9;              % Carrier frequency (Hz)
params.c = 3e8;                 % Speed of light (m/s)

% Simulation Parameters
params.SNR = 20;                 % Signal to noise ratio in dB
params.Fs = 8000;                % Sampling frequency in Hz
params.Bandwidth = 125e6;
params.lambda = params.c / params.f_c;
params.antenna_distance = 0.5;

params.search_space_aoa = 360;
params.search_space_tof = 500;

params.data_start_point = 20;
params.data_end_point = 40;
params.N_packets = params.data_end_point - params.data_start_point + 1;       % Length of OFDM packets (number of symbols)
% params.N_packets = 1;
end
