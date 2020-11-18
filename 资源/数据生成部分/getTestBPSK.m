%% Clean up
clear;
clc;

rows = 1000;
cols = 500;
NFeatures = 5;
test_data = zeros(rows, NFeatures);
SNR = (-4:2:10);

for i = 1:length(SNR)

    %% Simulation parameters
    M = 2;
    snr = SNR(i);
    %% Simulate
    %BPSK
    % Generate random data
    data = randi([0 1], rows, cols);

    % PSK 映射
    [data1] = data';
    data_cell = mat2cell(data1, cols, ones(1, rows));
    signalData = cellfun(@(x) BPSKModulator(x), data_cell, 'UniformOutput', false);
    signalDataMat = cell2mat(signalData);
    dataMod = mat2cell(signalDataMat', ones(1, rows), cols);

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
    filename = [fullfile('digits', 'testBPSK-'), num2str(snr), '.dat'];
    dlmwrite(filename, test_data, 'delimiter', '\t', 'newline', 'pc');
end
