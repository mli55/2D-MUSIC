function [delays, path_losses] = path_delays(params)
    % 光速
    
    % 直接路径的距离
    d_direct = norm(params.Tx - params.Rx);
    
    % 反射路径的距离
    d_reflect1 = norm(params.Tx - params.Target1) + norm(params.Target1 - params.Rx);
    d_reflect2 = norm(params.Tx - params.Target2) + norm(params.Target2 - params.Rx);
    
    % 计算时延
    direct_delay = d_direct / params.c;
    reflect_delay1 = d_reflect1 / params.c;
    reflect_delay2 = d_reflect2 / params.c;
    disp('路径差(m)：')
    disp(d_reflect1 - d_direct);
    % disp([num2str(d_direct), '-', num2str(d_reflect1), '=', num2str(d_reflect1 - d_direct)]);
    % 返回延迟和路径损耗（此例中未计算路径损耗）
    delays = [direct_delay, reflect_delay1];
    % disp('delays:')
    % disp(delays)
    path_losses = [];  % 此处留空，因为例子中未提供路径损耗的计算
end
