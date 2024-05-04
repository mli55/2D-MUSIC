function [direct_tof, reflected_tof] = calculate_theoretical_tof(params)
    % 提取坐标
    tx_coords = params.Tx;
    rx_coords = params.Rx;
    target_coords = params.Target;
    
    % 计算距离
    direct_distance = norm(tx_coords - rx_coords);  % 直接路径的距离
    reflected_distance = norm(tx_coords - target_coords) + norm(target_coords - rx_coords);  % 反射路径的距离

    % 信号传播速度 (光速)
    speed_of_signal = params.c;

    % 计算时间到达 (ToF)
    direct_tof = direct_distance / speed_of_signal;
    reflected_tof = reflected_distance / speed_of_signal;

    % 显示结果
    fprintf('Theoretical Direct Path TOF (in seconds): %f\n', direct_tof);
    fprintf('Theoretical Reflected Path TOF (in seconds): %f\n', reflected_tof);
end