clc; clear; close all;

%% 参数设置
%%% 工作频率
c = 3e8;
freq = 10e9;
lambda = c/freq;    % 波长
k = 2*pi/lambda;    % 波数
%%% 阵列参数
N = 4;                 % 阵元数量
d = 0.5*lambda;         % 阵元间隔 
z = (0:d:(N-1)*d)';     % 阵元坐标分布
%%% 信号源参数
phi = [-10, 60]'*pi/180;   % 来波方向
M = length(phi);                % 信号源数目
%%% 仿真参数
SNR = 10;             % 信噪比(dB)
K = 1000;     % 采样点数

%% 阵列接收信号仿真模拟
S = exp(1j*k*z*sin(phi'));          % 流型矩阵
Alpha = randn(M, K);         % 输入信号
X = S*Alpha;                        % 阵列接收信号
X1 = awgn(X, SNR, 'measured');      % 加载高斯白噪声

%% MUSIC 算法
%%% 阵列接收信号的协方差矩阵的特征分解
R = X1*X1'/K;    % 阵列接收信号的协方差矩阵
[EV, D] = eig(R);       % 特征值分解
EVA = diag(D);          % 提取特征值
[EVA, I] = sort(EVA, 'descend');   % 降序排序
Q = EV(:, I);           % 特征向量构成的矩阵
Q_n = Q(:, M+1:N);      % 噪声子空间
%%% 计算MUSIC谱估计函数
phi_list = linspace(0, 100, 360)';
S1 = exp(1j*k*z*sin(phi_list'));    % 不同方向对应的流型矢量构成矩阵
P_MUSIC = 1./sum(abs(Q_n'*S1).^2);     % MUSIC 谱估计公式
%%% 转换为dB
P_MUSIC = abs(P_MUSIC);
P_MUSIC_max = max(P_MUSIC);
P_MUSIC_dB = 10*log10(P_MUSIC/P_MUSIC_max);
%%% 提取信号源方向
[P_peaks, P_peaks_idx] = findpeaks(P_MUSIC_dB);     % 提取峰值
[P_peaks, I] = sort(P_peaks, 'descend');    % 峰值降序排序
P_peaks_idx = P_peaks_idx(I);
P_peaks = P_peaks(1:M);             % 提取前M个
P_peaks_idx = P_peaks_idx(1:M);
phi_e = phi_list(P_peaks_idx)*180/pi;   % 估计方向
disp('信号源估计方向为：');
disp(phi_e);
%%% 绘图
figure;
plot(phi_list*180/pi, P_MUSIC_dB, 'k', 'Linewidth', 2);
xlabel('\phi (deg)');
ylabel('Pseudo-spectrum (dB)');
axis([-90, 90, -40, 0]);
grid on;
hold on;
plot(phi_e, P_peaks, 'r.', 'MarkerSize', 25);
hold on;
for idx = 1:M
    text(phi_e(idx)+3, P_peaks(idx), sprintf('%0.1f°', phi_e(idx)));
end