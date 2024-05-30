function main_simulation()
clear;
close all;

% 设置布尔变量 flag
flag = false;  % 表示使用仿真数据
% flag = true;  % 表示使用真实数据
params = parameters();

transmitted_data = randn(1, params.packet_length);
% transmitted_data = 1;
    
    if flag == 0 % 仿真
        [delays, ] = path_delays(params);
        angles = target_orientations(params);
        received_aoa = receive_aoa(params, angles, transmitted_data);
        received_tof = receive_tof(params, delays, transmitted_data);
        % received_tof = pdd_remove(received_tof, params);  % 消除PDD
        % tmp = received_aoa .* received_tof';% [4*64]
        % tmp = received_tof .* received_aoa';% [N_subcarriers*N_Tx*packet_length]

        if size(received_tof, 2) ~= size(received_aoa, 2)
            error('两个矩阵的第二维度必须相同');
        end

        % 将 received_tof 和 received_aoa reshape 成 3D 矩阵
        tof_reshaped = reshape(received_tof, 64, 1, 200); % 变成 64x1x200
        aoa_reshaped = reshape(received_aoa, 1, 4, 200);  % 变成 1x4x200
        
        % 通过 bsxfun 进行广播操作
        combined_matrix = bsxfun(@times, tof_reshaped, aoa_reshaped);

        estimate_aoa_music(received_aoa, params);

   
        estimate_tof_music(received_tof, params);
    
    
        combined_matrix = reshape(combined_matrix, params.N_subcarriers * params.N_Tx, params.packet_length);
    else % Real
        reshaped_data = load('./receiver_200.mat').reshapedData;
        received_tof = reshaped_data(150, 1, 1, :);
        received_tof = squeeze(received_tof);
        received_tof = pdd_remove(received_tof, params);  % 消除PDD
        estimate_tof_music(received_tof, params);
    
    
        received_aoa = reshaped_data(150, :, 1, 7);
        received_aoa = squeeze(received_aoa);
        [phi_index] = estimate_aoa_music(received_aoa, params);

    % received_data = reshaped_data(150, :, 1, :);
    % received_data = squeeze(received_data);
    % received_data = reshape(received_data, numel(received_data), 1);


  
    tmp = received_aoa * received_tof';
    received_data = reshape(tmp, numel(tmp), 1);
    end
    music_2d(combined_matrix, params);


    % Real
    % 

end


% 
% 5/28
% [1] 1. simulation和real分开两份
% [] 2. 多组数据验证>5 加噪
% [] 3. packet分组，联合谱图
% [1] 4. 模拟加速度
% [] 5. 实验自发自收