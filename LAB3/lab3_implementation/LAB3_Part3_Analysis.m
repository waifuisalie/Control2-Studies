%% LAB3 - Part 3: Graphical Analysis and Controller Comparison
% IOSC 2025-PUCPR
% Critical Analysis of PID Tuning Rules
%
% This script performs comprehensive analysis of the PID controllers:
% 1. Time Response Analysis (settling time, overshoot, rise time)
% 2. Root Locus Analysis (pole placement)
% 3. Bode Diagram Analysis (noise sensitivity)
% 4. Nyquist Diagram Analysis (robustness - GM, PM)
%
% Author: Lab3 Implementation
% Date: 2025

clear; clc; close all;

%% ========================================================================
%  SECTION 1: Load Controllers and Models
%  ========================================================================

fprintf('====================================================\n');
fprintf('LAB3 - Part 3: Graphical Analysis\n');
fprintf('====================================================\n\n');

% Load from Part 2
if ~exist('LAB3_Part2_controllers.mat', 'file')
    error('Part 2 controllers not found! Please run LAB3_Part2_PID_Design.m first.');
end

load('LAB3_Part2_controllers.mat');

%% ========================================================================
%  SECTION 2: TIME RESPONSE ANALYSIS
%  ========================================================================

fprintf('--------------------------------------------------\n');
fprintf('SECTION 1: Time Response Analysis\n');
fprintf('--------------------------------------------------\n');

t_sim = 0:0.01:30;  % Simulation time

% === M1 Time Response ===
fprintf('\nAnalyzing M1 Controllers...\n');

[y_ZN_M1, t_ZN_M1] = step(T_ZN_M1, t_sim);
[y_AMIGO_M1, t_AMIGO_M1] = step(T_AMIGO_M1, t_sim);
[y_SIMC_M1, t_SIMC_M1] = step(T_SIMC_M1, t_sim);

% Calculate step response characteristics
info_ZN_M1 = stepinfo(T_ZN_M1);
info_AMIGO_M1 = stepinfo(T_AMIGO_M1);
info_SIMC_M1 = stepinfo(T_SIMC_M1);

fprintf('\nM1 - Step Response Characteristics:\n');
fprintf('┌─────────────┬────────────┬─────────────┬────────────┬──────────┐\n');
fprintf('│ Method      │ Rise Time  │ Settle Time │  Overshoot │ Peak Time│\n');
fprintf('├─────────────┼────────────┼─────────────┼────────────┼──────────┤\n');
fprintf('│ Z-N         │ %8.3f s │  %8.3f s │  %7.2f%% │ %6.3f s │\n', ...
    info_ZN_M1.RiseTime, info_ZN_M1.SettlingTime, info_ZN_M1.Overshoot, info_ZN_M1.PeakTime);
fprintf('│ AMIGO       │ %8.3f s │  %8.3f s │  %7.2f%% │ %6.3f s │\n', ...
    info_AMIGO_M1.RiseTime, info_AMIGO_M1.SettlingTime, info_AMIGO_M1.Overshoot, info_AMIGO_M1.PeakTime);
fprintf('│ SIMC        │ %8.3f s │  %8.3f s │  %7.2f%% │ %6.3f s │\n', ...
    info_SIMC_M1.RiseTime, info_SIMC_M1.SettlingTime, info_SIMC_M1.Overshoot, info_SIMC_M1.PeakTime);
fprintf('└─────────────┴────────────┴─────────────┴────────────┴──────────┘\n');

% === M2 Time Response ===
fprintf('\nAnalyzing M2 Controllers...\n');

[y_ZN_M2, t_ZN_M2] = step(T_ZN_M2, t_sim);
[y_AMIGO_M2, t_AMIGO_M2] = step(T_AMIGO_M2, t_sim);
[y_SIMC_M2, t_SIMC_M2] = step(T_SIMC_M2, t_sim);

info_ZN_M2 = stepinfo(T_ZN_M2);
info_AMIGO_M2 = stepinfo(T_AMIGO_M2);
info_SIMC_M2 = stepinfo(T_SIMC_M2);

fprintf('\nM2 - Step Response Characteristics:\n');
fprintf('┌─────────────┬────────────┬─────────────┬────────────┬──────────┐\n');
fprintf('│ Method      │ Rise Time  │ Settle Time │  Overshoot │ Peak Time│\n');
fprintf('├─────────────┼────────────┼─────────────┼────────────┼──────────┤\n');
fprintf('│ Z-N         │ %8.3f s │  %8.3f s │  %7.2f%% │ %6.3f s │\n', ...
    info_ZN_M2.RiseTime, info_ZN_M2.SettlingTime, info_ZN_M2.Overshoot, info_ZN_M2.PeakTime);
fprintf('│ AMIGO       │ %8.3f s │  %8.3f s │  %7.2f%% │ %6.3f s │\n', ...
    info_AMIGO_M2.RiseTime, info_AMIGO_M2.SettlingTime, info_AMIGO_M2.Overshoot, info_AMIGO_M2.PeakTime);
fprintf('│ SIMC        │ %8.3f s │  %8.3f s │  %7.2f%% │ %6.3f s │\n', ...
    info_SIMC_M2.RiseTime, info_SIMC_M2.SettlingTime, info_SIMC_M2.Overshoot, info_SIMC_M2.PeakTime);
fprintf('└─────────────┴────────────┴─────────────┴────────────┴──────────┘\n');

% Plot time responses
figure('Position', [100, 100, 1400, 500]);

subplot(1,2,1);
plot(t_ZN_M1, y_ZN_M1, 'r-', 'LineWidth', 2); hold on;
plot(t_AMIGO_M1, y_AMIGO_M1, 'b-', 'LineWidth', 2);
plot(t_SIMC_M1, y_SIMC_M1, 'g-', 'LineWidth', 2);
yline(1, 'k--', 'Setpoint');
yline(1.05, 'k:', '5% band');
yline(0.95, 'k:', '5% band');
grid on;
xlabel('Time (s)');
ylabel('Output');
title('M1: Closed-Loop Step Response');
legend('Ziegler-Nichols', 'AMIGO', 'SIMC', 'Location', 'best');

subplot(1,2,2);
plot(t_ZN_M2, y_ZN_M2, 'r-', 'LineWidth', 2); hold on;
plot(t_AMIGO_M2, y_AMIGO_M2, 'b-', 'LineWidth', 2);
plot(t_SIMC_M2, y_SIMC_M2, 'g-', 'LineWidth', 2);
yline(1, 'k--', 'Setpoint');
yline(1.05, 'k:', '5% band');
yline(0.95, 'k:', '5% band');
grid on;
xlabel('Time (s)');
ylabel('Output');
title('M2: Closed-Loop Step Response');
legend('Ziegler-Nichols', 'AMIGO', 'SIMC', 'Location', 'best');

saveas(gcf, 'time_response_comparison.png');

%% ========================================================================
%  SECTION 3: ROOT LOCUS ANALYSIS
%  ========================================================================

fprintf('\n--------------------------------------------------\n');
fprintf('SECTION 2: Root Locus Analysis\n');
fprintf('--------------------------------------------------\n');

% Approximate delays using Padé for root locus plotting
% (rlocus cannot handle pure time delays)
fprintf('\nApproximating time delays using 2nd-order Padé approximation...\n');
G1_pade = pade(G1, 2);  % 2nd order Padé for G1
G2_pade = pade(G2, 2);  % 2nd order Padé for G2

% M1 Root Loci
figure('Position', [100, 100, 1400, 500]);

subplot(1,2,1);
rlocus(C_ZN_M1 * G1_pade, 'r'); hold on;
rlocus(C_AMIGO_M1 * G1_pade, 'b');
rlocus(C_SIMC_M1 * G1_pade, 'g');
grid on;
title('M1: Root Locus (Padé approx.)');
legend('Z-N', 'AMIGO', 'SIMC', 'Location', 'best');

subplot(1,2,2);
rlocus(C_ZN_M2 * G2_pade, 'r'); hold on;
rlocus(C_AMIGO_M2 * G2_pade, 'b');
rlocus(C_SIMC_M2 * G2_pade, 'g');
grid on;
title('M2: Root Locus (Padé approx.)');
legend('Z-N', 'AMIGO', 'SIMC', 'Location', 'best');

saveas(gcf, 'root_locus_comparison.png');

% Calculate closed-loop poles
fprintf('\nM1 Closed-Loop Poles:\n');
poles_ZN_M1 = pole(T_ZN_M1);
poles_AMIGO_M1 = pole(T_AMIGO_M1);
poles_SIMC_M1 = pole(T_SIMC_M1);

fprintf('  Z-N:    '); disp(poles_ZN_M1.');
fprintf('  AMIGO:  '); disp(poles_AMIGO_M1.');
fprintf('  SIMC:   '); disp(poles_SIMC_M1.');

fprintf('\nM2 Closed-Loop Poles:\n');
poles_ZN_M2 = pole(T_ZN_M2);
poles_AMIGO_M2 = pole(T_AMIGO_M2);
poles_SIMC_M2 = pole(T_SIMC_M2);

fprintf('  Z-N:    '); disp(poles_ZN_M2.');
fprintf('  AMIGO:  '); disp(poles_AMIGO_M2.');
fprintf('  SIMC:   '); disp(poles_SIMC_M2.');

fprintf('\nNote: Root locus plots use Padé approximation for delays.\n');
fprintf('      Closed-loop poles shown above include exact delays.\n');

%% ========================================================================
%  SECTION 4: BODE DIAGRAM ANALYSIS (Noise Sensitivity)
%  ========================================================================

fprintf('\n--------------------------------------------------\n');
fprintf('SECTION 3: Bode Diagram Analysis\n');
fprintf('--------------------------------------------------\n');

% M1 Bode Plots
figure('Position', [100, 100, 1400, 800]);

subplot(2,2,1);
bode(C_ZN_M1, 'r', C_AMIGO_M1, 'b', C_SIMC_M1, 'g');
grid on;
title('M1: Controller Bode Diagram (Noise Sensitivity)');
legend('Z-N', 'AMIGO', 'SIMC', 'Location', 'best');

subplot(2,2,2);
bode(C_ZN_M2, 'r', C_AMIGO_M2, 'b', C_SIMC_M2, 'g');
grid on;
title('M2: Controller Bode Diagram (Noise Sensitivity)');
legend('Z-N', 'AMIGO', 'SIMC', 'Location', 'best');

% Open-loop Bode with margins
subplot(2,2,3);
margin(C_ZN_M1 * G1); hold on;
title('M1: Open-Loop Bode with Margins');
grid on;

subplot(2,2,4);
margin(C_ZN_M2 * G2); hold on;
title('M2: Open-Loop Bode with Margins');
grid on;

saveas(gcf, 'bode_analysis.png');

% Calculate high-frequency gain (noise sensitivity indicator)
fprintf('\nHigh-Frequency Gain (at 100 rad/s) - Noise Sensitivity:\n');

w_high = 100;  % High frequency

[mag_ZN_M1, ~] = bode(C_ZN_M1, w_high);
[mag_AMIGO_M1, ~] = bode(C_AMIGO_M1, w_high);
[mag_SIMC_M1, ~] = bode(C_SIMC_M1, w_high);

fprintf('M1:\n');
fprintf('  Z-N:    %.4f (%.2f dB)\n', mag_ZN_M1, 20*log10(mag_ZN_M1));
fprintf('  AMIGO:  %.4f (%.2f dB)\n', mag_AMIGO_M1, 20*log10(mag_AMIGO_M1));
fprintf('  SIMC:   %.4f (%.2f dB)\n', mag_SIMC_M1, 20*log10(mag_SIMC_M1));

[mag_ZN_M2, ~] = bode(C_ZN_M2, w_high);
[mag_AMIGO_M2, ~] = bode(C_AMIGO_M2, w_high);
[mag_SIMC_M2, ~] = bode(C_SIMC_M2, w_high);

fprintf('\nM2:\n');
fprintf('  Z-N:    %.4f (%.2f dB)\n', mag_ZN_M2, 20*log10(mag_ZN_M2));
fprintf('  AMIGO:  %.4f (%.2f dB)\n', mag_AMIGO_M2, 20*log10(mag_AMIGO_M2));
fprintf('  SIMC:   %.4f (%.2f dB)\n', mag_SIMC_M2, 20*log10(mag_SIMC_M2));

fprintf('\nNote: Lower high-frequency gain = better noise rejection\n');

%% ========================================================================
%  SECTION 5: NYQUIST DIAGRAM ANALYSIS (Robustness)
%  ========================================================================

fprintf('\n--------------------------------------------------\n');
fprintf('SECTION 4: Nyquist Diagram Analysis\n');
fprintf('--------------------------------------------------\n');

% M1 Nyquist Plots
figure('Position', [100, 100, 1400, 500]);

subplot(1,2,1);
nyquist(C_ZN_M1 * G1, 'r'); hold on;
nyquist(C_AMIGO_M1 * G1, 'b');
nyquist(C_SIMC_M1 * G1, 'g');
grid on;
title('M1: Nyquist Diagram');
legend('Z-N', 'AMIGO', 'SIMC', 'Location', 'best');

subplot(1,2,2);
nyquist(C_ZN_M2 * G2, 'r'); hold on;
nyquist(C_AMIGO_M2 * G2, 'b');
nyquist(C_SIMC_M2 * G2, 'g');
grid on;
title('M2: Nyquist Diagram');
legend('Z-N', 'AMIGO', 'SIMC', 'Location', 'best');

saveas(gcf, 'nyquist_analysis.png');

% Calculate Gain and Phase Margins
fprintf('\nGain Margin (GM) and Phase Margin (PM) - Robustness Indicators:\n');

fprintf('\nM1:\n');
fprintf('┌─────────────┬──────────────┬──────────────┐\n');
fprintf('│ Method      │   GM (dB)    │   PM (deg)   │\n');
fprintf('├─────────────┼──────────────┼──────────────┤\n');

[Gm_ZN_M1, Pm_ZN_M1] = margin(C_ZN_M1 * G1);
fprintf('│ Z-N         │   %8.2f   │   %8.2f   │\n', ...
    20*log10(Gm_ZN_M1), Pm_ZN_M1);

[Gm_AMIGO_M1, Pm_AMIGO_M1] = margin(C_AMIGO_M1 * G1);
fprintf('│ AMIGO       │   %8.2f   │   %8.2f   │\n', ...
    20*log10(Gm_AMIGO_M1), Pm_AMIGO_M1);

[Gm_SIMC_M1, Pm_SIMC_M1] = margin(C_SIMC_M1 * G1);
fprintf('│ SIMC        │   %8.2f   │   %8.2f   │\n', ...
    20*log10(Gm_SIMC_M1), Pm_SIMC_M1);

fprintf('└─────────────┴──────────────┴──────────────┘\n');

fprintf('\nM2:\n');
fprintf('┌─────────────┬──────────────┬──────────────┐\n');
fprintf('│ Method      │   GM (dB)    │   PM (deg)   │\n');
fprintf('├─────────────┼──────────────┼──────────────┤\n');

[Gm_ZN_M2, Pm_ZN_M2] = margin(C_ZN_M2 * G2);
fprintf('│ Z-N         │   %8.2f   │   %8.2f   │\n', ...
    20*log10(Gm_ZN_M2), Pm_ZN_M2);

[Gm_AMIGO_M2, Pm_AMIGO_M2] = margin(C_AMIGO_M2 * G2);
fprintf('│ AMIGO       │   %8.2f   │   %8.2f   │\n', ...
    20*log10(Gm_AMIGO_M2), Pm_AMIGO_M2);

[Gm_SIMC_M2, Pm_SIMC_M2] = margin(C_SIMC_M2 * G2);
fprintf('│ SIMC        │   %8.2f   │   %8.2f   │\n', ...
    20*log10(Gm_SIMC_M2), Pm_SIMC_M2);

fprintf('└─────────────┴──────────────┴──────────────┘\n');

fprintf('\nNote: Higher GM and PM = more robust controller\n');
fprintf('      Typical good values: GM > 6dB, PM > 30°\n');

%% ========================================================================
%  SECTION 6: Test on Original Plants
%  ========================================================================

fprintf('\n--------------------------------------------------\n');
fprintf('SECTION 5: Testing on Original Plants\n');
fprintf('--------------------------------------------------\n');

% Test selected controllers on original M1 and M2

fprintf('\nTesting controllers on ORIGINAL plants (not reduced models)...\n');

% M1 original plant
T_ZN_M1_orig = feedback(C_ZN_M1 * M1, 1);
T_AMIGO_M1_orig = feedback(C_AMIGO_M1 * M1, 1);
T_SIMC_M1_orig = feedback(C_SIMC_M1 * M1, 1);

% M2 original plant
T_ZN_M2_orig = feedback(C_ZN_M2 * M2, 1);
T_AMIGO_M2_orig = feedback(C_AMIGO_M2 * M2, 1);
T_SIMC_M2_orig = feedback(C_SIMC_M2 * M2, 1);

% Plot comparison
figure('Position', [100, 100, 1400, 500]);

subplot(1,2,1);
step(T_ZN_M1_orig, 'r-', T_AMIGO_M1_orig, 'b-', T_SIMC_M1_orig, 'g-', t_sim);
grid on;
title('M1: Controllers on ORIGINAL Plant');
legend('Z-N', 'AMIGO', 'SIMC', 'Location', 'best');

subplot(1,2,2);
step(T_ZN_M2_orig, 'r-', T_AMIGO_M2_orig, 'b-', T_SIMC_M2_orig, 'g-', t_sim);
grid on;
title('M2: Controllers on ORIGINAL Plant');
legend('Z-N', 'AMIGO', 'SIMC', 'Location', 'best');

saveas(gcf, 'original_plant_response.png');

%% ========================================================================
%  SECTION 7: Final Summary and Recommendations
%  ========================================================================

fprintf('\n====================================================\n');
fprintf('FINAL SUMMARY AND RECOMMENDATIONS\n');
fprintf('====================================================\n\n');

fprintf('Based on the comprehensive analysis:\n\n');

fprintf('M1 Recommended Controller: ');
% Simple heuristic: balance between performance and robustness
if Pm_SIMC_M1 > 40 && info_SIMC_M1.Overshoot < 20
    fprintf('SIMC (Best robustness, moderate performance)\n');
elseif info_AMIGO_M1.Overshoot < info_ZN_M1.Overshoot && Pm_AMIGO_M1 > 30
    fprintf('AMIGO (Good balance)\n');
else
    fprintf('Ziegler-Nichols (Fast response, may have more overshoot)\n');
end

fprintf('\nM2 Recommended Controller: ');
if Pm_SIMC_M2 > 40 && info_SIMC_M2.Overshoot < 20
    fprintf('SIMC (Best robustness, moderate performance)\n');
elseif info_AMIGO_M2.Overshoot < info_ZN_M2.Overshoot && Pm_AMIGO_M2 > 30
    fprintf('AMIGO (Good balance)\n');
else
    fprintf('Ziegler-Nichols (Fast response, may have more overshoot)\n');
end

fprintf('\n====================================================\n');
fprintf('Analysis Complete!\n');
fprintf('Generated files:\n');
fprintf('  - time_response_comparison.png\n');
fprintf('  - root_locus_comparison.png\n');
fprintf('  - bode_analysis.png\n');
fprintf('  - nyquist_analysis.png\n');
fprintf('  - original_plant_response.png\n');
fprintf('====================================================\n');
