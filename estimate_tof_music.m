function [delta_delays] = estimate_tof_music(received_data, params)
    % 计算协方差矩阵

    R = (received_data * received_data') / size(received_data, 2);

    % 特征值分解
    [E, D] = eig(R);
    eigenvalues = diag(D);
    [~, index] = sort(eigenvalues, 'descend');
    E = E(:, index);

    % 分离噪声子空间
    if size(E, 2) < params.N_signals
        error('Not enough eigenvalues/vectors to separate the signal and noise subspaces.');
    end
    noise_subspace = E(:, params.N_signals+1:end);
    
    % 获取路径延迟
    f_sub = params.Bandwidth / params.N_subcarriers;  % 子载波间隔频率
    delta_f_list = (0:params.N_subcarriers-1)' * f_sub;  % 根据子载波间隔频率计算序列
    
    % 初始化Omega_tau矩阵并计算
    tau_list = linspace(-5e-8, 5e-8, params.search_space_tof)';  % 延迟列表
    Omega_tau = exp(-1i * 2 * pi * delta_f_list * tau_list');
    sv_projection = abs(noise_subspace' * Omega_tau).^2;
    P_music = 1 ./ sum(sv_projection, 1);  % 计算倒数并取绝对值
    P_MUSIC_max = max(P_music);
    P_music = 10*log10(P_music/P_MUSIC_max);

    % 提取MUSIC谱的峰值
    [P_peaks, P_peaks_idx] = findpeaks(P_music);

    % 提取最大的两个峰值
    [P_peaks_sorted, I] = sort(P_peaks, 'descend');

    P_peaks_idx = P_peaks_idx(I);
    P_peaks = P_peaks_sorted(1:params.N_signals);             % 提取前M个
    P_peaks_idx = P_peaks_idx(1:params.N_signals);
    sort(tau_list(P_peaks_idx));
    % disp(1e9*abs(tau_list(P_peaks_idx(2)) - tau_list(P_peaks_idx(1))));
    delta_delays = abs(tau_list(P_peaks_idx(1)) - tau_list(P_peaks_idx(2:end)));
    % disp(tau_list(P_peaks_idx));
    delays = tau_list(P_peaks_idx);
    % P_music = P_music - P_music(1);

    % 绘图
    figure; % 创建新的图形窗口
plot(tau_list*3e8, P_music); % 绘制整个频谱
hold on; % 保持图像，以便在同一图上添加新图层

% 找到最大的 params.N_Signals 个点
[~, P_peaks_idx] = maxk(P_music, params.N_signals); % 获取最大值的索引
P_peaks = P_music(P_peaks_idx); % 获取最大值

% 标记这些最大点
plot(tau_list(P_peaks_idx)*3e8, P_peaks, 'r.', 'MarkerSize', 25); % 使用红色圆圈标记

% 添加标题和轴标签
title('MUSIC Spectrum');
xlabel('Delay (meter)');
ylabel('P(tau)');

% 添加图例
legend('Spectrum', 'Peaks');

hold off; % 释放图像

disp('估计路径长度（m）：');
disp(tau_list(P_peaks_idx)*3e8);

end
