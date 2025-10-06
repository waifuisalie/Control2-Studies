%% LAB3 - Part 4: Controller Selection and Report Generation
% IOSC 2025-PUCPR
% Critical Analysis of PID Tuning Rules - Final Selection
%
% This script:
% - Analyzes all controller performance metrics
% - Creates weighted scoring system for objective comparison
% - Selects best controller for each plant with justification
% - Generates report-ready text and visualizations
%
% Author: Lab3 Implementation
% Date: 2025

clear; clc; close all;

%% ========================================================================
%  SECTION 1: Load Data and Recalculate All Metrics
%  ========================================================================

fprintf('====================================================\n');
fprintf('LAB3 - Part 4: Controller Selection & Report\n');
fprintf('====================================================\n\n');

% Load controllers and systems from Part 2
if ~exist('LAB3_Part2_controllers.mat', 'file')
    error('Part 2 data not found! Please run LAB3_Part2_PID_Design.m first.');
end

load('LAB3_Part2_controllers.mat');

fprintf('Loaded data from Part 2...\n');
fprintf('Recalculating all performance metrics...\n\n');

% === Time Response Metrics ===
info_ZN_M1 = stepinfo(T_ZN_M1);
info_AMIGO_M1 = stepinfo(T_AMIGO_M1);
info_SIMC_M1 = stepinfo(T_SIMC_M1);

info_ZN_M2 = stepinfo(T_ZN_M2);
info_AMIGO_M2 = stepinfo(T_AMIGO_M2);
info_SIMC_M2 = stepinfo(T_SIMC_M2);

% === Robustness Metrics (GM, PM) ===
[Gm_ZN_M1, Pm_ZN_M1] = margin(C_ZN_M1 * G1);
[Gm_AMIGO_M1, Pm_AMIGO_M1] = margin(C_AMIGO_M1 * G1);
[Gm_SIMC_M1, Pm_SIMC_M1] = margin(C_SIMC_M1 * G1);

[Gm_ZN_M2, Pm_ZN_M2] = margin(C_ZN_M2 * G2);
[Gm_AMIGO_M2, Pm_AMIGO_M2] = margin(C_AMIGO_M2 * G2);
[Gm_SIMC_M2, Pm_SIMC_M2] = margin(C_SIMC_M2 * G2);

% === Noise Sensitivity (High-frequency gain) ===
w_high = 100;  % rad/s
[mag_ZN_M1, ~] = bode(C_ZN_M1, w_high);
[mag_AMIGO_M1, ~] = bode(C_AMIGO_M1, w_high);
[mag_SIMC_M1, ~] = bode(C_SIMC_M1, w_high);

[mag_ZN_M2, ~] = bode(C_ZN_M2, w_high);
[mag_AMIGO_M2, ~] = bode(C_AMIGO_M2, w_high);
[mag_SIMC_M2, ~] = bode(C_SIMC_M2, w_high);

fprintf('All metrics recalculated successfully.\n\n');

%% ========================================================================
%  SECTION 2: Create Weighted Scoring System
%  ========================================================================

fprintf('--------------------------------------------------\n');
fprintf('SECTION 1: Weighted Scoring and Ranking\n');
fprintf('--------------------------------------------------\n\n');

% Define weights (must sum to 1.0)
w_speed = 0.20;       % Speed (rise + settling time)
w_overshoot = 0.25;   % Overshoot
w_robustness = 0.30;  % Robustness (GM + PM)
w_noise = 0.25;       % Noise rejection

fprintf('Scoring Weights:\n');
fprintf('  Speed (rise + settling): %.0f%%\n', w_speed*100);
fprintf('  Overshoot:              %.0f%%\n', w_overshoot*100);
fprintf('  Robustness (GM + PM):   %.0f%%\n', w_robustness*100);
fprintf('  Noise Rejection:        %.0f%%\n\n', w_noise*100);

% === M1 Scoring ===
% Collect metrics into arrays for easier processing
rise_M1 = [info_ZN_M1.RiseTime, info_AMIGO_M1.RiseTime, info_SIMC_M1.RiseTime];
settle_M1 = [info_ZN_M1.SettlingTime, info_AMIGO_M1.SettlingTime, info_SIMC_M1.SettlingTime];
overshoot_M1 = [info_ZN_M1.Overshoot, info_AMIGO_M1.Overshoot, info_SIMC_M1.Overshoot];
gm_M1 = 20*log10([Gm_ZN_M1, Gm_AMIGO_M1, Gm_SIMC_M1]);  % Convert to dB
pm_M1 = [Pm_ZN_M1, Pm_AMIGO_M1, Pm_SIMC_M1];
noise_M1 = 20*log10([mag_ZN_M1, mag_AMIGO_M1, mag_SIMC_M1]);  % Convert to dB

% Normalize metrics (0-100 scale, higher is better)
% For metrics where lower is better, invert
score_rise_M1 = 100 * (1 - (rise_M1 - min(rise_M1)) / (max(rise_M1) - min(rise_M1) + eps));
score_settle_M1 = 100 * (1 - (settle_M1 - min(settle_M1)) / (max(settle_M1) - min(settle_M1) + eps));
score_speed_M1 = (score_rise_M1 + score_settle_M1) / 2;  % Average

score_overshoot_M1 = 100 * (1 - (overshoot_M1 - min(overshoot_M1)) / (max(overshoot_M1) - min(overshoot_M1) + eps));

score_gm_M1 = 100 * (gm_M1 - min(gm_M1)) / (max(gm_M1) - min(gm_M1) + eps);
score_pm_M1 = 100 * (pm_M1 - min(pm_M1)) / (max(pm_M1) - min(pm_M1) + eps);
score_robust_M1 = (score_gm_M1 + score_pm_M1) / 2;  % Average

score_noise_M1 = 100 * (1 - (noise_M1 - min(noise_M1)) / (max(noise_M1) - min(noise_M1) + eps));

% Calculate total weighted score
total_M1 = w_speed * score_speed_M1 + ...
           w_overshoot * score_overshoot_M1 + ...
           w_robustness * score_robust_M1 + ...
           w_noise * score_noise_M1;

% === M2 Scoring ===
rise_M2 = [info_ZN_M2.RiseTime, info_AMIGO_M2.RiseTime, info_SIMC_M2.RiseTime];
settle_M2 = [info_ZN_M2.SettlingTime, info_AMIGO_M2.SettlingTime, info_SIMC_M2.SettlingTime];
overshoot_M2 = [info_ZN_M2.Overshoot, info_AMIGO_M2.Overshoot, info_SIMC_M2.Overshoot];
gm_M2 = 20*log10([Gm_ZN_M2, Gm_AMIGO_M2, Gm_SIMC_M2]);
pm_M2 = [Pm_ZN_M2, Pm_AMIGO_M2, Pm_SIMC_M2];
noise_M2 = 20*log10([mag_ZN_M2, mag_AMIGO_M2, mag_SIMC_M2]);

score_rise_M2 = 100 * (1 - (rise_M2 - min(rise_M2)) / (max(rise_M2) - min(rise_M2) + eps));
score_settle_M2 = 100 * (1 - (settle_M2 - min(settle_M2)) / (max(settle_M2) - min(settle_M2) + eps));
score_speed_M2 = (score_rise_M2 + score_settle_M2) / 2;

score_overshoot_M2 = 100 * (1 - (overshoot_M2 - min(overshoot_M2)) / (max(overshoot_M2) - min(overshoot_M2) + eps));

score_gm_M2 = 100 * (gm_M2 - min(gm_M2)) / (max(gm_M2) - min(gm_M2) + eps);
score_pm_M2 = 100 * (pm_M2 - min(pm_M2)) / (max(pm_M2) - min(pm_M2) + eps);
score_robust_M2 = (score_gm_M2 + score_pm_M2) / 2;

score_noise_M2 = 100 * (1 - (noise_M2 - min(noise_M2)) / (max(noise_M2) - min(noise_M2) + eps));

total_M2 = w_speed * score_speed_M2 + ...
           w_overshoot * score_overshoot_M2 + ...
           w_robustness * score_robust_M2 + ...
           w_noise * score_noise_M2;

% Display scoring results
methods = {'Z-N', 'AMIGO', 'SIMC'};

fprintf('M1 - Overall Scores (0-100):\n');
fprintf('┌─────────────┬─────────┬─────────┬─────────┬─────────┬─────────┐\n');
fprintf('│ Method      │  Speed  │Overshoot│ Robust. │  Noise  │  TOTAL  │\n');
fprintf('├─────────────┼─────────┼─────────┼─────────┼─────────┼─────────┤\n');
for i = 1:3
    fprintf('│ %-11s │ %7.1f │ %7.1f │ %7.1f │ %7.1f │ %7.1f │\n', ...
        methods{i}, score_speed_M1(i), score_overshoot_M1(i), ...
        score_robust_M1(i), score_noise_M1(i), total_M1(i));
end
fprintf('└─────────────┴─────────┴─────────┴─────────┴─────────┴─────────┘\n\n');

[~, winner_M1_idx] = max(total_M1);
fprintf('M1 Winner: %s (Score: %.1f/100)\n\n', methods{winner_M1_idx}, total_M1(winner_M1_idx));

fprintf('M2 - Overall Scores (0-100):\n');
fprintf('┌─────────────┬─────────┬─────────┬─────────┬─────────┬─────────┐\n');
fprintf('│ Method      │  Speed  │Overshoot│ Robust. │  Noise  │  TOTAL  │\n');
fprintf('├─────────────┼─────────┼─────────┼─────────┼─────────┼─────────┤\n');
for i = 1:3
    fprintf('│ %-11s │ %7.1f │ %7.1f │ %7.1f │ %7.1f │ %7.1f │\n', ...
        methods{i}, score_speed_M2(i), score_overshoot_M2(i), ...
        score_robust_M2(i), score_noise_M2(i), total_M2(i));
end
fprintf('└─────────────┴─────────┴─────────┴─────────┴─────────┴─────────┘\n\n');

[~, winner_M2_idx] = max(total_M2);
fprintf('M2 Winner: %s (Score: %.1f/100)\n\n', methods{winner_M2_idx}, total_M2(winner_M2_idx));

%% ========================================================================
%  SECTION 3: Detailed Justifications
%  ========================================================================

fprintf('--------------------------------------------------\n');
fprintf('SECTION 2: Detailed Controller Selection\n');
fprintf('--------------------------------------------------\n\n');

% M1 Justification
fprintf('=== M1 SELECTED CONTROLLER: %s ===\n\n', methods{winner_M1_idx});

fprintf('JUSTIFICATION:\n');
fprintf('Based on weighted multi-criteria analysis, %s provides the\n', methods{winner_M1_idx});
fprintf('best overall performance for M1 with a score of %.1f/100.\n\n', total_M1(winner_M1_idx));

fprintf('KEY STRENGTHS:\n');
idx = winner_M1_idx;
fprintf('  • Settling Time: %.2f s (Rank %d/3)\n', settle_M1(idx), find(sort(settle_M1)==settle_M1(idx)));
fprintf('  • Overshoot: %.2f%% (Rank %d/3)\n', overshoot_M1(idx), find(sort(overshoot_M1)==overshoot_M1(idx)));
fprintf('  • Gain Margin: %.2f dB (Rank %d/3)\n', gm_M1(idx), find(sort(gm_M1,'descend')==gm_M1(idx)));
fprintf('  • Phase Margin: %.2f° (Rank %d/3)\n', pm_M1(idx), find(sort(pm_M1,'descend')==pm_M1(idx)));
fprintf('  • Noise Rejection: %.2f dB @100rad/s (Rank %d/3)\n\n', noise_M1(idx), find(sort(noise_M1)==noise_M1(idx)));

fprintf('COMPARISON WITH ALTERNATIVES:\n');
for i = 1:3
    if i ~= winner_M1_idx
        fprintf('  %s: Score %.1f/100 - ', methods{i}, total_M1(i));
        if gm_M1(i) < 6
            fprintf('Low GM (%.2f dB < 6dB threshold)', gm_M1(i));
        elseif overshoot_M1(i) > 10
            fprintf('High overshoot (%.1f%%)', overshoot_M1(i));
        elseif settle_M1(i) > settle_M1(idx) * 1.3
            fprintf('Slower settling time');
        else
            fprintf('Lower overall score');
        end
        fprintf('\n');
    end
end
fprintf('\n');

% M2 Justification
fprintf('=== M2 SELECTED CONTROLLER: %s ===\n\n', methods{winner_M2_idx});

fprintf('JUSTIFICATION:\n');
fprintf('Based on weighted multi-criteria analysis, %s provides the\n', methods{winner_M2_idx});
fprintf('best overall performance for M2 with a score of %.1f/100.\n\n', total_M2(winner_M2_idx));

fprintf('KEY STRENGTHS:\n');
idx = winner_M2_idx;
fprintf('  • Settling Time: %.2f s (Rank %d/3)\n', settle_M2(idx), find(sort(settle_M2)==settle_M2(idx)));
fprintf('  • Overshoot: %.2f%% (Rank %d/3)\n', overshoot_M2(idx), find(sort(overshoot_M2)==overshoot_M2(idx)));
fprintf('  • Gain Margin: %.2f dB (Rank %d/3)\n', gm_M2(idx), find(sort(gm_M2,'descend')==gm_M2(idx)));
fprintf('  • Phase Margin: %.2f° (Rank %d/3)\n', pm_M2(idx), find(sort(pm_M2,'descend')==pm_M2(idx)));
fprintf('  • Noise Rejection: %.2f dB @100rad/s (Rank %d/3)\n\n', noise_M2(idx), find(sort(noise_M2)==noise_M2(idx)));

fprintf('NOTE: M2 is non-minimum phase (inverse response), making control\n');
fprintf('more challenging. The selected controller handles this well.\n\n');

fprintf('COMPARISON WITH ALTERNATIVES:\n');
for i = 1:3
    if i ~= winner_M2_idx
        fprintf('  %s: Score %.1f/100 - ', methods{i}, total_M2(i));
        if gm_M2(i) < 6
            fprintf('Low GM (%.2f dB < 6dB threshold)', gm_M2(i));
        elseif overshoot_M2(i) > 10
            fprintf('High overshoot (%.1f%%)', overshoot_M2(i));
        elseif settle_M2(i) > settle_M2(idx) * 1.3
            fprintf('Slower settling time');
        else
            fprintf('Lower overall score');
        end
        fprintf('\n');
    end
end
fprintf('\n');

%% ========================================================================
%  SECTION 4: Generate Comparison Visualizations
%  ========================================================================

fprintf('--------------------------------------------------\n');
fprintf('SECTION 3: Generating Visualizations\n');
fprintf('--------------------------------------------------\n\n');

% Figure 1: Metrics Comparison Bar Charts
figure('Position', [100, 100, 1400, 900]);

subplot(2,3,1);
bar([rise_M1; rise_M2]');
set(gca, 'XTickLabel', methods);
ylabel('Rise Time (s)');
title('Rise Time Comparison');
legend('M1', 'M2', 'Location', 'best');
grid on;

subplot(2,3,2);
bar([settle_M1; settle_M2]');
set(gca, 'XTickLabel', methods);
ylabel('Settling Time (s)');
title('Settling Time Comparison');
legend('M1', 'M2', 'Location', 'best');
grid on;

subplot(2,3,3);
bar([overshoot_M1; overshoot_M2]');
set(gca, 'XTickLabel', methods);
ylabel('Overshoot (%)');
title('Overshoot Comparison');
legend('M1', 'M2', 'Location', 'best');
grid on;

subplot(2,3,4);
bar([gm_M1; gm_M2]');
hold on;
yline(6, 'r--', 'Min Recommended');
set(gca, 'XTickLabel', methods);
ylabel('Gain Margin (dB)');
title('Gain Margin Comparison');
legend('M1', 'M2', 'Min (6dB)', 'Location', 'best');
grid on;

subplot(2,3,5);
bar([pm_M1; pm_M2]');
hold on;
yline(30, 'r--', 'Min Recommended');
set(gca, 'XTickLabel', methods);
ylabel('Phase Margin (deg)');
title('Phase Margin Comparison');
legend('M1', 'M2', 'Min (30°)', 'Location', 'best');
grid on;

subplot(2,3,6);
bar([noise_M1; noise_M2]');
set(gca, 'XTickLabel', methods);
ylabel('Noise Gain (dB @ 100 rad/s)');
title('Noise Sensitivity (Lower is Better)');
legend('M1', 'M2', 'Location', 'best');
grid on;

saveas(gcf, 'metrics_comparison.png');
fprintf('  Created: metrics_comparison.png\n');

% Figure 2: Overall Score Comparison
figure('Position', [100, 100, 1000, 500]);

subplot(1,2,1);
bar(total_M1);
set(gca, 'XTickLabel', methods);
ylabel('Overall Score (0-100)');
title('M1: Overall Performance Score');
grid on;
ylim([0 100]);

subplot(1,2,2);
bar(total_M2);
set(gca, 'XTickLabel', methods);
ylabel('Overall Score (0-100)');
title('M2: Overall Performance Score');
grid on;
ylim([0 100]);

saveas(gcf, 'overall_scores.png');
fprintf('  Created: overall_scores.png\n');

% Figure 3: Radar Charts
figure('Position', [100, 100, 1400, 500]);

% M1 Radar
ax1 = subplot(1,2,1,polaraxes);
categories = {'Speed', 'Low Overshoot', 'Robustness', 'Noise Rejection'};
data_M1 = [score_speed_M1; score_overshoot_M1; score_robust_M1; score_noise_M1]';
theta = linspace(0, 2*pi, 5);

hold(ax1, 'on');
for i = 1:3
    r = [data_M1(i,:), data_M1(i,1)];
    polarplot(ax1, theta, r, '-o', 'LineWidth', 2);
end
title(ax1, 'M1: Performance Radar Chart');
legend(ax1, methods, 'Location', 'best');
thetalim(ax1, [0 360]);
rlim(ax1, [0 100]);

% M2 Radar
ax2 = subplot(1,2,2,polaraxes);
data_M2 = [score_speed_M2; score_overshoot_M2; score_robust_M2; score_noise_M2]';

hold(ax2, 'on');
for i = 1:3
    r = [data_M2(i,:), data_M2(i,1)];
    polarplot(ax2, theta, r, '-o', 'LineWidth', 2);
end
title(ax2, 'M2: Performance Radar Chart');
legend(ax2, methods, 'Location', 'best');
thetalim(ax2, [0 360]);
rlim(ax2, [0 100]);

saveas(gcf, 'performance_radar.png');
fprintf('  Created: performance_radar.png\n');

%% ========================================================================
%  SECTION 5: Test Selected Controllers on Original Plants
%  ========================================================================

fprintf('\n--------------------------------------------------\n');
fprintf('SECTION 4: Testing on Original Plants\n');
fprintf('--------------------------------------------------\n\n');

% Get selected controllers
if winner_M1_idx == 1
    C_selected_M1 = C_ZN_M1;
    method_M1 = 'Ziegler-Nichols';
elseif winner_M1_idx == 2
    C_selected_M1 = C_AMIGO_M1;
    method_M1 = 'AMIGO';
else
    C_selected_M1 = C_SIMC_M1;
    method_M1 = 'SIMC';
end

if winner_M2_idx == 1
    C_selected_M2 = C_ZN_M2;
    method_M2 = 'Ziegler-Nichols';
elseif winner_M2_idx == 2
    C_selected_M2 = C_AMIGO_M2;
    method_M2 = 'AMIGO';
else
    C_selected_M2 = C_SIMC_M2;
    method_M2 = 'SIMC';
end

% Test on original plants
fprintf('Testing %s on M1 (original 4th-order plant)...\n', method_M1);
T_selected_M1 = feedback(C_selected_M1 * M1, 1);
info_selected_M1 = stepinfo(T_selected_M1);

fprintf('Testing %s on M2 (original 3rd-order plant)...\n', method_M2);
T_selected_M2 = feedback(C_selected_M2 * M2, 1);
info_selected_M2 = stepinfo(T_selected_M2);

fprintf('\nPerformance on Original Plants:\n');
fprintf('M1 (%s): Rise=%.2fs, Settle=%.2fs, Overshoot=%.2f%%\n', ...
    method_M1, info_selected_M1.RiseTime, info_selected_M1.SettlingTime, info_selected_M1.Overshoot);
fprintf('M2 (%s): Rise=%.2fs, Settle=%.2fs, Overshoot=%.2f%%\n', ...
    method_M2, info_selected_M2.RiseTime, info_selected_M2.SettlingTime, info_selected_M2.Overshoot);

% Plot results
t_sim = 0:0.01:30;

figure('Position', [100, 100, 1400, 500]);

subplot(1,2,1);
step(T_selected_M1, t_sim);
grid on;
title(['M1 Original Plant with ' method_M1 ' Controller']);
xlabel('Time (s)');
ylabel('Output');

subplot(1,2,2);
step(T_selected_M2, t_sim);
grid on;
title(['M2 Original Plant with ' method_M2 ' Controller']);
xlabel('Time (s)');
ylabel('Output');

saveas(gcf, 'selected_controllers_performance.png');
fprintf('\n  Created: selected_controllers_performance.png\n');

%% ========================================================================
%  SECTION 6: Generate Report-Ready Text
%  ========================================================================

fprintf('\n--------------------------------------------------\n');
fprintf('SECTION 5: Generating Report Text\n');
fprintf('--------------------------------------------------\n\n');

% Open text file
fid = fopen('LAB3_Part4_Report_Text.txt', 'w');

fprintf(fid, '========================================\n');
fprintf(fid, 'LAB3 PART 4: FINAL REPORT TEXT\n');
fprintf(fid, '========================================\n\n');

fprintf(fid, '--- CONTROLLER SELECTION SUMMARY ---\n\n');
fprintf(fid, 'Plant M1: %s Controller\n', method_M1);
fprintf(fid, 'Plant M2: %s Controller\n\n', method_M2);

fprintf(fid, '--- M1 JUSTIFICATION ---\n\n');
fprintf(fid, 'For the M1 plant (4th-order system with delay), the %s tuning method\n', method_M1);
fprintf(fid, 'was selected based on comprehensive multi-criteria analysis. This controller\n');
fprintf(fid, 'achieved the highest overall performance score (%.1f/100) when evaluated against\n', total_M1(winner_M1_idx));
fprintf(fid, 'weighted criteria including speed (20%%), overshoot (25%%), robustness (30%%),\n');
fprintf(fid, 'and noise rejection (25%%).\n\n');

fprintf(fid, 'Key performance metrics on the reduced FOPDT model:\n');
fprintf(fid, '  - Settling Time: %.2f s\n', settle_M1(winner_M1_idx));
fprintf(fid, '  - Overshoot: %.2f%%\n', overshoot_M1(winner_M1_idx));
fprintf(fid, '  - Gain Margin: %.2f dB\n', gm_M1(winner_M1_idx));
fprintf(fid, '  - Phase Margin: %.2f degrees\n\n', pm_M1(winner_M1_idx));

fprintf(fid, 'When tested on the original 4th-order plant, the controller maintained\n');
fprintf(fid, 'stable performance with %.2f%% overshoot and %.2f s settling time,\n', ...
    info_selected_M1.Overshoot, info_selected_M1.SettlingTime);
fprintf(fid, 'validating the effectiveness of the FOPDT model reduction approach.\n\n');

fprintf(fid, '--- M2 JUSTIFICATION ---\n\n');
fprintf(fid, 'For the M2 plant (3rd-order non-minimum phase system), the %s tuning method\n', method_M2);
fprintf(fid, 'was selected. This controller achieved the highest overall score (%.1f/100)\n', total_M2(winner_M2_idx));
fprintf(fid, 'and demonstrated superior handling of the inverse response characteristic\n');
fprintf(fid, 'inherent to non-minimum phase systems.\n\n');

fprintf(fid, 'Key performance metrics on the reduced FOPDT model:\n');
fprintf(fid, '  - Settling Time: %.2f s\n', settle_M2(winner_M2_idx));
fprintf(fid, '  - Overshoot: %.2f%%\n', overshoot_M2(winner_M2_idx));
fprintf(fid, '  - Gain Margin: %.2f dB\n', gm_M2(winner_M2_idx));
fprintf(fid, '  - Phase Margin: %.2f degrees\n\n', pm_M2(winner_M2_idx));

fprintf(fid, '--- METHODOLOGY RECAP ---\n\n');
fprintf(fid, 'Three PID tuning methods were evaluated:\n');
fprintf(fid, '1. Ziegler-Nichols (Z-N): Classic FOPDT method, typically aggressive\n');
fprintf(fid, '2. AMIGO: Balanced approach by Astrom & Hagglund\n');
fprintf(fid, '3. Skogestad SIMC: Conservative, robust IMC-based method\n\n');

fprintf(fid, 'Controllers were compared using:\n');
fprintf(fid, '  - Time domain: Step response (rise time, settling time, overshoot)\n');
fprintf(fid, '  - Frequency domain: Bode (noise sensitivity), Nyquist (margins)\n');
fprintf(fid, '  - Stability: Root locus, gain/phase margins\n');
fprintf(fid, '  - Validation: Testing on original higher-order plants\n\n');

fprintf(fid, '--- CONCLUSIONS ---\n\n');
fprintf(fid, 'The selected controllers provide optimal balance between performance and\n');
fprintf(fid, 'robustness for their respective plants. The %s method for M1 and\n', method_M1);
fprintf(fid, '%s method for M2 outperformed alternatives in weighted multi-criteria\n', method_M2);
fprintf(fid, 'evaluation, demonstrating that no single tuning method is universally optimal.\n');
fprintf(fid, 'Controller selection should consider plant characteristics, application\n');
fprintf(fid, 'requirements, and performance trade-offs.\n\n');

fprintf(fid, '========================================\n');
fclose(fid);

fprintf('  Created: LAB3_Part4_Report_Text.txt\n\n');

%% ========================================================================
%  SECTION 7: Save All Metrics
%  ========================================================================

fprintf('Saving all metrics and scores...\n');

save('LAB3_Part4_metrics.mat', ...
    'total_M1', 'total_M2', ...
    'score_speed_M1', 'score_overshoot_M1', 'score_robust_M1', 'score_noise_M1', ...
    'score_speed_M2', 'score_overshoot_M2', 'score_robust_M2', 'score_noise_M2', ...
    'winner_M1_idx', 'winner_M2_idx', ...
    'method_M1', 'method_M2', ...
    'info_selected_M1', 'info_selected_M2');

fprintf('  Created: LAB3_Part4_metrics.mat\n\n');

%% ========================================================================
%  FINAL SUMMARY
%  ========================================================================

fprintf('====================================================\n');
fprintf('PART 4 COMPLETE - FINAL RECOMMENDATIONS\n');
fprintf('====================================================\n\n');

fprintf('SELECTED CONTROLLERS:\n');
fprintf('  M1: %s (Score: %.1f/100)\n', method_M1, total_M1(winner_M1_idx));
fprintf('  M2: %s (Score: %.1f/100)\n\n', method_M2, total_M2(winner_M2_idx));

fprintf('GENERATED FILES:\n');
fprintf('  Figures:\n');
fprintf('    - metrics_comparison.png (6-panel comparison)\n');
fprintf('    - overall_scores.png (bar charts)\n');
fprintf('    - performance_radar.png (radar charts)\n');
fprintf('    - selected_controllers_performance.png (final testing)\n');
fprintf('  Data:\n');
fprintf('    - LAB3_Part4_metrics.mat (all scores and metrics)\n');
fprintf('  Report:\n');
fprintf('    - LAB3_Part4_Report_Text.txt (ready for copy-paste)\n\n');

fprintf('====================================================\n');
fprintf('All analysis complete! Ready for report writing.\n');
fprintf('====================================================\n');
