function [P_music, peak_angles, peak_distances] = music_2d(received_data, params)
% ----------------------------------------------
% 2D MUSIC algorithm to estimate AoA and ToF
% Inputs:
%   - received_data [params.N_subcarriers * params.N_Tx, params.packet_length]
%   - params
% Outputs:
%   - Heatmap (x-axis: angles, y-axis: distances)
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
    error('Not enough eigenvalues/eigenvectors to separate signal and noise subspace.');
end
noise_subspace = E(:, params.N_signals+1:end);

% Setup parameters for phi and tau
phi_list = linspace(-pi/2, pi/2, params.search_space_aoa)'; % aoa
tau_list = linspace(-5e-8, 5e-8, params.search_space_tof)'; % tof

[Phi, Tau] = meshgrid(phi_list, tau_list); 
Phi = reshape(Phi, numel(Phi), 1); 
Tau = reshape(Tau, numel(Tau), 1); % aoa [10e6*1] tof [10e6*1]

% Calibrated spatial manifold, without transforming (coloring) the noise.
f_sub = params.Bandwidth / params.N_subcarriers;
f_list = repmat((0:params.N_subcarriers-1)' * f_sub, params.N_Tx, 1);
spatial = array_response(params, Phi*180/pi);
spatial = kron(spatial, ones(params.N_subcarriers, 1));
Omega_tau = spatial .* exp(-1i * 2*pi * f_list * Tau');
sv_projection = abs(noise_subspace' * Omega_tau).^2;
P_music = sum(abs(Omega_tau).^2, 1) ./ max(sum(sv_projection, 1), realmin);
P_MUSIC_max = max(P_music);
P_MUSIC_dB = 10*log10(P_music/P_MUSIC_max);
P_MUSIC_dB = P_music;
P_music = reshape(P_MUSIC_dB, params.search_space_tof, params.search_space_aoa); 

% Plot heatmap
if params.fig
figure; % Create new figure window
imagesc(phi_list*180/pi, tau_list*3e8, P_music); % Plot and convert to dB
colorbar; % Show color bar
xlabel('Angle (degrees)'); % X-axis label
ylabel('Path Length (meters)'); % Y-axis label
title('P_{MUSIC} Spectral Density'); % Title

% Adjust axis to match phi_list and tau_list range
set(gca, 'YDir', 'normal'); % Ensure Y axis is low to high
axis tight; % Adjust axis to fit data tightly
end

% Find local maxima
local_max = islocalmax(P_music, 1) & islocalmax(P_music, 2);
[peak_rows, peak_cols] = find(local_max);

% Extract peak values
peak_values = P_music(local_max);

% Sort and extract top params.N_signals peaks
[~, sorted_indices] = sort(peak_values, 'descend');
assert(numel(sorted_indices) >= params.N_signals, 'Too few local peaks for requested sources.');
peak_rows = peak_rows(sorted_indices(1:params.N_signals));
peak_cols = peak_cols(sorted_indices(1:params.N_signals));

% Initialize output variables
peak_angles = zeros(params.N_signals, 1);
peak_distances = zeros(params.N_signals, 1);

% Annotate peaks in the plot
if params.fig, hold on; end
for k = 1:params.N_signals
    angle = phi_list(peak_cols(k)) * 180 / pi;
    distance = tau_list(peak_rows(k)) * 3e8;
    peak_angles(k) = angle;
    peak_distances(k) = distance;

    if params.fig, plot(angle, distance, 'r.', 'MarkerSize', 15, 'LineWidth', 2); end
end
if params.fig, hold off; end

% Output angles and distances
disp('Found peaks:');
for k = 1:params.N_signals
    fprintf('Peak %d: Angle = %.2f degrees, Path Length = %.2f meters\n', k, peak_angles(k), peak_distances(k));
end
end
