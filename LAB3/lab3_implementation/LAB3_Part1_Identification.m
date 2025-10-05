%% LAB3 - Part 1: Plant Reduction and FOPDT Identification
% IOSC 2025-PUCPR
% Identification and Modeling of Control Systems
%
% This script identifies first-order models with delay (FOPDT) for both
% M1 and M2 plants using multiple methods:
% - Graphical identification
% - System Identification Toolbox
%
% Author: Lab3 Implementation
% Date: 2025

clear; clc; close all;

%% ========================================================================
%  SECTION 1: Setup and Plant Definitions
%  ========================================================================

fprintf('====================================================\n');
fprintf('LAB3 - Part 1: FOPDT Model Identification\n');
fprintf('====================================================\n\n');

% Define Laplace variable
s = tf('s');

% Plant M1: 4th-order system with delay (from LAB2)
M1 = 1 / ((s+1)*(0.4*s+1)*(0.4^2*s+1)*(0.4^3*s+1));
M1.InputDelay = 1;  % 1 second delay

fprintf('M1(s) = 1*e^(-s) / [(s+1)(0.4s+1)(0.16s+1)(0.064s+1)]\n\n');

% Plant M2: 3rd-order system with non-minimum phase zero
M2 = (-1.1*s + 1) / (s^3 + 3*s^2 + 3*s + 1);

fprintf('M2(s) = (-1.1s + 1) / (s^3 + 3s^2 + 3s + 1)\n');
fprintf('Note: M2 has non-minimum phase zero (inverse response)\n\n');

% Simulation parameters
t_sim = 0:0.01:20;  % Time vector for simulation

%% ========================================================================
%  SECTION 2: M1 Identification
%  ========================================================================

fprintf('--------------------------------------------------\n');
fprintf('IDENTIFYING M1...\n');
fprintf('--------------------------------------------------\n');

% Get step response data for M1
[y_M1, t_M1] = step(M1, t_sim);

% === Method 1: Graphical Identification (Smith Method) ===
fprintf('\nMethod 1: Graphical Identification (Smith Method)\n');

% Find steady-state gain
K_M1 = y_M1(end);
fprintf('  Steady-state gain K = %.4f\n', K_M1);

% Find delay (θ) - time when response starts (reaches 5% of final value)
idx_start = find(y_M1 >= 0.05*K_M1, 1, 'first');
theta_M1 = t_M1(idx_start);
fprintf('  Delay θ = %.4f s\n', theta_M1);

% Find time constant (T) - from 28.3% to 63.2% method
% After delay, normalize the response
y_M1_normalized = (y_M1 - y_M1(idx_start)) / (K_M1 - y_M1(idx_start));

% Find 28.3% point
idx_28 = find(y_M1_normalized >= 0.283, 1, 'first');
t_28 = t_M1(idx_28);

% Find 63.2% point
idx_63 = find(y_M1_normalized >= 0.632, 1, 'first');
t_63 = t_M1(idx_63);

% Calculate time constant
T_M1 = 1.5 * (t_63 - t_28);
fprintf('  Time constant T = %.4f s\n', T_M1);

% Create FOPDT model for M1 (graphical method)
G1_graphical = K_M1 * exp(-theta_M1*s) / (T_M1*s + 1);

% === Method 2: System Identification Toolbox ===
fprintf('\nMethod 2: System Identification Toolbox\n');

% Prepare data for System ID Toolbox
data_M1 = iddata(y_M1, ones(size(t_M1)), t_M1(2)-t_M1(1));

try
    % Estimate first-order model with delay
    sys_M1 = tfest(data_M1, 1, 0);

    % Extract parameters
    [num_M1, den_M1] = tfdata(sys_M1, 'v');
    K_M1_tb = num_M1(end) / den_M1(end);
    T_M1_tb = den_M1(1) / den_M1(end);
    theta_M1_tb = sys_M1.InputDelay;

    fprintf('  K = %.4f, T = %.4f s, θ = %.4f s\n', K_M1_tb, T_M1_tb, theta_M1_tb);

    % Create toolbox model
    G1_toolbox = K_M1_tb * exp(-theta_M1_tb*s) / (T_M1_tb*s + 1);

catch ME
    fprintf('  Warning: System ID Toolbox failed. Using graphical model.\n');
    fprintf('  Error: %s\n', ME.message);
    G1_toolbox = G1_graphical;
    K_M1_tb = K_M1;
    T_M1_tb = T_M1;
    theta_M1_tb = theta_M1;
end

% === Calculate Error Metrics for M1 ===
fprintf('\nError Metrics for M1:\n');

% Graphical model
[y_G1_graph, t_G1_graph] = step(G1_graphical, t_sim);
rmse_M1_graph = sqrt(mean((y_M1 - y_G1_graph).^2));
iae_M1_graph = trapz(t_M1, abs(y_M1 - y_G1_graph));
tv_M1_graph = sum(abs(diff(y_G1_graph)));

fprintf('  Graphical Model: RMSE=%.4f, IAE=%.4f, TV=%.4f\n', ...
    rmse_M1_graph, iae_M1_graph, tv_M1_graph);

% Toolbox model
[y_G1_tb, t_G1_tb] = step(G1_toolbox, t_sim);
rmse_M1_tb = sqrt(mean((y_M1 - y_G1_tb).^2));
iae_M1_tb = trapz(t_M1, abs(y_M1 - y_G1_tb));
tv_M1_tb = sum(abs(diff(y_G1_tb)));

fprintf('  Toolbox Model:   RMSE=%.4f, IAE=%.4f, TV=%.4f\n', ...
    rmse_M1_tb, iae_M1_tb, tv_M1_tb);

%% ========================================================================
%  SECTION 3: M2 Identification
%  ========================================================================

fprintf('\n--------------------------------------------------\n');
fprintf('IDENTIFYING M2...\n');
fprintf('--------------------------------------------------\n');

% Get step response data for M2
[y_M2, t_M2] = step(M2, t_sim);

% === Method 1: Graphical Identification (Adapted for Inverse Response) ===
fprintf('\nMethod 1: Graphical Identification (Adapted for Inverse Response)\n');

% Find steady-state gain
K_M2 = y_M2(end);
fprintf('  Steady-state gain K = %.4f\n', K_M2);

% M2 has inverse response - goes negative first
[y_min, idx_min] = min(y_M2);
fprintf('  Minimum value = %.4f at t = %.4f s\n', y_min, t_M2(idx_min));

% Find where response crosses zero and becomes positive
idx_zero = find(y_M2(idx_min:end) > 0, 1, 'first') + idx_min - 1;
if isempty(idx_zero)
    idx_zero = idx_min;
end

% Use the positive-going portion for identification
y_M2_positive = y_M2(idx_zero:end);
t_M2_positive = t_M2(idx_zero:end) - t_M2(idx_zero);  % Reset time

% Normalize
y_M2_norm = (y_M2_positive - y_M2_positive(1)) / (K_M2 - y_M2_positive(1));

% Find characteristic times
idx_28_M2 = find(y_M2_norm >= 0.283, 1, 'first');
idx_63_M2 = find(y_M2_norm >= 0.632, 1, 'first');

if ~isempty(idx_28_M2) && ~isempty(idx_63_M2)
    t_28_M2 = t_M2_positive(idx_28_M2);
    t_63_M2 = t_M2_positive(idx_63_M2);

    % Calculate parameters
    T_M2 = 1.5 * (t_63_M2 - t_28_M2);
    theta_M2 = t_M2(idx_zero) + t_63_M2 - T_M2;  % Apparent delay

    fprintf('  Time constant T = %.4f s\n', T_M2);
    fprintf('  Delay θ = %.4f s\n', theta_M2);
else
    % Fallback values
    fprintf('  Warning: Could not find characteristic points.\n');
    fprintf('  Using approximate values.\n');
    T_M2 = 1.0;
    theta_M2 = 0.5;
end

% Create FOPDT model for M2 (graphical method)
G2_graphical = K_M2 * exp(-theta_M2*s) / (T_M2*s + 1);

% === Method 2: System Identification Toolbox ===
fprintf('\nMethod 2: System Identification Toolbox\n');

% Prepare data
data_M2 = iddata(y_M2, ones(size(t_M2)), t_M2(2)-t_M2(1));

try
    % Estimate first-order model
    sys_M2 = tfest(data_M2, 1, 0);

    % Extract parameters
    [num_M2, den_M2] = tfdata(sys_M2, 'v');
    K_M2_tb = num_M2(end) / den_M2(end);
    T_M2_tb = den_M2(1) / den_M2(end);
    theta_M2_tb = sys_M2.InputDelay;

    fprintf('  K = %.4f, T = %.4f s, θ = %.4f s\n', K_M2_tb, T_M2_tb, theta_M2_tb);

    % Create toolbox model
    G2_toolbox = K_M2_tb * exp(-theta_M2_tb*s) / (T_M2_tb*s + 1);

catch ME
    fprintf('  Warning: System ID Toolbox failed. Using graphical model.\n');
    fprintf('  Error: %s\n', ME.message);
    G2_toolbox = G2_graphical;
    K_M2_tb = K_M2;
    T_M2_tb = T_M2;
    theta_M2_tb = theta_M2;
end

% === Calculate Error Metrics for M2 ===
fprintf('\nError Metrics for M2:\n');

% Graphical model
[y_G2_graph, t_G2_graph] = step(G2_graphical, t_sim);
rmse_M2_graph = sqrt(mean((y_M2 - y_G2_graph).^2));
iae_M2_graph = trapz(t_M2, abs(y_M2 - y_G2_graph));
tv_M2_graph = sum(abs(diff(y_G2_graph)));

fprintf('  Graphical Model: RMSE=%.4f, IAE=%.4f, TV=%.4f\n', ...
    rmse_M2_graph, iae_M2_graph, tv_M2_graph);

% Toolbox model
[y_G2_tb, t_G2_tb] = step(G2_toolbox, t_sim);
rmse_M2_tb = sqrt(mean((y_M2 - y_G2_tb).^2));
iae_M2_tb = trapz(t_M2, abs(y_M2 - y_G2_tb));
tv_M2_tb = sum(abs(diff(y_G2_tb)));

fprintf('  Toolbox Model:   RMSE=%.4f, IAE=%.4f, TV=%.4f\n', ...
    rmse_M2_tb, iae_M2_tb, tv_M2_tb);

%% ========================================================================
%  SECTION 4: Final Model Selection and Summary
%  ========================================================================

fprintf('\n====================================================\n');
fprintf('SUMMARY: Best FOPDT Models for PID Design\n');
fprintf('====================================================\n\n');

% Select best models based on RMSE
if rmse_M1_graph < rmse_M1_tb
    G1_final = G1_graphical;
    K1_final = K_M1;
    T1_final = T_M1;
    theta1_final = theta_M1;
    method1 = 'Graphical';
else
    G1_final = G1_toolbox;
    K1_final = K_M1_tb;
    T1_final = T_M1_tb;
    theta1_final = theta_M1_tb;
    method1 = 'Toolbox';
end

if rmse_M2_graph < rmse_M2_tb
    G2_final = G2_graphical;
    K2_final = K_M2;
    T2_final = T_M2;
    theta2_final = theta_M2;
    method2 = 'Graphical';
else
    G2_final = G2_toolbox;
    K2_final = K_M2_tb;
    T2_final = T_M2_tb;
    theta2_final = theta_M2_tb;
    method2 = 'Toolbox';
end

fprintf('M1 Selected Model (%s):\n', method1);
fprintf('  K = %.4f, T = %.4f s, θ = %.4f s\n', K1_final, T1_final, theta1_final);
fprintf('  G1(s) = %.4f * e^(-%.4fs) / (%.4fs + 1)\n\n', K1_final, theta1_final, T1_final);

fprintf('M2 Selected Model (%s):\n', method2);
fprintf('  K = %.4f, T = %.4f s, θ = %.4f s\n', K2_final, T2_final, theta2_final);
fprintf('  G2(s) = %.4f * e^(-%.4fs) / (%.4fs + 1)\n\n', K2_final, theta2_final, T2_final);

%% ========================================================================
%  SECTION 5: Generate Comparison Plots
%  ========================================================================

fprintf('Generating plots...\n');

% Plot M1 comparison
figure('Position', [100, 100, 1200, 500]);

subplot(1,2,1);
plot(t_M1, y_M1, 'b-', 'LineWidth', 2); hold on;
plot(t_G1_graph, y_G1_graph, 'r--', 'LineWidth', 1.5);
plot(t_G1_tb, y_G1_tb, 'g:', 'LineWidth', 1.5);
grid on;
xlabel('Time (s)');
ylabel('Output');
title('M1: Step Response Comparison');
legend('M1 Original', 'FOPDT Graphical', 'FOPDT Toolbox', 'Location', 'best');

subplot(1,2,2);
plot(t_M1, y_M1, 'b-', 'LineWidth', 2); hold on;
plot(t_M1, step(G1_final, t_sim), 'r--', 'LineWidth', 2);
grid on;
xlabel('Time (s)');
ylabel('Output');
title(['M1: Selected Model (', method1, ')']);
legend('M1 Original', 'Selected FOPDT', 'Location', 'best');

saveas(gcf, 'M1_identification_results.png');

% Plot M2 comparison
figure('Position', [100, 100, 1200, 500]);

subplot(1,2,1);
plot(t_M2, y_M2, 'b-', 'LineWidth', 2); hold on;
plot(t_G2_graph, y_G2_graph, 'r--', 'LineWidth', 1.5);
plot(t_G2_tb, y_G2_tb, 'g:', 'LineWidth', 1.5);
grid on;
xlabel('Time (s)');
ylabel('Output');
title('M2: Step Response Comparison (Note: Inverse Response)');
legend('M2 Original', 'FOPDT Graphical', 'FOPDT Toolbox', 'Location', 'best');

subplot(1,2,2);
plot(t_M2, y_M2, 'b-', 'LineWidth', 2); hold on;
plot(t_M2, step(G2_final, t_sim), 'r--', 'LineWidth', 2);
grid on;
xlabel('Time (s)');
ylabel('Output');
title(['M2: Selected Model (', method2, ')']);
legend('M2 Original', 'Selected FOPDT', 'Location', 'best');

saveas(gcf, 'M2_identification_results.png');

% Plot error metrics comparison
figure('Position', [100, 100, 800, 600]);

% Create comparison data
models = {'M1 Graph', 'M1 Toolbox', 'M2 Graph', 'M2 Toolbox'};
rmse_vals = [rmse_M1_graph, rmse_M1_tb, rmse_M2_graph, rmse_M2_tb];
iae_vals = [iae_M1_graph, iae_M1_tb, iae_M2_graph, iae_M2_tb];

subplot(2,1,1);
bar(rmse_vals);
set(gca, 'XTickLabel', models);
ylabel('RMSE');
title('RMSE Comparison');
grid on;

subplot(2,1,2);
bar(iae_vals);
set(gca, 'XTickLabel', models);
ylabel('IAE');
title('IAE Comparison');
grid on;

saveas(gcf, 'error_metrics_comparison.png');

%% ========================================================================
%  SECTION 6: Save Results for Part 2
%  ========================================================================

fprintf('\nSaving results to LAB3_Part1_models.mat...\n');

save('LAB3_Part1_models.mat', ...
    'M1', 'M2', ...
    'G1_final', 'G2_final', ...
    'K1_final', 'T1_final', 'theta1_final', ...
    'K2_final', 'T2_final', 'theta2_final', ...
    't_sim');

fprintf('\n====================================================\n');
fprintf('Part 1 Complete!\n');
fprintf('Models saved for Part 2 (PID Design)\n');
fprintf('====================================================\n');
