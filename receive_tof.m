function received_data = receive_tof(params, delays)
    
    f_sub = params.Bandwidth / params.N_subcarriers;  % 子载波间隔频率
    delta_f_list = (0:params.N_subcarriers-1)' * f_sub;  % 根据子载波间隔频率计算序列
   
    
    % 生成单行传输数据
    transmitted_data = randn(1, params.packet_length);

    % 传输数据是一个 n条路径 x packet_length 的矩阵，n行相同
    received_data = repmat(transmitted_data, params.N_signals, 1);
    
    % PDD
    t = (100e-9 - 10e-9).*rand + 10e-9;

    % 初始化Omega_tau矩阵

    % Omega_tau = exp(-1i * 2 * pi * delta_f_list * (delays));
    Omega_tau = exp(-1i * 2 * pi * delta_f_list * (delays + t));

    tmp = received_data;
    received_data = Omega_tau .* tmp';
    received_data = awgn(received_data, params.SNR, "measured");
    received_data = sum(received_data, 2);
    
    % offset = 2 * pi * delta_f_list * 22e-9;
    % unwrapped_phase = unwrap(angle(received_data));
    % corrected_phase = unwrapped_phase + offset;
    % 
    %     % 构建修正后的CSI
    %     received_data = abs(received_data) .* exp(1i * corrected_phase);
    % disp(t);
end
