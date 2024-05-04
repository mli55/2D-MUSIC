function G = generateGm(m)
    if m == 1
        G = [1 0; 1 1];
    else
        Gm_1 = generateGm(m-1);
        O = zeros(size(Gm_1));
        G = [Gm_1 O; Gm_1 Gm_1];
    end
end

function capacities = calculateCapacities(G, N, epsilon)
    capacities = zeros(1, N);
    for i = 1:N
        Zi = 1;
        for j = 1:N
            if G(i, j) == 1
                Zi = Zi * (1 - epsilon);
            end
        end
        capacities(i) = 1 - Zi;
    end
end

% Main function to plot capacities in subplots
function main()
    blocklengths = [8, 64, 512, 4096];
    numPlots = length(blocklengths);
    epsilon = 1/3;
    figure;
    
    for idx = 1:numPlots
        N = blocklengths(idx);
        m = log2(N);
        G = generateGm(m);
        capacities = calculateCapacities(G, N, epsilon);

        % Create subplot for each blocklength
        subplot(2, ceil(numPlots / 2), idx);
        histogram(capacities, 100);
        title(['Histogram for N = ', num2str(N)]);
        xlabel('Capacity');
        ylabel('Frequency');
    end
end

% Execute the main function
main();

extrem_low = sum(capacities <= 0.01);
extrem_high = sum(capacities > 0.99);
fprintf('Fraction of channels with C <= 0.01: %f\n', extrem_low / N);
fprintf('Fraction of channels with C > 0.99: %f\n', extrem_high / N);


R = extrem_high / N;
fprintf('Rate of transmission R using only C > 0.99 subchannels: %f\n', R);
