% Load mealData data
mealData1 = readmatrix("mealData1.csv");
mealData2 = readmatrix("mealData2.csv");
mealData3 = readmatrix("mealData3.csv");
mealData4 = readmatrix("mealData4.csv");
mealData5 = readmatrix("mealData5.csv");

% Load Nomeal1 data
Nomeal1 = readmatrix("Nomeal1.csv");
Nomeal2 = readmatrix("Nomeal2.csv");
Nomeal3 = readmatrix("Nomeal3.csv");
Nomeal4 = readmatrix("Nomeal4.csv");
Nomeal5 = readmatrix("Nomeal5.csv");

% Pre-Processing

% Do not include rows  with more than 3 NAN's 
mealData1_cleaned=mealData1(sum(isnan(mealData1),2)<=1,:);
mealData2_cleaned=mealData2(sum(isnan(mealData2),2)<=1,:);
mealData3_cleaned=mealData3(sum(isnan(mealData3),2)<=1,:);
mealData4_cleaned=mealData4(sum(isnan(mealData4),2)<=1,:);
mealData5_cleaned=mealData5(sum(isnan(mealData5),2)<=1,:);
Nomeal1_cleaned=Nomeal1(sum(isnan(Nomeal1),2)<=1,:);
Nomeal2_cleaned=Nomeal2(sum(isnan(Nomeal2),2)<=1,:);
Nomeal3_cleaned=Nomeal3(sum(isnan(Nomeal3),2)<=1,:);
Nomeal4_cleaned=Nomeal4(sum(isnan(Nomeal4),2)<=1,:);
Nomeal5_cleaned=Nomeal5(sum(isnan(Nomeal5),2)<=1,:);

% remove the last column as it contains mostly NAN
mealData1_cleaned=mealData1_cleaned(:,1:30);
mealData2_cleaned=mealData2_cleaned(:,1:30);
mealData3_cleaned=mealData3_cleaned(:,1:30);
mealData4_cleaned=mealData4_cleaned(:,1:30);
mealData5_cleaned=mealData5_cleaned(:,1:30);

% fill the missing values 
mealData1_cleaned = fillmissing(mealData1_cleaned,'linear',1);
mealData2_cleaned = fillmissing(mealData2_cleaned,'linear',1);
mealData3_cleaned = fillmissing(mealData3_cleaned,'linear',1);
mealData4_cleaned = fillmissing(mealData4_cleaned,'linear',1);
mealData5_cleaned = fillmissing(mealData5_cleaned,'linear',1);
Nomeal1_cleaned = fillmissing(Nomeal1_cleaned,'linear',1);
Nomeal2_cleaned = fillmissing(Nomeal2_cleaned,'linear',1);
Nomeal3_cleaned = fillmissing(Nomeal3_cleaned,'linear',1);
Nomeal4_cleaned = fillmissing(Nomeal4_cleaned,'linear',1);
Nomeal5_cleaned = fillmissing(Nomeal5_cleaned,'linear',1);

% check for outliers
outlier1 = isoutlier(mealData1_cleaned,'mean',2);
outlier2 = isoutlier(mealData2_cleaned,'mean',2);
outlier3 = isoutlier(mealData3_cleaned,'mean',2);
outlier4 = isoutlier(mealData4_cleaned,'mean',2);
outlier5 = isoutlier(mealData5_cleaned,'mean',2);
outlier1_Nomeal = isoutlier(Nomeal1_cleaned,'mean',2);
outlier2_Nomeal = isoutlier(Nomeal2_cleaned,'mean',2);
outlier3_Nomeal = isoutlier(Nomeal3_cleaned,'mean',2);
outlier4_Nomeal = isoutlier(Nomeal4_cleaned,'mean',2);
outlier5_Nomeal = isoutlier(Nomeal5_cleaned,'mean',2);
%display(outlier1);
%display(outlier2);
%display(outlier3);
%display(outlier4);
%display(outlier5);


% Create the training set
% Concatinate all the data into mealData,Nomeal matrix and prepare trainingData
mealData= [mealData1_cleaned;mealData2_cleaned;mealData3_cleaned;mealData4_cleaned;mealData5_cleaned];
Nomeal = [Nomeal1_cleaned;Nomeal2_cleaned;Nomeal3_cleaned; Nomeal4_cleaned; Nomeal5_cleaned];
trainingData= cat(1,mealData,Nomeal);

% Create the class label matrix for trainData
mealClassLabels= repelem(1,size(mealData,1))';
NomealClassLables = repelem(0,size(Nomeal,1))';
classLabelsTrainData= cat(1,mealClassLabels,NomealClassLables);

% Create Feature Matrix
feature_matrix=[];
for rows= 1:size(trainingData,1)
    trainingData_row = trainingData(rows,:);
    
     % Fast Fourier transform
     trainingData_fft = abs(fft(trainingData_row));
     trainingData_fft_values= sort(trainingData_fft,2,'descend');
     trainingData_fft_values= trainingData_fft_values(:, 1:4);

    %Discrete Wavelet Transform
    trainingData_dwt = dwt(trainingData_row,'sym4');
    trainingData_dwt_values = sort(trainingData_dwt,2,'descend');
    trainingData_dwt_values = trainingData_dwt_values(:, 1:4);

    % Moving Standard Deviation
    trainingData_std = movstd(trainingData_row,5);
    trainingData_std_values = sort(trainingData_std,2,'descend');
    trainingData_std_values = trainingData_std_values(:, 1:4);
    
    % Moving Root Mean square
    trainingData_rms = sqrt(movmean(trainingData_row .^ 2, 5));
    trainingData_rms_values = sort(trainingData_rms,2,'descend');
    trainingData_rms_values = trainingData_rms_values(:, 1:4);
    
    vector = [trainingData_fft_values, trainingData_dwt_values, trainingData_std_values, trainingData_rms_values];  
    feature_matrix=[feature_matrix; vector];
end

% Normalize the feature matrix 
normalized_feature_matrix =normalize(feature_matrix,'norm',1);

% Compute PCA for mealData only
coeff = pca(normalized_feature_matrix(1:size(mealData,1),:));
top_5_coeff_mealData = coeff(:,1:5);
updated_feature_matrix = feature_matrix* top_5_coeff_mealData;

 % Plot PCA's of mealData
% for row = 1:5
%     subplot(2,5,row)
%     plot(coeff(:, row))
%     title(['Principal Component MealData- ' num2str(row)]);
% end

% train the model

% Random Forest Classifier
 %trained_model1 = TreeBagger(100,updated_feature_matrix,classLabelsTrainData, 'Method', 'classification'); 
% view(trained_model1.Trees{1},'Mode','graph');

%SVM
%trained_model1 = fitcsvm(updated_feature_matrix,classLabelsTrainData);

% AdaBoostM1
%templ = templateTree('Surrogate','all');
%trained_model1 = fitcensemble(updated_feature_matrix,classLabelsTrainData,'Method','AdaBoostM1','NumLearningCycles',30,'Learners',templ);

% Decision Tree
%trained_model1 = fitctree(updated_feature_matrix,classLabelsTrainData);

%KNN
%trained_model1 = fitcknn(updated_feature_matrix,classLabelsTrainData,'NumNeighbors',14,'Standardize',1);

%Logestic Regression
%[trained_model1,FitInfo] = fitclinear(updated_feature_matrix,classLabelsTrainData);

%NaiveBayes
trained_model1 = fitcnb(updated_feature_matrix,classLabelsTrainData);

% discriminant analysis classifier
%trained_model1 = fitcdiscr(updated_feature_matrix,classLabelsTrainData);


%save the trained model
save trainedModel trained_model1;

cvm = crossval(trained_model1, 'kfold', 5);
y_predict = kfoldPredict(cvm);
confusionMatrix = confusionmat(classLabelsTrainData, y_predict);
TP = confusionMatrix(1,1);
FP = confusionMatrix(1,2);
FN = confusionMatrix(2,1);
TN = confusionMatrix(2,2);
Accuracy = (TP+TN)/(TP+FP+FN+TN)*100;
display(Accuracy);
precision = TP/(TP+FP);
display(precision);
recall= TP/(TP+FN);
display(recall);
F1 = (2 * precision * recall) / (precision + recall);
display(F1);




testData = readmatrix("TestData.csv");
   
