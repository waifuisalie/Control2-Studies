%% LAB3 - Master Script: Run Complete Analysis
% IOSC 2025-PUCPR
%
% This script runs the complete LAB3 analysis pipeline:
% - Part 1: Plant identification (FOPDT models)
% - Part 2: PID controller design (3 tuning methods)
% - Part 3: Graphical analysis and comparison
% - Part 4: Controller selection and report generation
%
% Author: Lab3 Implementation
% Date: 2025

clear; clc; close all;

fprintf('\n');
fprintf('========================================================\n');
fprintf('  LAB3 - Complete Analysis Pipeline                     \n');
fprintf('  IOSC 2025-PUCPR                                       \n');
fprintf('========================================================\n\n');

%% Part 1: System Identification
fprintf('STEP 1/4: Running Plant Identification...\n');
fprintf('--------------------------------------------------------\n');
LAB3_Part1_Identification;

fprintf('\nPress any key to continue to Part 2...\n');
pause;

%% Part 2: PID Controller Design
fprintf('\n\n');
fprintf('STEP 2/4: Designing PID Controllers...\n');
fprintf('--------------------------------------------------------\n');
LAB3_Part2_PID_Design;

fprintf('\nPress any key to continue to Part 3...\n');
pause;

%% Part 3: Graphical Analysis
fprintf('\n\n');
fprintf('STEP 3/4: Performing Graphical Analysis...\n');
fprintf('--------------------------------------------------------\n');
LAB3_Part3_Analysis;

fprintf('\nPress any key to continue to Part 4...\n');
pause;

%% Part 4: Controller Selection and Report
fprintf('\n\n');
fprintf('STEP 4/4: Controller Selection and Report Generation...\n');
fprintf('--------------------------------------------------------\n');
LAB3_Part4_Selection_and_Report;

%% Summary
fprintf('\n\n');
fprintf('========================================================\n');
fprintf('  LAB3 Analysis Complete!                               \n');
fprintf('========================================================\n\n');

fprintf('All analysis completed successfully!\n\n');

fprintf('Generated Files:\n');
fprintf('  Data Files:\n');
fprintf('    - LAB3_Part1_models.mat\n');
fprintf('    - LAB3_Part2_controllers.mat\n');
fprintf('    - LAB3_Part4_metrics.mat\n\n');

fprintf('  Figures (12 total):\n');
fprintf('    Part 1: M1_identification_results.png\n');
fprintf('    Part 1: M2_identification_results.png\n');
fprintf('    Part 1: error_metrics_comparison.png\n');
fprintf('    Part 3: time_response_comparison.png\n');
fprintf('    Part 3: root_locus_comparison.png\n');
fprintf('    Part 3: bode_analysis.png\n');
fprintf('    Part 3: nyquist_analysis.png\n');
fprintf('    Part 3: original_plant_response.png\n');
fprintf('    Part 4: metrics_comparison.png\n');
fprintf('    Part 4: overall_scores.png\n');
fprintf('    Part 4: performance_radar.png\n');
fprintf('    Part 4: selected_controllers_performance.png\n\n');

fprintf('  Report Text:\n');
fprintf('    - LAB3_Part4_Report_Text.txt (ready to copy-paste)\n\n');

fprintf('Next Steps:\n');
fprintf('  1. Review all 12 generated plots\n');
fprintf('  2. Read LAB3_Part4_Report_Text.txt for report content\n');
fprintf('  3. Use console output tables for your CBA/SBAI report\n');
fprintf('  4. Include selected controller justifications in conclusion\n\n');

fprintf('========================================================\n');
