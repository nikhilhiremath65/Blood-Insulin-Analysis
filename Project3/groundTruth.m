% Load mealAmountData data
mealAmountData1 = readmatrix("mealAmountData1.csv");
mealAmountData2 = readmatrix("mealAmountData2.csv");
mealAmountData3 = readmatrix("mealAmountData3.csv");
mealAmountData4 = readmatrix("mealAmountData4.csv");
mealAmountData5 = readmatrix("mealAmountData5.csv");

mealAmountData1_filtered = mealAmountData1(1:51,:);
mealAmountData2_filtered = mealAmountData2(1:51,:);
mealAmountData3_filtered = mealAmountData3(1:51,:);
mealAmountData4_filtered = mealAmountData4(1:51,:);
mealAmountData5_filtered = mealAmountData5(1:51,:);

mealAmountData = [mealAmountData1_filtered ; mealAmountData2_filtered; mealAmountData3_filtered; mealAmountData4_filtered; mealAmountData5_filtered];


gTruth =[];

for i = 1:(size(mealAmountData ,1))
    if mealAmountData(i)== 0
       vector =  [1 mealAmountData(i)];
    elseif (mealAmountData(i)> 0 && mealAmountData(i) <= 20)   
       vector =  [2 mealAmountData(i)];
    elseif (mealAmountData(i)> 20 && mealAmountData(i) <= 40)   
       vector =  [3 mealAmountData(i)];
    elseif (mealAmountData(i)> 40 && mealAmountData(i) <= 60)   
       vector =  [4 mealAmountData(i)];
     elseif (mealAmountData(i)> 60 && mealAmountData(i) <= 80)   
       vector =  [5 mealAmountData(i)];
     elseif (mealAmountData(i)> 100 && mealAmountData(i) <= 120)   
       vector =  [6 mealAmountData(i)];
    
    end  
    gTruth = [gTruth ; vector];
end

keys =   gTruth(:,1);
values1 =  gTruth(:,2);

M = containers.Map(keys,values1);






% containerKeys = {};
% containerValues =[];


% groundTruth = containers.Map('KeyType','char','ValueType','double');
% 
%for i = 1:(size(mealAmountData ,1))
%    if mealAmountData(i)== 0
%        groundTruth('1') = mealAmountData(i);
%    elseif (mealAmountData(i)> 0 && mealAmountData(i) <= 20)
%        groundTruth('2') = mealAmountData(i); 
%    elseif (mealAmountData(i)> 20 && mealAmountData(i) <= 40)
%        groundTruth('3') = mealAmountData(i);
%    elseif (mealAmountData(i)> 40 && mealAmountData(i) <= 60)
%        groundTruth('4') = mealAmountData(i);
%    elseif (mealAmountData(i)> 60 && mealAmountData(i) <= 80)
%        groundTruth('5') = mealAmountData(i);
%    elseif (mealAmountData(i)> 80 && mealAmountData(i) <= 100)
%        groundTruth('6') = mealAmountData(i);
%    elseif (mealAmountData(i)> 100 && mealAmountData(i) <= 120)
%        groundTruth('7') = mealAmountData(i);
%    elseif (mealAmountData(i)> 120 && mealAmountData(i) <= 140)
%        groundTruth('8') = mealAmountData(i);
%    end
% end


% topEdge = 8;
% botEdge = 1;
% numBins = 8;
% 
% binEdges = linspace(botEdge, topEdge, numBins+1);
% [h,whichBin] = histcounts(mealAmountData, numBins);





