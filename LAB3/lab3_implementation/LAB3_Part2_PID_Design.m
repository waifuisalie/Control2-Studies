%% LAB3 - Part 2: PID Controller Design
% IOSC 2025-PUCPR
% Critical Analysis of PID Tuning Rules
%
% This script calculates PID controller parameters for M1 and M2 using
% three different tuning rules:
% 1. Ziegler-Nichols (Z-N) - FOPDT method
% 2. AMIGO
% 3. Skogestad/SIMC
%
% Author: Lab3 Implementation
% Date: 2025

clear; clc; close all;

%% ========================================================================
%  SECTION 1: Load Identified Models from Part 1
%  ========================================================================

fprintf('====================================================\n');
fprintf('LAB3 - Part 2: PID Controller Design\n');
fprintf('====================================================\n\n');

% Load the identified FOPDT models
if ~exist('LAB3_Part1_models.mat', 'file')
    error('Part 1 models not found! Please run LAB3_Part1_Identification.m first.');
end

load('LAB3_Part1_models.mat');

fprintf('Loaded FOPDT Models:\n');
fprintf('M1: K=%.4f, T=%.4f s, θ=%.4f s\n', K1_final, T1_final, theta1_final);
fprintf('M2: K=%.4f, T=%.4f s, θ=%.4f s\n\n', K2_final, T2_final, theta2_final);

% Laplace variable
s = tf('s');

%% ========================================================================
%  SECTION 2: PID Tuning Rules Implementation
%  ========================================================================

fprintf('--------------------------------------------------\n');
fprintf('TUNING RULE #1: Ziegler-Nichols (FOPDT Method)\n');
fprintf('--------------------------------------------------\n');

% Ziegler-Nichols tuning rules for FOPDT: K*e^(-θs)/(Ts+1)
% Reference: Classic Z-N method for first-order plus delay

% For M1
tau_M1 = theta1_final / T1_final;  % Normalized delay

% Z-N PID parameters
Kp_ZN_M1 = (1.2 * T1_final) / (K1_final * theta1_final);
Ki_ZN_M1 = Kp_ZN_M1 / (2 * theta1_final);
Kd_ZN_M1 = Kp_ZN_M1 * (0.5 * theta1_final);

fprintf('\nM1 - Ziegler-Nichols PID:\n');
fprintf('  Kp = %.4f\n', Kp_ZN_M1);
fprintf('  Ki = %.4f\n', Ki_ZN_M1);
fprintf('  Kd = %.4f\n', Kd_ZN_M1);

% Create PID controller
C_ZN_M1 = pid(Kp_ZN_M1, Ki_ZN_M1, Kd_ZN_M1);

% For M2
tau_M2 = theta2_final / T2_final;

Kp_ZN_M2 = (1.2 * T2_final) / (K2_final * theta2_final);
Ki_ZN_M2 = Kp_ZN_M2 / (2 * theta2_final);
Kd_ZN_M2 = Kp_ZN_M2 * (0.5 * theta2_final);

fprintf('\nM2 - Ziegler-Nichols PID:\n');
fprintf('  Kp = %.4f\n', Kp_ZN_M2);
fprintf('  Ki = %.4f\n', Ki_ZN_M2);
fprintf('  Kd = %.4f\n', Kd_ZN_M2);

C_ZN_M2 = pid(Kp_ZN_M2, Ki_ZN_M2, Kd_ZN_M2);

%% ========================================================================

fprintf('\n--------------------------------------------------\n');
fprintf('TUNING RULE #2: AMIGO\n');
fprintf('--------------------------------------------------\n');

% AMIGO tuning rules for FOPDT
% Reference: Åström & Hägglund "Advanced PID Control"
% Designed for improved disturbance rejection

% For M1
Kp_AMIGO_M1 = (0.2 + 0.45 * (T1_final/theta1_final)) / K1_final;
Ti_AMIGO_M1 = (0.4 * theta1_final + 0.8 * T1_final) / ...
              (theta1_final + 0.1 * T1_final) * theta1_final;
Td_AMIGO_M1 = 0.5 * theta1_final * T1_final / (0.3 * theta1_final + T1_final);

Ki_AMIGO_M1 = Kp_AMIGO_M1 / Ti_AMIGO_M1;
Kd_AMIGO_M1 = Kp_AMIGO_M1 * Td_AMIGO_M1;

fprintf('\nM1 - AMIGO PID:\n');
fprintf('  Kp = %.4f\n', Kp_AMIGO_M1);
fprintf('  Ki = %.4f\n', Ki_AMIGO_M1);
fprintf('  Kd = %.4f\n', Kd_AMIGO_M1);

C_AMIGO_M1 = pid(Kp_AMIGO_M1, Ki_AMIGO_M1, Kd_AMIGO_M1);

% For M2
Kp_AMIGO_M2 = (0.2 + 0.45 * (T2_final/theta2_final)) / K2_final;
Ti_AMIGO_M2 = (0.4 * theta2_final + 0.8 * T2_final) / ...
              (theta2_final + 0.1 * T2_final) * theta2_final;
Td_AMIGO_M2 = 0.5 * theta2_final * T2_final / (0.3 * theta2_final + T2_final);

Ki_AMIGO_M2 = Kp_AMIGO_M2 / Ti_AMIGO_M2;
Kd_AMIGO_M2 = Kp_AMIGO_M2 * Td_AMIGO_M2;

fprintf('\nM2 - AMIGO PID:\n');
fprintf('  Kp = %.4f\n', Kp_AMIGO_M2);
fprintf('  Ki = %.4f\n', Ki_AMIGO_M2);
fprintf('  Kd = %.4f\n', Kd_AMIGO_M2);

C_AMIGO_M2 = pid(Kp_AMIGO_M2, Ki_AMIGO_M2, Kd_AMIGO_M2);

%% ========================================================================

fprintf('\n--------------------------------------------------\n');
fprintf('TUNING RULE #3: Skogestad/SIMC\n');
fprintf('--------------------------------------------------\n');

% Skogestad Internal Model Control (SIMC) tuning rules
% Reference: Skogestad (2003) - Simple analytic rules
% Optimized for setpoint tracking with good robustness

% Tuning parameter (closed-loop time constant)
% Typically τc = θ for good robustness
tau_c_M1 = theta1_final;  % Can be adjusted (smaller = faster, less robust)
tau_c_M2 = theta2_final;

% For M1
Kp_SIMC_M1 = T1_final / (K1_final * (tau_c_M1 + theta1_final));
Ti_SIMC_M1 = min(T1_final, 4 * (tau_c_M1 + theta1_final));
Td_SIMC_M1 = 0;  % SIMC often uses PI; PID version would be: Td = T2 (if 2nd order)

Ki_SIMC_M1 = Kp_SIMC_M1 / Ti_SIMC_M1;
Kd_SIMC_M1 = Kp_SIMC_M1 * Td_SIMC_M1;

fprintf('\nM1 - Skogestad/SIMC PID:\n');
fprintf('  Kp = %.4f\n', Kp_SIMC_M1);
fprintf('  Ki = %.4f\n', Ki_SIMC_M1);
fprintf('  Kd = %.4f\n', Kd_SIMC_M1);
fprintf('  (Note: SIMC typically yields PI controller)\n');

C_SIMC_M1 = pid(Kp_SIMC_M1, Ki_SIMC_M1, Kd_SIMC_M1);

% For M2
Kp_SIMC_M2 = T2_final / (K2_final * (tau_c_M2 + theta2_final));
Ti_SIMC_M2 = min(T2_final, 4 * (tau_c_M2 + theta2_final));
Td_SIMC_M2 = 0;

Ki_SIMC_M2 = Kp_SIMC_M2 / Ti_SIMC_M2;
Kd_SIMC_M2 = Kp_SIMC_M2 * Td_SIMC_M2;

fprintf('\nM2 - Skogestad/SIMC PID:\n');
fprintf('  Kp = %.4f\n', Kp_SIMC_M2);
fprintf('  Ki = %.4f\n', Ki_SIMC_M2);
fprintf('  Kd = %.4f\n', Kd_SIMC_M2);

C_SIMC_M2 = pid(Kp_SIMC_M2, Ki_SIMC_M2, Kd_SIMC_M2);

%% ========================================================================
%  SECTION 3: Summary Table
%  ========================================================================

fprintf('\n====================================================\n');
fprintf('SUMMARY: PID Controller Parameters\n');
fprintf('====================================================\n\n');

fprintf('M1 Controllers:\n');
fprintf('┌─────────────┬──────────┬──────────┬──────────┐\n');
fprintf('│ Method      │   Kp     │   Ki     │   Kd     │\n');
fprintf('├─────────────┼──────────┼──────────┼──────────┤\n');
fprintf('│ Z-N         │ %8.4f │ %8.4f │ %8.4f │\n', Kp_ZN_M1, Ki_ZN_M1, Kd_ZN_M1);
fprintf('│ AMIGO       │ %8.4f │ %8.4f │ %8.4f │\n', Kp_AMIGO_M1, Ki_AMIGO_M1, Kd_AMIGO_M1);
fprintf('│ SIMC        │ %8.4f │ %8.4f │ %8.4f │\n', Kp_SIMC_M1, Ki_SIMC_M1, Kd_SIMC_M1);
fprintf('└─────────────┴──────────┴──────────┴──────────┘\n\n');

fprintf('M2 Controllers:\n');
fprintf('┌─────────────┬──────────┬──────────┬──────────┐\n');
fprintf('│ Method      │   Kp     │   Ki     │   Kd     │\n');
fprintf('├─────────────┼──────────┼──────────┼──────────┤\n');
fprintf('│ Z-N         │ %8.4f │ %8.4f │ %8.4f │\n', Kp_ZN_M2, Ki_ZN_M2, Kd_ZN_M2);
fprintf('│ AMIGO       │ %8.4f │ %8.4f │ %8.4f │\n', Kp_AMIGO_M2, Ki_AMIGO_M2, Kd_AMIGO_M2);
fprintf('│ SIMC        │ %8.4f │ %8.4f │ %8.4f │\n', Kp_SIMC_M2, Ki_SIMC_M2, Kd_SIMC_M2);
fprintf('└─────────────┴──────────┴──────────┴──────────┘\n\n');

%% ========================================================================
%  SECTION 4: Create Closed-Loop Transfer Functions
%  ========================================================================

fprintf('Creating closed-loop systems for analysis...\n');

% Recreate the reduced models
G1 = K1_final * exp(-theta1_final*s) / (T1_final*s + 1);
G2 = K2_final * exp(-theta2_final*s) / (T2_final*s + 1);

% M1 closed-loop systems
T_ZN_M1 = feedback(C_ZN_M1 * G1, 1);
T_AMIGO_M1 = feedback(C_AMIGO_M1 * G1, 1);
T_SIMC_M1 = feedback(C_SIMC_M1 * G1, 1);

% M2 closed-loop systems
T_ZN_M2 = feedback(C_ZN_M2 * G2, 1);
T_AMIGO_M2 = feedback(C_AMIGO_M2 * G2, 1);
T_SIMC_M2 = feedback(C_SIMC_M2 * G2, 1);

%% ========================================================================
%  SECTION 5: Save Results for Part 3
%  ========================================================================

fprintf('\nSaving PID controllers to LAB3_Part2_controllers.mat...\n');

save('LAB3_Part2_controllers.mat', ...
    'C_ZN_M1', 'C_AMIGO_M1', 'C_SIMC_M1', ...
    'C_ZN_M2', 'C_AMIGO_M2', 'C_SIMC_M2', ...
    'Kp_ZN_M1', 'Ki_ZN_M1', 'Kd_ZN_M1', ...
    'Kp_AMIGO_M1', 'Ki_AMIGO_M1', 'Kd_AMIGO_M1', ...
    'Kp_SIMC_M1', 'Ki_SIMC_M1', 'Kd_SIMC_M1', ...
    'Kp_ZN_M2', 'Ki_ZN_M2', 'Kd_ZN_M2', ...
    'Kp_AMIGO_M2', 'Ki_AMIGO_M2', 'Kd_AMIGO_M2', ...
    'Kp_SIMC_M2', 'Ki_SIMC_M2', 'Kd_SIMC_M2', ...
    'G1', 'G2', 'M1', 'M2', ...
    'T_ZN_M1', 'T_AMIGO_M1', 'T_SIMC_M1', ...
    'T_ZN_M2', 'T_AMIGO_M2', 'T_SIMC_M2');

fprintf('\n====================================================\n');
fprintf('Part 2 Complete!\n');
fprintf('PID controllers designed and saved for Part 3\n');
fprintf('====================================================\n');
