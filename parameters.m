function params = parameters()
    % OFDM Parameters
    params.N_subcarriers = 64;       % Number of OFDM subcarriers
    params.N_Tx = 4;
    params.N_Rx = 1;
    params.Tx = [0, 0];             % Transmitter coordinates
    params.Rx = [4, 0];              % Receiver coordinates
    params.N_targets = 1;
    params.Targets = [2, -3; 2, -3]; % Target object coordinates
    params.N_signals = params.N_targets + 1;
    params.f_c = 24e9;              % Carrier frequency (Hz)
    params.c = 3e8;                  % Speed of light (m/s)
    % Simulation Parameters
    params.SNR = 20;                 % Signal to noise ratio in dB
    params.packet_length = 50;       % Length of OFDM packets (number of symbols)
    params.Fs = 8000;                % Sampling frequency in Hz、
    params.Bandwidth = 125e6;
    params.lambda = params.c / params.f_c;
    params.antenna_distance = 0.5;

    params.search_space_aoa = 360;
    params.search_space_tof = 500;
end
