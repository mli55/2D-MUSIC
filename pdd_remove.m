function corrected_csi = pdd_remove(raw_csi, params)
    % pdd_remove函数用于消除PDD引起的误差。
        
    % 计算STO的线性拟合。
    f_sub = params.Bandwidth / params.N_subcarriers;  % 子载波间隔频率
    delta_f_list = (0:f_sub:f_sub*(params.N_subcarriers-1))';
    corrected_csi = zeros(size(raw_csi));

    % 遍历每个数据包
    for i = 1:params.packet_length
        % 提取当前数据包的CSI相位
        packet_csi = raw_csi(:, i);
        unwrapped_phase = unwrap(angle(packet_csi));  % 解包裹相位
        
        % 定义代价函数
        cost_function = @(tau) sum((unwrapped_phase + 2 * pi * delta_f_list * tau).^2);
    
        % 初始化参数 rho 的估计
        tau_estimate = 0;
    
        % 使用 fminsearch 寻找最小化代价函数的 rho 值
        options = optimset('Display', 'off');  % 关闭优化过程中的显示
        tau_estimate = fminsearch(cost_function, tau_estimate, options);

        % offset = 2 * pi * delta_f_list * 22e-9;
    % unwrapped_phase = unwrap(angle(received_data));
    % corrected_phase = unwrapped_phase + offset;
    % 
    %     % 构建修正后的CSI
    %     received_data = abs(received_data) .* exp(1i * corrected_phase);
        
        % 移除STO引起的相位变化
        % tau_estimate = 25e-9;
        sto_phase_offset = 2 * pi * delta_f_list * tau_estimate;
        corrected_phase = unwrapped_phase + sto_phase_offset;
        
        % 构建修正后的CSI
        corrected_csi(:,i) = abs(packet_csi) .* exp(1i * corrected_phase);
    end
    % disp(['estimated tau=', num2str(tau_estimate)]);
end
