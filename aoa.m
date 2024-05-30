clear; close all;
%%%%%%%% MUSIC for Uniform Linear Array%%%%%%%%
derad = pi/180;      %角度->弧度
N = 4;               % 阵元个数        
M = 1;               % 信源数目
theta = [0 53.4711];  % 待估计角度
snr = 10;            % 信噪比
K = 1;             % 快拍数
 
dd = 0.5;            % 阵元间距 
d=0:dd:(N-1)*dd;
A=exp(-1i*2*pi*d.'*sin(theta*derad));  %方向矢量

%%%%构建信号模型%%%%%
S=-1.8054;             %信源信号，入射信号
X=A*S;                    %构造接收信号
% X1=awgn(X,snr,'measured'); %将白色高斯噪声添加到信号中
X1 = sum(X,2);
% 计算协方差矩阵
R=X1*X1'/K;
% 特征值分解
[EV,D]=eig(R);                   %特征值分解
EVA=diag(D)';                      %将特征值矩阵对角线提取并转为一行
[~,I]=sort(EVA);                 %将特征值排序 从小到大
EV=fliplr(EV(:,I));                % 对应特征矢量排序
                 
 
% 遍历每个角度，计算空间谱
for iang = 1:361
    angle(iang)=(iang-181)/2;
    phim=derad*angle(iang);
    a=exp(-1i*2*pi*d*sin(phim)).'; 
    En=EV(:,M+1:N);                   % 取矩阵的第M+1到N列组成噪声子空间
    Pmusic(iang)=1/(a'*En*En'*a);
end
Pmusic=abs(Pmusic);
Pmmax=max(Pmusic)
P_MUSIC_dB=10*log10(Pmusic/Pmmax); 


    % 提取最大的两个峰值
    [P_peaks, P_peaks_idx] = findpeaks(P_MUSIC_dB);     % 提取峰值
[P_peaks, I] = sort(P_peaks, 'descend');    % 峰值降序排序
P_peaks_idx = P_peaks_idx(I);
P_peaks = P_peaks(1:2);             % 提取前M个
P_peaks_idx = P_peaks_idx(1:2);
phi_e = angle(P_peaks_idx);   % 估计方向
disp('信号源估计方向为：');
disp(phi_e);
%%% 绘图
figure;
plot(angle, P_MUSIC_dB, 'k', 'Linewidth', 2);
xlabel('\phi (deg)');
ylabel('Spectrum');
grid on;
hold on;
plot(phi_e, P_peaks, 'r.', 'MarkerSize', 25);
hold on;
for idx = 1:2
    text(phi_e(idx)+3, P_peaks(idx), sprintf('%0.1f°', phi_e(idx)));
end