
% Load mealData data
mealData1 = readmatrix("mealData1.csv");
mealData2 = readmatrix("mealData2.csv");
mealData3 = readmatrix("mealData3.csv");
mealData4 = readmatrix("mealData_4.csv");
mealData5 = readmatrix("mealData5.csv");


% Load mealAmountData data
mealAmountData1 = readmatrix("mealAmountData1.csv");
mealAmountData2 = readmatrix("mealAmountData2.csv");
mealAmountData3 = readmatrix("mealAmountData3.csv");
mealAmountData4 = readmatrix("mealAmountData4.csv");
mealAmountData5 = readmatrix("mealAmountData5.csv");

% Pre-Processing

% remove the last column as it contains mostly NAN and including only 50
% rows of meal data
mealData1_cleaned=mealData1(1:50,1:30);
mealData2_cleaned=mealData2(1:50,1:30);
mealData3_cleaned=mealData3(1:50,1:30);
mealData4_cleaned=mealData4(1:48,1:30);
mealData5_cleaned=mealData5(1:50,1:30);

% Select first 50 rows of mealAmountData
mealAmountData1_cleaned =  mealAmountData1(1:50,:);
mealAmountData2_cleaned  = mealAmountData2(1:50,:);
mealAmountData3_cleaned  = mealAmountData3(1:50,:);
mealAmountData4_cleaned  = mealAmountData4(1:48,:);
mealAmountData5_cleaned  = mealAmountData5(1:50,:);

mealAmountData_cleaned = [mealAmountData1_cleaned; mealAmountData2_cleaned;
    mealAmountData3_cleaned;mealAmountData4_cleaned;mealAmountData5_cleaned];

% Append the first 50 rows of mealData and Meal Amount Data
person1Data = [mealData1_cleaned, mealAmountData1_cleaned ];
person2Data = [mealData2_cleaned, mealAmountData2_cleaned ];
person3Data = [mealData3_cleaned, mealAmountData3_cleaned ];
person4Data = [mealData4_cleaned, mealAmountData4_cleaned ];
person5Data = [mealData5_cleaned, mealAmountData5_cleaned ];

% Do not include rows  with more than 1 NAN's 
person1Data_cleaned=person1Data(sum(isnan(mealData1_cleaned),2)<=1,:);
person2Data_cleaned=person2Data(sum(isnan(mealData2_cleaned),2)<=1,:);
person3Data_cleaned=person3Data(sum(isnan(mealData3_cleaned),2)<=1,:);
person4Data_cleaned=person4Data(sum(isnan(mealData4_cleaned),2)<=1,:);
person5Data_cleaned=person5Data(sum(isnan(mealData5_cleaned),2)<=1,:);

% fill the missing values 
person1Data_cleaned = fillmissing(person1Data_cleaned,'linear',1);
person2Data_cleaned = fillmissing(person2Data_cleaned,'linear',1);
person3Data_cleaned = fillmissing(person3Data_cleaned,'linear',1);
person4Data_cleaned = fillmissing(person4Data_cleaned,'linear',1);
person5Data_cleaned = fillmissing(person5Data_cleaned,'linear',1);

% check for outliers
outlier1 = isoutlier(person1Data_cleaned,'mean',2);
outlier2 = isoutlier(person2Data_cleaned,'mean',2);
outlier3 = isoutlier(person3Data_cleaned,'mean',2);
outlier4 = isoutlier(person4Data_cleaned,'mean',2);
outlier5 = isoutlier(person5Data_cleaned,'mean',2);

%display(outlier1);
%display(outlier2);
%display(outlier3);
%display(outlier4);
%display(outlier5);

trainingData= [person1Data_cleaned(:,1:30); person2Data_cleaned(:,1:30);
			  person3Data_cleaned(:,1:30); person4Data_cleaned(:,1:30);
			  person5Data_cleaned(:,1:30)];
                    

% Create Feature Matrix
feature_matrix=[];
for rows= 1:size(trainingData,1)
    currentRowValues = trainingData(rows,:);
    
    % Fast Fourier transform
    featureFFT = abs(fft(currentRowValues));
    featureFFT_values= sort(featureFFT,2,'descend');
    featureFFT_values= featureFFT_values(:, 1:5);

    %Discrete Wavelet Transform
    featureDWT = dwt(currentRowValues,'sym4');
    featureDWT_values = sort(featureDWT,2,'descend');
    featureDWT_values = featureDWT_values(:, 1:5);

    % CGM Velocity
    cgmDiffValues = [0 currentRowValues(1:end-1) - currentRowValues(2:end)];
    cgmDiffMaxSort = sort(cgmDiffValues, 'descend');
    cgmDiffMaxValues = cgmDiffMaxSort(:, 1:5);
    
    % Moving Root Mean square
    featureRMS = sqrt(movmean(currentRowValues .^ 3, 5));
    featureRMS_values = sort(featureRMS,2,'descend');
    featureRMS_values = featureRMS_values(:, 1:5);
    
    vector = [featureFFT_values, featureDWT_values, cgmDiffMaxValues, featureRMS_values];  
    feature_matrix=[feature_matrix; vector];
end
% Normalize the feature matrix 
normalized_feature_matrix =normalize(feature_matrix,'norm',1);


% train the models
% kmeals
kMeans_model = kmeans(normalized_feature_matrix,6);
%dbscan
dbscan_model =  dbscan(normalized_feature_matrix,0.01332,4);
 




% Calculate Ground Truth
gTruth =[];
for i = 1:size(trainingData ,1)
    if mealAmountData_cleaned(i)== 0
       vector =  [1 trainingData(i)];
    elseif (mealAmountData_cleaned(i)> 0 && mealAmountData_cleaned(i) <= 20)   
       vector =  [2 mealAmountData_cleaned(i)];
    elseif (mealAmountData_cleaned(i)> 20 && mealAmountData_cleaned(i) <= 40)   
       vector =  [3 mealAmountData_cleaned(i)];
    elseif (mealAmountData_cleaned(i)> 40 && mealAmountData_cleaned(i) <= 60)   
       vector =  [4 mealAmountData_cleaned(i)];
     elseif (mealAmountData_cleaned(i)> 60 && mealAmountData_cleaned(i) <= 80)   
       vector =  [5 mealAmountData_cleaned(i)];
     elseif (mealAmountData_cleaned(i)> 100 && mealAmountData_cleaned(i) <= 120)   
       vector =  [6 mealAmountData_cleaned(i)];
    end 
    gTruth = [gTruth ; vector];
end


% Determine the actual bins of pridicted kMeans values
 bin1 = []; bin2 = [];bin3 = [];bin4 = [];bin5 = [];bin6 = [];
 for row= 1:size(kMeans_model,1)
    if kMeans_model(row)== 1
        bin1 = [ bin1; row]; 
    elseif kMeans_model(row)== 2
        bin2 = [ bin2; row];
    elseif kMeans_model(row)== 3
        bin3 = [ bin3; row];
    elseif kMeans_model(row)== 4
        bin4 = [ bin4; row];
    elseif kMeans_model(row)== 5
        bin5 = [ bin5; row];
    elseif kMeans_model(row)== 6
        bin6 = [ bin6; row];
    end
 end
 
 
 
 % Determine the actual bins of pridicted dbscan values
 
 dbscanBin1 = []; dbscanBin2 = [];dbscanBin3 = [];dbscanBin4 = [];dbscanBin5 = [];dbscanBin6 = [];
 for row= 1:size(dbscan_model,1)
    if dbscan_model(row)== 1
        dbscanBin1 = [ dbscanBin1; row]; 
    elseif dbscan_model(row)== 2
        dbscanBin2 = [ dbscanBin2; row];
    elseif dbscan_model(row)== 3
        dbscanBin3 = [ dbscanBin3; row];
    elseif dbscan_model(row)== 4
        dbscanBin4 = [ dbscanBin4; row];
    elseif dbscan_model(row)== 5
        dbscanBin5 = [ dbscanBin5; row];
    elseif dbscan_model(row)== 6
        dbscanBin6 = [ dbscanBin6; row];
    end
 end
 

 
% Doing majority counting for kMeans outputs
temp1 =[]; temp2 =[]; temp3 =[]; temp4 =[]; temp5 =[]; temp6 =[];
for row = 1:(size(bin1,1))
        temp1 = [temp1; gTruth(bin1(row))];
end
for row = 1:(size(bin2,1))
        temp2 = [temp2; gTruth(bin2(row))];
end 
for row = 1:(size(bin3,1))
        temp3 = [temp3; gTruth(bin3(row))];
end
for row = 1:(size(bin4,1))
        temp4 = [temp4; gTruth(bin4(row))];
end
for row = 1:(size(bin5,1))
        temp5 = [temp5; gTruth(bin5(row))];
end
for row = 1:(size(bin6,1))
        temp6 = [temp6; gTruth(bin6(row))];
end

actualBins_kMeans = [transpose(repelem(mode(temp1), size(bin1,1)));
              transpose(repelem(mode(temp2), size(bin2,1)));
              transpose(repelem(mode(temp3), size(bin3,1)));
              transpose(repelem(mode(temp4), size(bin4,1)));
              transpose(repelem(mode(temp5), size(bin5,1)));
              transpose(repelem(mode(temp6), size(bin6,1)))];


% Doing majority counting for dbScan outputs
t1 =[]; t2 =[]; t3 =[]; t4 =[]; t5 =[]; t6 =[];
for row = 1:(size(dbscanBin1,1))
        t1 = [t1; gTruth(dbscanBin1(row))];
end
for row = 1:(size(dbscanBin2,1))
        t2 = [t2; gTruth(dbscanBin2(row))];
end 
for row = 1:(size(dbscanBin3,1))
        t3 = [t3; gTruth(dbscanBin3(row))];
end
for row = 1:(size(dbscanBin4,1))
        t4 = [t4; gTruth(dbscanBin4(row))];
end
for row = 1:(size(dbscanBin5,1))
        t5 = [t5; gTruth(dbscanBin5(row))];
end
for row = 1:(size(dbscanBin6,1))
        t6 = [t6; gTruth(dbscanBin6(row))];
end

actualBins_dbScan = [transpose(repelem(mode(t1), size(dbscanBin1,1)));
                     transpose(repelem(mode(t2), size(dbscanBin2,1)));
                     transpose(repelem(mode(t3), size(dbscanBin3,1)));
                     transpose(repelem(mode(t4), size(dbscanBin4,1)));
                     transpose(repelem(mode(t5), size(dbscanBin5,1)));
                     transpose(repelem(mode(t6), size(dbscanBin6,1)))];

                

% Cross Validation kMeans
trained_modelKnn = fitcknn(normalized_feature_matrix,actualBins_kMeans,'NumNeighbors',25,'Standardize',1);
cvm = crossval(trained_modelKnn, 'Holdout',0.4 );
y_predict = kfoldPredict(cvm);
sum1=0;
for row = 1:size(y_predict)
        if y_predict(row) == gTruth(row)
            sum1 = sum1+1;
        end
end
accuracyKmeans = sum1/(size(y_predict,1));
accuracyKmeans

% Cross Validation dbScan
trained_model_dbscan = fitcknn(normalized_feature_matrix,actualBins_dbScan, 'NumNeighbors',25,'Standardize',1);
cvm2 = crossval(trained_model_dbscan, 'Holdout',0.30 );
y_predict_dbScan = kfoldPredict(cvm2);
sum2=0;
for row = 1:size(y_predict_dbScan)
        if y_predict_dbScan(row) == gTruth(row)
            sum2 = sum2+1;
        end
end
accuracyDBscan = sum2/(size(y_predict_dbScan,1));
accuracyDBscan

%save the trained model
save trainedModel.mat trained_modelKnn trained_model_dbscan;