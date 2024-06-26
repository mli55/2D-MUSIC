function corrected_csi = pdd_remove_test(params, raw_csi)
% ----------------------------------------------
% Removes PDD-induced errors from raw CSI
% Inputs:
%   - params
%   - raw_csi [subcarrier, Tx, packets]
% Outputs:
%   - corrected_csi [subcarrier, Tx, packets]
%
% Reference
%   - @SpotFi
% ----------------------------------------------

% Compute subcarrier frequency interval
f_sub = params.Bandwidth / params.N_subcarriers;  
delta_f_list = 0:f_sub:f_sub*(params.N_subcarriers-1);
% 展平并重复 delta_f_list
delta_f_list_flat = repmat(delta_f_list', params.N_Tx * params.N_packets, 1);  % 重复 N_Tx 次
% delta_f_list_flat = kron(delta_f_list', ones(params.N_Tx, 1));  % 每个元素重复 N_Tx 次
corrected_csi = zeros(size(raw_csi));

% Iterate through each packet
% for k = 1:params.N_packets
    % 提取当前 packet 的所有天线和子载波的 CSI 相位
    packet_csi = squeeze(raw_csi(:, :, :));  
    unwrapped_phase = unwrap(angle(packet_csi), [], 1);  % 沿子载波维度展开相位

    % 将展开的相位矩阵展平为向量
    unwrapped_phase_vector = unwrapped_phase(:);
    
    % 定义成本函数
    cost_function = @(tau) sum((unwrapped_phase_vector + 2 * pi * delta_f_list_flat * tau).^2);
    
    % 初始化 tau 估计值
    tau_estimate = 0;
    
    % 找到使成本函数最小的 tau
    options = optimset('Display', 'off');  % 关闭优化显示
    tau_estimate = fminsearch(cost_function, tau_estimate, options);
    
    % 应用相位校正
    sto_phase_offset = 2 * pi * delta_f_list * tau_estimate;
    sto_phase_offset = repmat(sto_phase_offset, params.N_Tx, 1);  % 重复 N_Tx 次
    corrected_phase = unwrapped_phase + sto_phase_offset';

    % 构建校正后的 CSI
    corrected_csi(:, :, :) = abs(packet_csi) .* exp(-1i * corrected_phase);
% end
end