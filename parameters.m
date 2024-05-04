function params = parameters()
    % OFDM Parameters
    params.N_subcarriers = 64;       % Number of OFDM subcarriers
    params.Tx = [0, 0];             % Transmitter coordinates
    params.Rx = [3, 0];              % Receiver coordinates
    params.Target1 = [2, 2.7];          % Target object coordinates
    params.Target2 = [1.5, 3];          % Target object coordinates
    params.N_targets = 1;
    params.N_signals = params.N_targets + 1;
    params.f_c = 2.4e9;              % Carrier frequency (Hz)
    params.c = 3e8;                  % Speed of light (m/s)
    % Simulation Parameters
    params.SNR = 20;                 % Signal to noise ratio in dB
    params.packet_length = 1;       % Length of OFDM packets (number of symbols)
    params.Fs = 8000;                % Sampling frequency in Hz、
    params.Bandwidth = 125e6;
    params.lambda = params.c / params.f_c;
    params.N_antenna = 4; % for aoa
    params.antenna_distance = 0.15;
end
