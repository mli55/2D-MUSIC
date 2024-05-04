function tx_signal = generate_ofdm_signal(params)
    % Create an empty matrix to hold all packets
    tx_signal = zeros(params.N_FFT + params.CP_len, params.packet_length);
    
    for k = 1:params.packet_length
        % Generate random QPSK symbols for each subcarrier for each packet
        data_bits = randi([0, 1], params.N_subcarriers * 2, 1);  % QPSK: 2 bits per symbol
        data_symbols = qpsk_modulation(data_bits);

        % Perform IFFT to convert the frequency domain data to time domain
        ofdm_sym = ifft(data_symbols, params.N_FFT);

        % Add Cyclic Prefix
        tx_signal(:, k) = [ofdm_sym(end-params.CP_len+1:end); ofdm_sym];
    end
end

function symbols = qpsk_modulation(bits)
    % Map pairs of bits to QPSK symbols
    symbols = (2 * bits(1:2:end) - 1) + 1i * (2 * bits(2:2:end) - 1);
end
