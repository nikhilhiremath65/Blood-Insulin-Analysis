load trainedModel.mat;


% Load proj3_test data
testdata = readmatrix("proj3_test.csv");

% Pre-Processing

% fill the missing values 
testDataCleaned =  fillmissing(testdata,'linear',1);

% Create Feature Matrix
feature_matrix=[];
for rows= 1:size(testDataCleaned,1)
    testDataCleaned_row = testDataCleaned(rows,:);
    
     % Fast Fourier transform
     testDataCleaned_fft = abs(fft(testDataCleaned_row));
     testDataCleaned_fft_values= sort(testDataCleaned_fft,2,'descend');
     testDataCleaned_fft_values= testDataCleaned_fft_values(:, 1:5);

    %Discrete Wavelet Transform
    testDataCleaned_dwt = dwt(testDataCleaned_row,'sym4');
    testDataCleaned_dwt_values = sort(testDataCleaned_dwt,2,'descend');
    testDataCleaned_dwt_values = testDataCleaned_dwt_values(:, 1:5);

    % CGM Velocity
    cgmDiffValues = [0 testDataCleaned_row(1:end-1) - testDataCleaned_row(2:end)];
    cgmDiffMaxSort = sort(cgmDiffValues, 'descend');
    cgmDiffMaxValues = cgmDiffMaxSort(:, 1:5);
    
    % Moving Root Mean square
    testDataCleaned_rms = sqrt(movmean(testDataCleaned_row .^ 2, 5));
    testDataCleaned_rms_values = sort(testDataCleaned_rms,2,'descend');
    testDataCleaned_rms_values = testDataCleaned_rms_values(:, 1:5);
    
    vector = [testDataCleaned_fft_values, testDataCleaned_dwt_values, cgmDiffMaxValues, testDataCleaned_rms_values];  
    feature_matrix=[feature_matrix; vector];
end

% Normalize the feature matrix 
normalized_feature_matrix =normalize(feature_matrix,'norm',1);
predictKNN = predict(trained_modelKnn, normalized_feature_matrix);
predictDBscan = predict(trained_model_dbscan, normalized_feature_matrix);
output = [predictKNN,predictDBscan];
csvwrite("Project3_NikhilHiremath.csv",output);
