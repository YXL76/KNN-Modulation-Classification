%% Clean up
clear;
clc;

rows = 1000;
NFeatures = 9;
test_data = zeros(rows, NFeatures);
SNR = (-4:2:10);
N = [200 500];

for j = 1:length(N)

    cols = N(j) * 2;

    for i = 1:length(SNR)

        %% Simulation parameters
        M = 4;
        snr = SNR(i);

        %% Simulate
        %QPSK
        % Generate random data
        data = randi([0 1], rows, cols);

        % PSK 映射
        [data1] = data';
        data_cell = mat2cell(data1, cols, ones(1, rows));
        signalData = cellfun(@(x) QPSKModulator(x), data_cell, 'UniformOutput', false);
        %signalData = cellfun(@(x) qammod(x, M, 'InputType', 'bit', 'UnitAveragePower', true), data_cell, 'UniformOutput',false);
        signalDataMat = cell2mat(signalData);
        dataMod = mat2cell(signalDataMat', ones(1, rows), cols / 2);

        % AWGN 加噪
        dataRx = cellfun(@(x) awgn(x, snr), dataMod, 'UniformOutput', false);

        % 获取高阶累积量
        cumulants = cellfun(@(x) func_get_cumulants(x), dataRx, 'UniformOutput', false);
        cumulantsMat = cell2mat(cumulants);

        for row = 1:rows

            idx = 1;

            while idx <= NFeatures
                test_data(row, idx) = cumulantsMat(row, idx);
                idx = idx + 1;
            end

        end

        %% save
        filename = [fullfile('..', 'data', 'testQPSK-'), num2str(N(j)), '-', num2str(snr), '.dat'];
        dlmwrite(filename, test_data, 'delimiter', '\t', 'newline', 'pc');
    end

end
