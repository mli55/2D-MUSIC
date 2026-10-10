function demo_array_calibration()
% Known-calibration benchmark, not a claim of blind/self calibration.
rng(7);
p = parameters();
p.N_Tx = 6; p.N_signals = 1; p.N_packets = 300;
p.N_subcarriers = 16; p.SNR = 30; p.fig = false;
p.search_space_aoa = 181; p.search_space_tof = 201;
angles = 20; delays = 15e-9;
C = eye(p.N_Tx);
for k = 1:p.N_Tx-1
    C(k,k+1) = 0.12*exp(1i*pi/6); C(k+1,k) = C(k,k+1);
end
p.array_truth = struct('gain', [1;.9;1.1;.85;1.05;.95], ...
    'phase_deg', [0;15;30;45;60;75], 'coupling', C, ...
    'position_error_lambda', [0;.02;-.03;.01;-.02;.03]);
X = receive_data_simulation(p, delays, angles);
X = reshape(X, p.N_subcarriers*p.N_Tx, p.N_packets);
[~, theta0, range0] = music_2d(X, p);
p.array_calibration = p.array_truth; % Oracle benchmark for measured parameters.
[~, theta1, range1] = music_2d(X, p);
fprintf('True: %.1f deg, %.2f m\n', angles, delays*p.c);
fprintf('Uncalibrated: %.1f deg, %.2f m\n', theta0, range0);
fprintf('Calibrated: %.1f deg, %.2f m\n', theta1, range1);
assert(abs(theta1-angles) <= 1, 'Calibrated angle error exceeds one grid step.');
assert(abs(range1-delays*p.c) <= .15+1e-10, 'Calibrated delay error exceeds one grid step.');
% Verify known-direction combined matrix fitting separately (nominal positions).
p.array_truth = rmfield(p.array_truth, 'position_error_lambda');
cal_angles = [-60 -40 -20 0 20 40 60];
B = array_response(p, cal_angles, 'truth');
p.array_calibration = estimate_array_calibration(p, cal_angles, B);
Bfit = array_response(p, cal_angles);
assert(norm(B-Bfit,'fro')/norm(B,'fro') < 1e-10, 'Calibration fit failed.');
end
