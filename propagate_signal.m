function rx_signal = propagate_signal(tx_signal, params)
    [delays, path_losses] = path_delays(params);
    rx_signal = zeros(size(tx_signal, 1) + max(ceil(delays * params.f_c)), params.packet_length);

    % Apply path effects for each packet
    for k = 1:params.packet_length
        for path = 1:length(delays)
            delay_samples = round(delays(path) * params.f_c);
            attenuated_signal = tx_signal(:, k) * sqrt(path_losses(path));
            rx_signal((1:size(tx_signal, 1)) + delay_samples, k) = ...
                rx_signal((1:size(tx_signal, 1)) + delay_samples, k) + attenuated_signal;
        end
    end

    % Add AWGN to the received signal
    rx_signal = awgn(rx_signal, params.SNR, 'measured');
end
