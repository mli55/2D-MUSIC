function main_simulation()
clear;
close all;

    params = parameters();
    
    % reshaped_data = load('./receiver_200.mat').reshapedData;
    % received_data = reshaped_data(100, 1, 1, :);
    % received_data = squeeze(received_data);

    [delays_theoretic, ] = path_delays(params);
    % disp('理论tof差值(ns)：');
    % disp(1e9*abs(delays_theoretic(1) - delays_theoretic(2:end)));

    received_data = receive_tof(params, delays_theoretic);
    % 
    delays_estimate_withpdd = estimate_paths_using_music(received_data, params);  % 使用MUSIC算法估计路径延迟
    % disp('未消除pdd(ns)：');
    % disp(1e9*delays_estimate_withpdd);
    
    received_data = pdd_remove(received_data, params);  % 消除PDD
    delays_estimate_withoutpdd = estimate_paths_using_music(received_data, params);  % 使用MUSIC算法估计路径延迟
    % disp('消除pdd(ns)：');
    % disp(1e9*delays_estimate_withoutpdd);

    disp('估算路径差的偏差(m)：')
    disp(abs(abs(delays_theoretic(1) - delays_theoretic(2:end)) - delays_estimate_withoutpdd)*3e8);

    % 将样本延迟转换为时间
    % [direct_path_times, reflect_path_times] = convert_delays_to_times(direct_path_delays, reflect_path_delays, params);

    % [direct_tof, reflected_tof] = calculate_theoretical_tof(params);

    % 显示直接路径和反射路径的时间到达平均值
    % disp('Average Direct Path Time-of-Flight (in seconds):');
    % disp(mean(direct_path_times, 'omitnan'));  % 计算并显示平均值，忽略NaN值
    % disp('Average Reflected Path Time-of-Flight (in seconds):');
    % disp(mean(reflect_path_times, 'omitnan'));  % 计算并显示平均值，忽略NaN值

end
