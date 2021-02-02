clear
A=[]; % Matrix to hold all the data for different features
j=0;
colsize = [];
plotnames={'acc','emg','gyro','orient','ort_euler'};
emgplotnames={'meane1L','meane2L', 'meane3L', 'meane4L', 'meane5L', 'meane6L', 'meane7L', 'meane8L', 'meane1r', 'meane2r', 'meane3r', 'meane4r', 'meane5r', 'meane6r', 'meane7r', 'meane8r','rmse1L', 'rmse2L', 'rmse3L', 'rmse4L', 'rmse5L', 'rmse6L', 'rmse7L', 'rmse8L', 'rmse1r', 'rmse2r', 'rmse3r', 'rmse4r', 'rmse5r', 'rmse6r', 'rmse7r', 'rmse8r', 'maxe1L', 'maxe2L', 'maxe3L', 'maxe4L', 'maxe5L', 'maxe6L', 'maxe7L', 'maxe8L', 'maxe1r', 'maxe2r', 'maxe3r', 'maxe4r', 'maxe5r', 'maxe6r', 'maxe7r', 'maxe8r', 'vare1L', 'vare2L', 'vare3L', 'vare4L', 'vare5L', 'vare6L', 'vare7L', 'vare8L', 'vare1r', 'vare2r', 'vare3r', 'vare4r', 'vare5r', 'vare6r', 'vare7r', 'vare8r', 'varFFTe1L', 'varFFTe2L', 'varFFTe3L', 'varFFTe4L', 'varFFTe5L', 'varFFTe6L', 'varFFTe7L', 'varFFTe8L','varFFTe1r', 'varFFTe2r', 'varFFTe3r', 'varFFTe4r', 'varFFTe5r', 'varFFTe6r', 'varFFTe7r', 'varFFTe8r'};
feature_names_acc={'meanX','meanY','meanZ','rmsX','rmsY','rmsZ','maxX','maxY','maxZ','varX','varY','varZ','varFFTx','varFFTy','varFFTz', 'meanX', 'meanY', 'meanZ', 'rmsX', 'rmsY', 'rmsZ', 'maxX', 'maxY','maxZ','varX','varY','varZ','varFFTx','varFFTy','varFFTz', 'meanX','meanY','meanZ','meanW','rmsX','rmsY','rmsZ', 'rmsW','maxX','maxY','maxZ','maxW','varX','varY','varZ','varW','varFFTx', 'varFFTy','varFFTz','varFFTw', 'meanroll', 'meanpitch', 'meanyaw', 'rmsroll', 'rmspitch','rmsyaw', 'maxroll', 'maxpitch', 'maxyaw', 'varroll', 'varpitch', 'varyaw', 'varFFTroll', 'varFFTpitch', 'varFFTyaw'};
emgplots={'EMG_mean','EMG_rms','EMG_max','EMGvar','EMGvarFFT'};
% files = dir('C:\Users\Vivek Agarwal\Desktop\DM_A1\*.*');

% reading all the activities
files = dir('*.*');
for i=1:length(files)
    A1=[];
    
    if files(i).isdir == 1
        filename = strcat(files(i).folder,'\',files(i).name);
%         filename = strcat('C:\Users\Vivek Agarwal\Desktop\DM_A1\',files(i).name);
        cd (filename);
        subfiles = dir('*.csv'); % reading all CSV files for each activity
        for k = 1:length(subfiles)
            j=j+1;
            A11=[];
            
            if contains(subfiles(k).name,"emg")==0     % emg has different sampling frequency
                %                 subfiles(k).name
                format short g
                x=csvread(subfiles(k).name,1,1);
                for itr=1:100:(floor(size(x,1)/100)*100)
                    sampled_data=x(itr:itr+99,:);
                    A11=[A11;mean(sampled_data),rms(sampled_data),max(sampled_data),var(sampled_data),var(fft(sampled_data))];
                    %                 A1=[A1,mean(x),rms(x),max(x),diag(cov(x))'];
                end
            else
                %                 subfiles(k).name
                format short g
                x=csvread(subfiles(k).name,1,1);
                for itr = 1: 400: ( floor(size(x,1) / 400) * 400 )
                    sampled_data=x(itr : itr + 399, : );
                    sampled_data = [sampled_data(1:2:end,:),sampled_data(2:2:end,:)];
                    A11 = [A11;mean(sampled_data),rms(sampled_data),max(sampled_data),var(sampled_data),var(fft(sampled_data))];
                end
                %         A=[A;A1];
            end
            %             size(A11);
            colsize(j)=size(A11,2)/5;
            A1 = [A1,A11];
            %             size(A1)
        end
        A = [A ; A1];
        cd ..
    end
end

% Plotting graphs for each feature and each activity. Time along X-axis and
% Data point along Y-axis

%plotting starts

feature_plots = '.\Plots_Features_Selection\';
i=1;
next=0;
for p=1: length(colsize)/2
    if(p~=2)
    figure('Name',plotnames{p},'NumberTitle','off');
% figure(r);
    for r=1: colsize(p) * 5
        subplot(colsize(p),5,r);
        tx_vect= A(1:80,r+next);
        ty_vect=A(81:160,r+next);
        scatter(1:80,tx_vect,'o','blue')
        hold on;
        scatter(1:80,ty_vect,'^','green')
           xlabel('Timestamp') 
           ylabel('FeatureVal')            
        title(feature_names_acc{i});
        i=i+1;
    end
    next=r;
    saveas(gcf,strcat(feature_plots, strcat('Plot_',plotnames{p})), 'jpeg');
    else
        next=95;
    end
end

i=1;
next=15;
for p=1:5
figure('Name',emgplots{p},'NumberTitle','off');
for r=1:16
        Plotname= subplot(4,4,r);
        tx_vect= A(1:80,r+next);
        ty_vect=A(81:160,r+next);
        scatter(1:80,tx_vect,'o','blue')
        hold on;
        scatter(1:80,ty_vect,'^','green')
       % set( get(Plotname,'XLabel'), 'String', 'This is the X label' );
           xlabel('Timestamp') 
           ylabel('FeatureVal')
        title(emgplotnames{i});
        i=i+1;
end
%title(feature_emg{p})
next=next+r;
saveas(gcf,strcat(feature_plots, strcat('Plot_',emgplots{p})), 'jpeg');
end


% plotting ends

% Ground for PCA
% Normalizing the values before applying PCA, otherwise results would be
% incorrect

X_norm=[];
A_selected= A(:,[3 6 9 47 55 63 94 96 127 144]);
A_normailzed_final=[];
for i = 1:size(A_selected,2)
    X_norm= A_selected(:,i);
    % min(X_norm);
    % max(X_norm);
    X_norm = (X_norm-min(X_norm))/(max(X_norm)-min(X_norm));
    A_normailzed_final = [A_normailzed_final, X_norm];
    X_norm=[];
end

% Applying PCA for Cooking and Eating individually first and then again
% applying PCA for cumulative data for both activities

[coeff1,score1,latent1,tsquared1,explained1] = pca(A_normailzed_final(1:80,:));
[coeff2,score2,latent2,tsquared2,explained2] = pca(A_normailzed_final(81:end,:));

[coeff,score,latent,tsquared,explained] = pca(A_normailzed_final);

%PCA calculation ends

%plotting for pca for activity1 STARTS

feature_plots = '.\PCA_Activity1\';

figure('Name','EigenVectorsA1','NumberTitle','off');
bar(coeff1);
saveas(gcf,strcat(feature_plots, 'EigenVectorsA1'), 'jpeg');

plotpca={'f1','f2','f3','f4','f5','f6','f7','f8','f9','f10'};
for p=1: 10
    
    figure('Name',plotpca{p},'NumberTitle','off');
    tx_vect= score1(1:80,p);
    scatter(1:80,tx_vect,'r')

    xlabel('Timestamp') 
    ylabel('Feature Values')
    saveas(gcf,strcat(feature_plots, strcat('Plot_',plotpca{p})), 'jpeg');
end
figure();
pareto(explained1);
title('Variance Explained A1');
saveas(gcf,strcat(feature_plots, strcat('Plot_','Variance Explained A1')), 'jpeg');
%plotting for pca for activity1 ENDS

%plotting for pca for activity1 STARTS

feature_plots = '.\PCA_Activity2\';

figure('Name','EigenVectorsA2','NumberTitle','off');
bar(coeff2);
saveas(gcf,strcat(feature_plots, 'EigenVectorsA2'), 'jpeg');

plotpca={'f1','f2','f3','f4','f5','f6','f7','f8','f9','f10'};
for p=1: 10
    
    figure('Name',plotpca{p},'NumberTitle','off');
    tx_vect= score2(:,p);
    scatter(1:147,tx_vect,'blue')
    xlabel('Timestamp') 
    ylabel('Feature Values')
    saveas(gcf,strcat(feature_plots, strcat('Plot_',plotpca{p})), 'jpeg');
end
figure();
pareto(explained2);
title('Variance Explained A2');
saveas(gcf,strcat(feature_plots, strcat('Plot_','Variance Explained A2')), 'jpeg');
%plotting for pca for activity2 ENDS


%plots for PCA for both Activities together starts
feature_plots = '.\Plots_after_PCA\';

figure('Name','EigenVectors','NumberTitle','off');
bar(coeff);
saveas(gcf,strcat(feature_plots, 'EigenVectors'), 'jpeg');

plotpca={'f1','f2','f3','f4','f5','f6','f7','f8','f9','f10'};
for p=1: 10
    figure('Name',plotpca{p},'NumberTitle','off');
    
    tx_vect= score(1:80,p);
    ty_vect=score(81:160,p);
    scatter(1:80,tx_vect,'r')
    hold on;
    scatter(1:80,ty_vect,'b')
    xlabel('Timestamp in order') 
    ylabel('Feature Values')
    legend({'Cooking','Eating'},'Location','northeast')
    saveas(gcf,strcat(feature_plots, strcat('Plot_',plotpca{p})), 'jpeg');
end
hold off;

figure();
pareto(latent);
title('Variance Distribution')
saveas(gcf,strcat(feature_plots, strcat('Plot_','Variance Distribution')), 'jpeg');

figure();
pareto(explained);
title('Percentage of Variance Explained');
saveas(gcf,strcat(feature_plots, strcat('Plot_','Percentage of Variance Explained')), 'jpeg');

%plots for PCA ends



%fclose('all');
clearvars A1 A11 ans colsize emgplots plotnames plotpca feature_plots  i itr j k next r tx_vect ty_vect x X_norm subfiles p sampled_data;
close all   % This will close all plots