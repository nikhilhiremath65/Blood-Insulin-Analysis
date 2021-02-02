load trainedModel;
% mealData1.csv/Nomeal1.csv/mealData1Test.csv
% filename = input('Enter CSV filename to test the model: ', 's');
testData = readmatrix("TestData.csv");

%Preprocessing the testData
testData_cleaned=testData(:,1:30);
testData_cleaned = fillmissing(testData_cleaned,'linear',1);

% Create Feature Matrix
featureMatrixTestData=[];
for rows= 1:size(testData_cleaned,1)
    testData_row = testData_cleaned(rows,:);
    
     % Fast Fourier transform
     testData_fft = abs(fft(testData_row));
     testData_fft_values= sort(testData_fft,2,'descend');
     testData_fft_values= testData_fft_values(:, 1:4);

    %Discrete Wavelet Transform
    testData_dwt = dwt(testData_row,'sym4');
    testData_dwt_values = sort(testData_dwt,2,'descend');
    testData_dwt_values = testData_dwt_values(:, 1:4);

    % Moving Standard Deviation
    testData_std = movstd(testData_row,5);
    testData_std_values = sort(testData_std,2,'descend');
    testData_std_values = testData_std_values(:, 1:4);
    
    % Moving Root Mean square
    testData_rms = sqrt(movmean(testData_row .^ 2, 5));
    testData_rms_values = sort(testData_rms,2,'descend');
    testData_rms_values = testData_rms_values(:, 1:4);
    
    vector = [testData_fft_values, testData_dwt_values, testData_std_values, testData_rms_values];  
    featureMatrixTestData=[featureMatrixTestData; vector];
end

% Update Feature matrix
updatedFeatureMatrixTest = featureMatrixTestData * top_5_coeff_mealData;
y1 = predict(trained_model1, updatedFeatureMatrixTest);
display(y1)

csvwrite("Project2_NikhilHiremath.csv",y1)

