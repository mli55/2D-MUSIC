function main_simulation()
clear;
close all;

% 设置布尔变量 flag
flag = false;  % 表示使用仿真数据
flag = true;  % 表示使用真实数据

params = parameters();
    
    if flag == 0 % 仿真
        [delays, ] = path_delays(params);
        angles = target_orientations(params);
        received_data = receive_data_simulation(params, delays, angles);
    else % Real
        reshaped_data = load('./receiver_200.mat').reshapedData;
        received_data = squeeze(reshaped_data(1: 50, :, :, :));
        received_data = permute(received_data, [3, 2, 1]);
    end


    received_data = pdd_remove(params, received_data);
    received_aoa = squeeze(received_data(1, :, :));
    received_tof = squeeze(received_data(:, 1, :));

    combined_matrix = reshape(received_data, params.N_subcarriers * params.N_Tx, params.packet_length);

    estimate_aoa_music(received_aoa, params);
    estimate_tof_music(received_tof, params);
    music_2d(combined_matrix, params);

end


% 
% 5/28
% [1] 1. simulation和real分开两份
% [] 2. 多组数据验证>5 加噪
% [] 3. packet分组，联合谱图
% [1] 4. 模拟加速度
% [] 5. 实验自发自收