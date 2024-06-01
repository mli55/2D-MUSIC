function received_data = receive_aoa(params, angles, transmitted_data)
    d = params.antenna_distance * params.lambda;
    theta = angles * pi / 180;

    delta_d_list = (0:d:(params.N_Tx - 1) * d)'; 
    
    % 计算每个延迟的相位因子
    phi_theta = exp(-1i * 2 * pi * delta_d_list * sin(theta') / params.lambda);
    phi_theta(:, 2) = phi_theta(:, 2)*0.6;
    
    
    % 生成单行传输数据
    % transmitted_data = -1.8054;
    
    received_data = repmat(transmitted_data, params.N_signals, 1);
    received_data = phi_theta * received_data;
    % received_data = sum(received_data, 2);

    received_data = awgn(received_data, params.SNR, 'measured');
end