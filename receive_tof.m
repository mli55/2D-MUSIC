function received_data = receive_tof(params, delays, transmitted_data)
    
    f_sub = params.Bandwidth / params.N_subcarriers;  % 子载波间隔频率
    delta_f_list = (0:params.N_subcarriers-1)' * f_sub;  % 根据子载波间隔频率计算序列
    
    % PDD
    t = (100e-9 - 10e-9).*rand + 10e-9;
    t = 0;

    % 初始化Omega_tau矩阵
    
    % Omega_tau = exp(-1i * 2 * pi * delta_f_list * (delays));
    Omega_tau = exp(-1i * 2 * pi * delta_f_list * (delays + t));
    Omega_tau(:, 2) = Omega_tau(:, 2)*0.6;
    received_data = repmat(transmitted_data, params.N_signals, 1);
    received_data = Omega_tau * received_data;
    received_data = awgn(received_data, params.SNR, "measured");
    % received_data = sum(received_data, 2);
end
