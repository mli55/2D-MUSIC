function received_data = receive_aoa(params)

    theta = [0 60] * pi / 180;
    signal_num = length(theta);

    sequence = (0:params.antenna_distance:(params.N_antenna - 1) * params.antenna_distance)';
    
    % 计算每个延迟的相位因子
    phi_theta = exp(-1i * 2 * pi / params.lambda * params.packet_length * sequence * sin(theta));
    
    % 生成单行传输数据
    transmitted_data = randn(signal_num, params.packet_length);

    received_data = phi_theta * transmitted_data;

    received_data = awgn(received_data, params.SNR, 'measured');
end
