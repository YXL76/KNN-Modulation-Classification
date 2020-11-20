function [cumulants] = func_get_cumulants(signalData)

    shape = size(signalData);
    H = shape(1);
    L = shape(2);
    cumulants = zeros(H, L);

    for row = 1:H
        rowData = signalData(row, :);

        M20 = sum(rowData.^2) / L;
        M21 = sum(abs(rowData).^2) / L;
        M22 = sum(conj(rowData).^2) / L;
        M40 = sum(rowData.^4) / L;
        M41 = sum(abs(rowData).^2 .* rowData.^2) / L;
        M42 = sum(abs(rowData).^4) / L;
        M43 = sum(abs(rowData).^2 .* conj(rowData).^2) / L;
        M60 = sum(rowData.^6) / L;
        M61 = sum(abs(rowData).^2 .* rowData.^4) / L;
        M62 = sum(abs(rowData).^4 .* rowData.^2) / L;
        M63 = sum(abs(rowData).^6) / L;

        C20 = M20;
        C21 = M21;
        C40 = M40 - 3 * M20^2;
        C41 = M41 - 3 * M20 * M21;
        C42 = M42 - abs(M20)^2 - 2 * M21^2;
        C60 = M60 - 15 * M20 * M40 + 30 * M20^3;
        C61 = M61 - 5 * M21 * M40 - 10 * M20 * M41 + 30 * M20^2 * M21;
        C62 = M62 - 6 * M20 * M42 - 8 * M21 * M41 - M22 * M40 + 6 * M20^2 * M22 + 24 * M21^2 * M20;
        C63 = M63 -9 * M21 * M42 + 12 * M21^3 - 3 * M20 * M43 - 3 * M22 * M41 + 18 * M20 * M21 * M22;

        C21_modify = C21;
        C20_norm = C20 / (C21_modify^2);
        C21_norm = C21 / (C21_modify^2);
        C40_norm = C40 / (C21_modify^2);
        C41_norm = C41 / (C21_modify^2);
        C42_norm = C42 / (C21_modify^2);
        C60_norm = C60 / (C21_modify^2);
        C61_norm = C61 / (C21_modify^2);
        C62_norm = C62 / (C21_modify^2);
        C63_norm = C63 / (C21_modify^2);

        cumulants(row, 1) = abs(C20_norm);
        cumulants(row, 2) = abs(C21_norm);
        cumulants(row, 3) = abs(C40_norm);
        cumulants(row, 4) = abs(C41_norm);
        cumulants(row, 5) = abs(C42_norm);
        cumulants(row, 6) = abs(C60_norm);
        cumulants(row, 7) = abs(C61_norm);
        cumulants(row, 8) = abs(C62_norm);
        cumulants(row, 9) = abs(C63_norm);

    end
