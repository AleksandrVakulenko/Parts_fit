%% Fit parts
clc

Number_of_parts = 20; % !!!

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
Parts_amp_init = cell(1, Number_of_parts);
Parts_alpha_init = cell(1, Number_of_parts);
for i = 1:Number_of_parts
    Start_ind = sum(Part_sizes(1:i-1))+1;
    Stop_ind = sum(Part_sizes(1:i));

    Range = Start_ind:Stop_ind;
    X_part = X_input(Range);
    Y_part = Y_input(Range);

    Fit_obj = fit(X_part, Y_part, 'log10(A/x^p)', 'lower', [0 0], 'start', [1 1]);
    Amp_init = Fit_obj.A;
    Alpha_init = Fit_obj.p;

    disp(['A = ' num2str(Amp_init, '%.2e') '  α = ' num2str(Alpha_init, '%5.2f')])

    Parts_amp_init{i} = repmat(Amp_init, [1, numel(X_part)]);
    Parts_alpha_init{i} = repmat(Alpha_init, [1, numel(X_part)]);

    Parts_x{i} = X_part;
    Parts_y{i} = Y_part;

    Y_fit = feval(Fit_obj, X_part);
    plot(X_part, Y_fit, 'r', 'LineWidth', 2)
    xlabel('q')
    ylabel('int')
end

clearvars X_part Y_part

%% Plot coefficients


Amp_values = [];
Alpha_values = [];
for i = 1:Number_of_parts
    X_part = Parts_x{i};
    Y_part = Parts_y{i};
    Amp_values = [Amp_values Parts_amp_init{i}];
    Alpha_values = [Alpha_values Parts_alpha_init{i}];
end


figure

subplot(2, 1, 1)
hold on
plot(X_input, Amp_values, 'LineWidth', 2)
set(gca, 'yscale', 'log')
xlabel('q')
ylabel('A')

subplot(2, 1, 2)
hold on
plot(X_input, Alpha_values, 'LineWidth', 2)
set(gca, 'yscale', 'linear')
xlabel('q')
ylabel('α')


%% Save to file

Output_file_name = 'test_out.txt';

Output_data(1:Data_size, 1) = X_input;
Output_data(1:Data_size, 2) = Amp_values;
Output_data(1:Data_size, 3) = Alpha_values;

writematrix(single(Output_data), Output_file_name, 'Delimiter', ' ');








