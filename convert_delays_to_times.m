function [direct_path_times, reflect_path_times] = convert_delays_to_times(direct_path_delays, reflect_path_delays, params)
    % 转换样本延迟到时间（秒）
    direct_path_times = direct_path_delays / params.Fs;
    reflect_path_times = reflect_path_delays / params.Fs;
end
