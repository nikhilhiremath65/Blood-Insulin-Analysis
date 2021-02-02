cgmSeries = csvread("./DataFolder/CGMSeriesLunchPat1.csv", 1, 0);
cgmTime = csvread("./DataFolder/CGMDatenumLunchPat1.csv", 1, 0);

% plot(cgmTime(1, :), cgmSeries(1, :));

%Pre Processing of the data

cgmSeriesProcessed = cgmSeries(:, 1:31);
cgmDateNumProcessed = cgmTime(:, 1:31);

[cgmSeriesProcessed, index_to_remove] = rmmissing(cgmSeriesProcessed, 'MinNumMissing', round(31/4));

cgmDateNumProcessed = cgmTime(not(index_to_remove), :);


% If number of missing values less than 31/4, fill those

% cgmSeriesProcessed = fillmissing(cgmSeriesProcessed, 'linear');


cgmDateNumProcessed = flip(flip(cgmDateNumProcessed,1),2);
cgmSeriesProcessed = flip(flip(cgmSeriesProcessed,1),2);

featureMatrix = [];
numMaxPoints = 4;


for rowIndex = 1:size(cgmSeriesProcessed, 1)

    
    % CGM Velocity
    cgmRow = cgmSeriesProcessed(rowIndex, :);
    cgmtime = cgmDateNumProcessed(rowIndex, :);
    cgmDiffValues = [0 cgmRow(1:end-1) - cgmRow(2:end)];
    cgmDiffMaxSort = sort(cgmDiffValues, 'descend');
    cgmDiffMaxValues = cgmDiffMaxSort(:, 1:numMaxPoints);
    
    % Moving RMS Velocity
    cgmRmsMoving =  sqrt(movmean(cgmRow .^ 2, 5));
    rmsValues = sort(cgmRmsMoving, 'descend');
    cgmRmsMaxValues = rmsValues(:, 1: numMaxPoints);
    
    % Discrete Wavelet Transform
    cgmDWT = dwt(cgmRow, 'sym4');
    cgmDWTMaxValues = sort(cgmDWT, 'descend');
    cgmDWTMaxValues = cgmDWTMaxValues(:, 1:numMaxPoints);
    
    % Power Spectral Density
    cgmFFT = abs(fft(cgmRow));
    N = length(cgmFFT);
    psdx = (1/(2*pi*N)) * abs(cgmFFT(1:N/2+1)).^2;
    psdx(2:end-1) = 2*psdx(2:end-1);
    freq = 0:(2*pi)/N:pi;
    psdx = 10*log10(psdx);
    psdxValues = sort(psdx, 'descend');
    psdxValues = psdx(:, 1:numMaxPoints); 
    
    featureVector = [cgmDiffMaxValues cgmRmsMaxValues cgmDWTMaxValues psdxValues];
    featureMatrix = [featureMatrix; featureVector];
    
end


normed_featue_matrix = normalize(featureMatrix, 'norm', 1);

% disp(featureMatrix)

% PCA computation

[coeff, score] = pca(normed_feature_matrix);

top_Eigens = coeff(:, 1:5);
updatedFeatures = normed_feature_matrix*top_Eigens;


for rowIndex = 1:length(coeff)
    subplot(4,5,rowIndex)
    plot(coeff(:, rowIndex))
    title(['Principal Component- ' num2str(rowIndex)]);
end

