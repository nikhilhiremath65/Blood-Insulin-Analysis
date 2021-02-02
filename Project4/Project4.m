InsulinBolusLunchPart1 = readmatrix("InsulinBolusLunchPat1.csv");
InsulinBolusLunchPart2 = readmatrix("InsulinBolusLunchPat2.csv");
InsulinBolusLunchPart3 = readmatrix("InsulinBolusLunchPat3.csv");
InsulinBolusLunchPart4 = readmatrix("InsulinBolusLunchPat4.csv");
InsulinBolusLunchPart5 = readmatrix("InsulinBolusLunchPat5.csv");

% Question1

IB =[];
for row=1:size(InsulinBolusLunchPart1, 1)
   IB = [IB ; max(InsulinBolusLunchPart1(row,:))] ;
end

IB