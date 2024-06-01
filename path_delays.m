function [delays, path_losses] = path_delays(params)
    % 直接路径的距离
    d_direct = norm(params.Tx - params.Rx);
    
    % 初始化反射路径的时延
    reflect_delays = zeros(1, params.N_targets);
    
    disp('路径差(m):')
    % 计算每个反射路径的距离和时延
    for i = 1:params.N_targets
        target = params.Targets(i, :);
        d_reflect = norm(params.Tx - target) + norm(target - params.Rx);
        reflect_delays(i) = d_reflect / params.c;
        disp(d_reflect - d_direct);
    end
    
    % 合并直接路径和反射路径的时延
    delays = [d_direct / params.c; reflect_delays];

    disp('理论路径长度（m）:')
    disp(delays*3e8)
    
    % 初始化路径损耗，此处留空，因为例子中未提供路径损耗的计算
    path_losses = [];
end
