%% Fit parts
clc

Window_size = 25; % !!!
Data_size = numel(X_input);

% Part_sizes

figure
hold on
plot(X_input, Y_input, 'b', 'LineWidth', 1)

Amp_values = zeros(size(Data_size));
Alpha_values = zeros(size(Data_size));
for i = 1:Data_size
    
    Start_ind = i;
    End_ind = i + Window_size;

    Shift = 0;
    if Start_ind <= 0
        Shift = 1 - Start_ind;
    end
    if End_ind > Data_size
        Shift = Data_size - End_ind;
    end
    Start_ind = Start_ind + Shift;
    End_ind = End_ind + Shift;

    Range = Start_ind:End_ind;
    X_part = X_input(Range);
    Y_part = Y_input(Range);

%     plot(repmat(i, [1, numel(Range)]), Range, '.')

    vout = My_Fit(X_part, Y_part);
    Amp_values(i) = vout(1);
    Alpha_values(i) = vout(2);


    Y_fit = log10(Amp_values(i)./X_part.^Alpha_values(i));
    plot(X_part, Y_fit, 'r', 'LineWidth', 2)
%     plot(residual)
    xlabel('q')
    ylabel('int')
end

clearvars X_part Y_part

%% Plot coefficients



figure

subplot(2, 1, 1)
hold on
plot(X_input, Amp_values, '.-b', 'LineWidth', 0.1)
% plot(X_input, Amp_values+Amp_error, 'r', 'LineWidth', 0.5)
% plot(X_input, Amp_values-Amp_error, 'r', 'LineWidth', 0.5)
set(gca, 'yscale', 'log')
xlabel('q')
ylabel('A')

subplot(2, 1, 2)
hold on
plot(X_input, Alpha_values, '.-b', 'LineWidth', 0.1)
% plot(X_input, Alpha_values+Alpha_error, 'r', 'LineWidth', 0.5)
% plot(X_input, Alpha_values-Alpha_error, 'r', 'LineWidth', 0.5)
set(gca, 'yscale', 'linear')
xlabel('q')
ylabel('α')




%% Save to file

Output_file_name = 'test_out.txt';

Output_data(1:Data_size, 1) = X_input;
Output_data(1:Data_size, 2) = Amp_values;
Output_data(1:Data_size, 3) = Alpha_values;

writematrix(single(Output_data), Output_file_name, 'Delimiter', ' ');








