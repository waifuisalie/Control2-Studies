%% LAB3 - Master Script: Run Complete Analysis
% IOSC 2025-PUCPR
%
% This script runs the complete LAB3 analysis pipeline:
% - Part 1: Plant identification (FOPDT models)
% - Part 2: PID controller design (3 tuning methods)
% - Part 3: Graphical analysis and comparison
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
fprintf('STEP 1/3: Running Plant Identification...\n');
fprintf('--------------------------------------------------------\n');
LAB3_Part1_Identification;

fprintf('\nPress any key to continue to Part 2...\n');
pause;

%% Part 2: PID Controller Design
fprintf('\n\n');
fprintf('STEP 2/3: Designing PID Controllers...\n');
fprintf('--------------------------------------------------------\n');
LAB3_Part2_PID_Design;

fprintf('\nPress any key to continue to Part 3...\n');
pause;

%% Part 3: Graphical Analysis
fprintf('\n\n');
fprintf('STEP 3/3: Performing Graphical Analysis...\n');
fprintf('--------------------------------------------------------\n');
LAB3_Part3_Analysis;

%% Summary
fprintf('\n\n');
fprintf('========================================================\n');
fprintf('  LAB3 Analysis Complete!                               \n');
fprintf('========================================================\n\n');

fprintf('All analysis completed successfully!\n\n');

fprintf('Generated Files:\n');
fprintf('  Data Files:\n');
fprintf('    - LAB3_Part1_models.mat\n');
fprintf('    - LAB3_Part2_controllers.mat\n\n');

fprintf('  Figures:\n');
fprintf('    - M1_identification_results.png\n');
fprintf('    - M2_identification_results.png\n');
fprintf('    - error_metrics_comparison.png\n');
fprintf('    - time_response_comparison.png\n');
fprintf('    - root_locus_comparison.png\n');
fprintf('    - bode_analysis.png\n');
fprintf('    - nyquist_analysis.png\n');
fprintf('    - original_plant_response.png\n\n');

fprintf('Next Steps:\n');
fprintf('  1. Review all generated plots\n');
fprintf('  2. Use the console output tables for your report\n');
fprintf('  3. Write your technical report in CBA/SBAI format\n');
fprintf('  4. Justify your controller selections based on the analysis\n\n');

fprintf('========================================================\n');
