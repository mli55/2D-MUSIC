function corrected_csi = pdd_remove(params, raw_csi)
    % pdd_remove函数用于消除PDD引起的误差。
    
    % 计算STO的线性拟合。
    f_sub = params.Bandwidth / params.N_subcarriers;  % 子载波间隔频率
    delta_f_list = (0:f_sub:f_sub*(params.N_subcarriers-1))';
    corrected_csi = zeros(size(raw_csi));

    % 遍历每个数据包
    for k = 1:params.packet_length
        for i = 1:params.N_Tx
            % 提取当前数据包的CSI相位
            packet_csi = raw_csi(:, i, k);
            unwrapped_phase = unwrap(angle(packet_csi));  % 解包裹相位
            
            % 定义代价函数
            cost_function = @(tau) sum((unwrapped_phase + 2 * pi * delta_f_list * tau).^2);
        
            % 初始化参数 rho 的估计
            tau_estimate = 0;
        
            % 使用 fminsearch 寻找最小化代价函数的 rho 值
            options = optimset('Display', 'off');  % 关闭优化过程中的显示
            tau_estimate = fminsearch(cost_function, tau_estimate, options);
    
            sto_phase_offset = 2 * pi * delta_f_list * tau_estimate;
            corrected_phase = unwrapped_phase + sto_phase_offset;
            
            % 构建修正后的CSI
            corrected_csi(:,i, k) = abs(packet_csi) .* exp(-1i * corrected_phase);
        end
    end
end
