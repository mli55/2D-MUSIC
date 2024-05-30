function angles = target_orientations(params)

    % 初始化角度数组
    angles = zeros(1 + params.N_targets, 1);  % 存储从Tx到Rx和各个Target的角度

    % 计算从Tx到Rx的角度
    delta_x = params.Rx(1) - params.Tx(1);
    delta_y = params.Rx(2) - params.Tx(2);
    angles(1) = atan2(delta_y, delta_x);  % 存储从Tx到Rx的角度

    % 计算从Tx到每个Target的角度
    for k = 1:params.N_targets
        target = params.Targets(k, :);  % 动态访问目标坐标

        % 计算从Tx到当前Target的角度
        delta_x = target(1) - params.Tx(1);
        delta_y = target(2) - params.Tx(2);
        angle_tx_to_target = atan2(delta_y, delta_x);
        angles(1 + k) = angle_tx_to_target;  % 将角度存储在数组中
    end

    % 将角度从弧度转换为度（可选）
    angles = rad2deg(angles);

    % 输出角度
    disp('从Tx到Rx和各个Target的角度（度）：');
    disp(angles);
end
