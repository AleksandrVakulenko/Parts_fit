
function [vout, residual] = My_Fit(X_real, Y_real)

c_init = (Y_real(1) - Y_real(end))/(X_real(1) - X_real(end));
d_init = Y_real(1) - c_init*X_real(1);

Fit_poly = fit(X_real, Y_real, 'a*x^3+b*x^2+c*x+d', 'start', [0 1 c_init d_init]); % FIXME: start problem
model_f = @(v) Model_function(v, X_real, Y_real, Fit_poly);

Y_line = c_init*X_real+d_init;
Y_poly = feval(Fit_poly, X_real);
% figure
% plot(X_real, Y_poly, 'g')


Lower = [  0   0];
Start = [  1   1];
Upper = [inf inf];


options = optimoptions('lsqnonlin', ...
    'FiniteDifferenceType','central', ...
    'MaxFunctionEvaluations', 80000, ...
    'FunctionTolerance', 1E-10, ...
    'Algorithm','trust-region-reflective', ... %levenberg-marquardt trust-region-reflective
    'MaxIterations', 5000, ...
    'StepTolerance', 1e-10, ...
    'PlotFcn', '', ... %optimplotresnorm optimplotstepsize OR ''  (for none)
    'Display', 'off', ... %final off iter
    'FiniteDifferenceStepSize', 1e-10, ...
    'CheckGradients', true, ...
    'DiffMaxChange', 0.01);

[vout, resnorm, residual, ~, ~, ~, jacobian] = lsqnonlin(model_f, Start, Lower, Upper, options);
% resnorm

% figure
% plot(residual)

% Y_model = log10(vout(1)./X_real.^vout(2));
% figure
% hold on
% plot(X_real, Y_real)
% plot(X_real, Y_model)


% a = Fit_poly.a;
% b = Fit_poly.b;
% c = Fit_poly.c;
% Derivative_data = a*3*X_real.^2+b*2*X_real+c;
% Derivative_of_fit = -vout(2)./(log(10)*X_real);
% 
% figure
% hold on
% title("!!!!!")
% plot(X_real, Derivative_data, 'b')
% plot(X_real, Derivative_of_fit, 'r')
% 
% figure
end


function residuals = Model_function(Coeffs, X_data, Y_data, Der_poly_coeffs)
a = Der_poly_coeffs.a;
b = Der_poly_coeffs.b;
c = Der_poly_coeffs.c;
Derivative_data = a*3*X_data.^2+b*2*X_data+c;

Amp = Coeffs(1);
Alpha = Coeffs(2);

Derivative_of_fit = -Alpha./(log(10)*X_data);

Y_model = log10(Amp./X_data.^Alpha);

residuals_data = Y_data - Y_model;
residuals_der = Derivative_data - Derivative_of_fit;

% Relative = Y_data./Y_model;
% if max(abs(Relative-1)) > 0.01
%     Res_weight = 0;
% else
%     Res_weight = 1;
% end
Res_weight = 10.0;

% residuals = [residuals_data'./Y_data' residuals_der'./Derivative_data'];
% residuals = [residuals_data'];
residuals = [residuals_data' Res_weight*residuals_der'];
end














