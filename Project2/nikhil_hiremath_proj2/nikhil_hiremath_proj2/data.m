mealData1 = readmatrix("mealData1.csv");
mealData2 = readmatrix("mealData2.csv");
mealData3 = readmatrix("mealData3.csv");
mealData4 = readmatrix("mealData4.csv");
mealData5 = readmatrix("mealData5.csv");


mealData= [mealData1;mealData2;mealData3;mealData4;mealData5];

for row=1:size(mealData, 1)
    fig = plot(mealData(row, :));
    %disp(fig);
    filename = sprintf("plots\\row%d", row);
    disp(filename);
    saveas(fig, filename, 'jpeg');
end