function [P_peaks_idx] = estimate_tof_music(received_data, params, fig)
% ----------------------------------------------
% Estimates Time of Flight (ToF) using MUSIC algorithm
% Inputs:
%   - received_data [params.packet_length, params.N_subcarriers]
%   - params
% Outputs:
%   - delta_delays [params.N_signals-1, 1]
%   - Plot of MUSIC Spectrum (x-axis: Delay in meters, y-axis: P(tau))
% ----------------------------------------------

% Compute covariance matrix
R = (received_data * received_data') / size(received_data, 2);

% Eigenvalue decomposition
[E, D] = eig(R);
eigenvalues = diag(D);
[~, index] = sort(eigenvalues, 'descend');
E = E(:, index);

% Separate noise subspace
if size(E, 2) < params.N_signals
    error('Not enough eigenvalues/vectors to separate the signal and noise subspaces.');
end
noise_subspace = E(:, params.N_signals+1:end);
    
% Get path delays
f_sub = params.Bandwidth / params.N_subcarriers;  % Subcarrier frequency interval
delta_f_list = (0:params.N_subcarriers-1)' * f_sub;  % Frequency interval sequence
    
% Initialize and compute Omega_tau matrix
tau_list = linspace(-5e-8, 5e-8, params.search_space_tof)';  % Delay list
Omega_tau = exp(-1i * 2 * pi * delta_f_list * tau_list');
sv_projection = abs(noise_subspace' * Omega_tau).^2;
P_music = 1 ./ sum(sv_projection, 1);  % Compute reciprocal and take absolute value
P_MUSIC_max = max(P_music);
P_music_dB = 10*log10(P_music/P_MUSIC_max);

% Extract peaks of MUSIC spectrum
[P_peaks, P_peaks_idx] = findpeaks(P_music_dB);  % Extract peaks
[P_peaks, I] = sort(P_peaks, 'descend');  % Sort peaks in descending order
P_peaks_idx = P_peaks_idx(I);
P_peaks = P_peaks(1:params.N_signals);  % Extract top N signals
P_peaks_idx = P_peaks_idx(1:params.N_signals);


% if fig
figure;
plot(tau_list*3e8, P_music_dB);
hold on;

% Mark the top N_Signals points
plot(tau_list(P_peaks_idx)*3e8, P_peaks, 'r.', 'MarkerSize', 25); % Mark with red circles

title('MUSIC Spectrum');
xlabel('Delay (meter)');
ylabel('P(tau)');
legend('Spectrum', 'Peaks');

hold off; 
P_peaks_idx = sort(P_peaks_idx);
disp('Estimated path lengths (m):');
disp(tau_list(P_peaks_idx)*3e8);
% end
P_peaks_idx = tau_list(P_peaks_idx);
end
