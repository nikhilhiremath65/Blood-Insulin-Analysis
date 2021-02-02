% Load CGMDatenum data
CGMDatenum1 = readmatrix("CGMDatenumLunchPat1.csv");
CGMDatenum1;


% Load CGMSeries data
CGMSeries1 = readmatrix("CGMSeriesLunchPat1.csv");
CGMSeries1;


% Pre-Processing
CGMDatenum1_datetime1 = datetime(CGMDatenum1,'ConvertFrom','datenum');
CGMSeries1 = fillmissing(CGMSeries1,'linear',1);
CGMSeries1 = flip(CGMSeries1,2);

% check for outliers
outlier = isoutlier(CGMSeries1,'mean',2);
display(outlier);


feature_matrix=[];
for rows= 1:size(CGMSeries1,1)
    cgm_row = CGMSeries1(rows,:);
    
    % Fast Fourier transform
    CGMSeries_p1_fft = abs(fft(cgm_row));
    CGMSeries_p1_fft_value = sort(CGMSeries_p1_fft,2,'descend');
    CGMSeries_p1_fft_value = CGMSeries_p1_fft_value(:, 1:4);

    %Discrete Wavelet Transform
    CGMSeries_p1_dwt = dwt(cgm_row,'sym4');
    CGMSeries_p1_dwt_values = sort(CGMSeries_p1_dwt,2,'descend');
    CGMSeries_p1_dwt_values = CGMSeries_p1_dwt_values(:, 1:4);

    % Moving Standard Deviation
    CGMSeries_p1_std = movstd(cgm_row,5);
    CGMSeries_p1_std_values = sort(CGMSeries_p1_std,2,'descend');
    CGMSeries_p1_std_values = CGMSeries_p1_std_values(:, 1:4);
    
    % Moving Root Mean square
    CGMSeries_p1_rms = sqrt(movmean(cgm_row .^ 2, 5));
    CGMSeries_p1_rms_values = sort(CGMSeries_p1_rms,2,'descend');
    CGMSeries_p1_rms_values = CGMSeries_p1_rms_values(:, 1:4);
    
    vector = [CGMSeries_p1_fft_value, CGMSeries_p1_dwt_values, CGMSeries_p1_std_values, CGMSeries_p1_rms_values  ];
    feature_matrix=[feature_matrix; vector];
end

normalized_feature_matrix =normalize(feature_matrix,'norm',1);
%https://medium.com/@urvashilluniya/why-data-normalization-is-necessary-for-machine-learning-models-681b65a05029


% co_varience= cov(feature_matrix);
% eigen_value= eig(co_varience);
% [V,D]= eig(co_varience)

coeff = pca(feature_matrix);
display(coeff)
top_5_coeff = coeff(:,1:5);
updated_feature_matrix= normalized_feature_matrix * top_5_coeff;
display(updated_feature_matrix)
 
for row = 1:5
    subplot(2,5,row)
    plot(coeff(:, row))
    title(['Principal Component- ' num2str(row)]);
end