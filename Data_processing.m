%% Fit parts
clc

Number_of_parts = 5; % !!!

Data_size = numel(X_input);

Part_size = floor(Data_size/Number_of_parts);
Rem_part_size = rem(Data_size, Number_of_parts);

if Rem_part_size ~= 0
    Part_sizes = repmat(Part_size, [1, Number_of_parts-1]);
    Part_sizes(end+1) = Part_size + Rem_part_size;
else
    Part_sizes = repmat(Part_size, [1, Number_of_parts]);
end

clearvars Part_size Rem_part_size i

% Part_sizes

figure
hold on
plot(X_input, Y_input, 'b', 'LineWidth', 1)

Parts_x = cell(1, Number_of_parts);
Parts_y = cell(1, Number_of_parts);
Parts_amp = cell(1, Number_of_parts);
Parts_alpha = cell(1, Number_of_parts);
Parts_amp_error = cell(1, Number_of_parts);
Parts_alpha_error = cell(1, Number_of_parts);
Parts_R_sq = cell(1, Number_of_parts);
for i = 1:Number_of_parts
    Start_ind = sum(Part_sizes(1:i-1))+1;
    Stop_ind = sum(Part_sizes(1:i));

    Range = Start_ind:Stop_ind;
    X_part = X_input(Range);
    Y_part = Y_input(Range);

    [Fit_obj, GOF] = fit(X_part, Y_part, 'log10(A/x^p)', 'lower', [0 0], 'start', [1 1]);
    CI = diff(confint(Fit_obj))/2;
    Amp = Fit_obj.A;
    Alpha = Fit_obj.p;
    Amp_error = CI(1);
    Alpha_error = CI(2);
    R_sq = GOF.rsquare;

    disp(['A = ' num2str(Amp, '%.2e') '  α = ' num2str(Alpha, '%5.2f')])

    Parts_amp{i} = repmat(Amp, [1, numel(X_part)]);
    Parts_alpha{i} = repmat(Alpha, [1, numel(X_part)]);
    Parts_amp_error{i} = repmat(Amp_error, [1, numel(X_part)]);
    Parts_alpha_error{i} = repmat(Alpha_error, [1, numel(X_part)]);
    Parts_R_sq{i} = repmat(R_sq, [1, numel(X_part)]);

    Parts_x{i} = X_part;
    Parts_y{i} = Y_part;

    Y_fit = feval(Fit_obj, X_part);
    plot(X_part, Y_fit, 'r', 'LineWidth', 2)
    xlabel('q')
    ylabel('int')
end

clearvars X_part Y_part

%% Plot coefficients
clc

Amp_values = [];
Alpha_values = [];
Amp_error = [];
Alpha_error = [];
R_sq_full = [];
for i = 1:Number_of_parts
    X_part = Parts_x{i};
    Y_part = Parts_y{i};
    Amp_values = [Amp_values Parts_amp{i}];
    Alpha_values = [Alpha_values Parts_alpha{i}];
    Amp_error = [Amp_error Parts_amp_error{i}];
    Alpha_error = [Alpha_error Parts_alpha_error{i}];
    R_sq_full = [R_sq_full Parts_R_sq{i}];
end


figure

subplot(3, 1, 1)
hold on
plot(X_input, Amp_values, 'LineWidth', 2)
plot(X_input, Amp_values+Amp_error, 'r', 'LineWidth', 0.5)
plot(X_input, Amp_values-Amp_error, 'r', 'LineWidth', 0.5)
set(gca, 'yscale', 'log')
xlabel('q')
ylabel('A')

subplot(3, 1, 2)
hold on
plot(X_input, Alpha_values, 'b', 'LineWidth', 2)
plot(X_input, Alpha_values+Alpha_error, 'r', 'LineWidth', 0.5)
plot(X_input, Alpha_values-Alpha_error, 'r', 'LineWidth', 0.5)
set(gca, 'yscale', 'linear')
xlabel('q')
ylabel('α')

subplot(3, 1, 3)
hold on
plot(X_input, R_sq_full, 'b', 'LineWidth', 2)
yline(0.95, 'r', 'LineWidth', 2)
title('Goodness of fit')
xlabel('q')
ylabel('R^2')



%% Save to file

Output_file_name = 'test_out.txt';

Output_data(1:Data_size, 1) = X_input;
Output_data(1:Data_size, 2) = Amp_values;
Output_data(1:Data_size, 3) = Alpha_values;

writematrix(single(Output_data), Output_file_name, 'Delimiter', ' ');








