

load("data.mat")
clearvars s

%% background correction

p = 0.9;
tail_range = round(numel(q)*p):numel(q);
Background = mean(int(tail_range));
int_nobg = int - Background;
int_nobg(int_nobg<0) = 0;

figure
hold on
plot(q, int)
plot(q, int_nobg)
% set(gca,'xscale', 'log')
set(gca,'yscale', 'log')


%%  cut of noisy data
clc

intcor_log = log10(int_nobg);

Data_group_size = 0.05; % FIXME: debug value

SZ = round(Data_group_size*numel(intcor_log));

N = round(numel(intcor_log)/SZ);

% figure %FIXME: debug plot
% hold on

group_end_ind_prev = [];
for i = 1:N
    group_start_ind = SZ*(i-1)+1;
    group_end_ind = SZ*(i)+1;
    % disp([num2str(group_start_ind) ' - ' num2str(group_end_ind)])
    Range = group_start_ind:group_end_ind;
    X_part = q(Range);
    Y_part = intcor_log(Range);

    Inf_range = isinf(Y_part);
    X_part(Inf_range) = [];
    Y_part(Inf_range) = [];


    [Fit_obj, GOF] = fit(X_part, Y_part, 'a*x+b', 'start', [0 0]);
    % plot(X_part, Y_part, 'b') %FIXME: debug plot

    Y_line = feval(Fit_obj, X_part);
    % plot(X_part, Y_line, 'r') %FIXME: debug plot

    % plot(X_part, (Y_part-Y_line).^2, 'r') %FIXME: debug plot

    Rsquare = GOF.rsquare;
    Trigger_value = 0.85; %FIXME: debug value

    if Rsquare < Trigger_value
        Output_range = 1:group_end_ind_prev;
        break
    end

    group_end_ind_prev = group_end_ind;
end

% Output_range

q_cor = q(Output_range);
intcor = int_nobg(Output_range);
intcor_log = log10(intcor);

%%


% figure
hold on
plot(q_cor, intcor_log)
% set(gca,'xscale', 'log')
% set(gca,'yscale', 'log')


%%
X_input = q_cor;
Y_input = intcor_log;

clearvars -except X_input Y_input 


%%


























