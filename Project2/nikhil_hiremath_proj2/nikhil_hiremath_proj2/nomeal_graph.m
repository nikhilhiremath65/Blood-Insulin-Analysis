
% Load Nomeal1 data
Nomeal1 = readmatrix("Nomeal1.csv");
Nomeal2 = readmatrix("Nomeal2.csv");
Nomeal3 = readmatrix("Nomeal3.csv");
Nomeal4 = readmatrix("Nomeal4.csv");
Nomeal5 = readmatrix("Nomeal5.csv");

Nomeal = [Nomeal1;Nomeal2;Nomeal3; Nomeal4; Nomeal5];



for row=1:size(Nomeal, 1)
    fig = plot(Nomeal(row, :));
    %disp(fig);
    filename = sprintf("NomealPlots\\row%d", row);
    disp(filename);
    saveas(fig, filename, 'jpeg');
end