cgmSeries = csvread("./DataFolder/CGMSeriesLunchPat1.csv", 1, 0);
cgmTime = csvread("./DataFolder/CGMDatenumLunchPat1.csv", 1, 0);

featureMatrix = [];

for rowIndex = 1:size(cgmSeries, 1)
%     disp(cgmSeries(rowIndex,1:end-1));
    CGMMovingMean = movmean(cgmSerie    s(rowIndex,1:end-1), [length(cgmSeries(rowIndex,1:end-1)) 0]);
    CGMMovingMeanQuantiles = quantile(CGMMovingMean, [0.25, 0.5, 0.75]);
    
    
    cgmRMS = rms(cgmSeries(rowIndex,(1:end-1)));
    
    cgmSkewness = skewness(cgmSeries(rowIndex,(1:end-1)));
    
    polynomial_coeff = 4;
    
%     disp(size(cgmSeries(rowIndex, :)))
    times = [1:size(cgmSeries(rowIndex, :), 2)];
%     disp(times)
    cgmPolyfit = polyfit(0.035*(times), flip(cgmSeries(rowIndex, :)), polynomial_coeff);
    
    featureVector = [CGMMovingMeanQuantiles cgmRMS cgmSkewness cgmPolyfit];
    featureMatrix = [featureMatrix; featureVector];
    
end

normed_feature_matrix = normalize(featureMatrix, 'norm', 1);

% disp(featureMatrix)

% PCA computation

[coeff, score] = pca(normed_feature_matrix);

top_Eigens = coeff(:, 1:5);
upatedFatures = normed_feature_matrix*top_Eigens;
