# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a control systems engineering repository for laboratory assignments (IOSC 2025-PUCPR) focused on system identification, modeling, and PID controller tuning. The work involves analyzing higher-order plants, creating reduced-order models, and designing PID controllers using various tuning methods.

## Repository Structure

- **LAB2/**: System identification and modeling lab
  - **brenos_lab2/Lab2/Lab2_implemented/**: Working implementation
    - `matlab_script.m`: Main analysis script for model identification
    - `lab2_malha_aberta.slx`: Simulink open-loop simulation model
    - `*.png`: Result plots and graphs
    - `matlab.mat`: MATLAB workspace data
- **LAB3/**: PID controller tuning analysis lab
  - `IOSC_2025B_Lab03.pdf`: Lab instructions for critical analysis of PID tuning rules
  - **lab3_implementation/**: Complete LAB3 implementation
    - `RUN_ALL_LAB3.m`: Master script to run all parts
    - `LAB3_Part1_Identification.m`: FOPDT model identification
    - `LAB3_Part2_PID_Design.m`: PID tuning (Z-N, AMIGO, SIMC)
    - `LAB3_Part3_Analysis.m`: Comprehensive graphical analysis
    - `README.md`: Detailed usage guide
  - `novo.slx`: Reference Simulink model (friend's implementation)

## Key Technical Concepts

### LAB2: System Identification

The main plant under study is a 4th-order system with delay:

```
M(s) = 1·e^(-s) / [(s+1)(0.4s+1)(0.4²s+1)(0.4³s+1)]
```

**Objectives:**
- Identify first and second-order models with delay from step response data
- Compare models using:
  - RMSE (Root Mean Square Error)
  - IAE (Integral Absolute Error)
  - Total Variation
- Use both graphical methods and MATLAB System Identification Toolbox

**Key Variables in matlab_script.m:**
- `M`: Original 4th-order transfer function with input delay
- `G1_atraso`: First-order model with Padé approximation for delay (φ=1.1, Ts=6)
- `GTB1`: First-order model from System Identification Toolbox
- `GTB2`: Second-order model from System Identification Toolbox
- Step input configured at t=1s with amplitude 0→1

### LAB3: PID Tuning Analysis

**Objectives:**
- Design PID controllers using 3 different tuning rules
- Compare performance and robustness characteristics
- Select best controller for each plant based on analysis

**Plants to analyze:**
```
M1(s) = 1·e^(-s) / [(s+1)(0.4s+1)(0.4²s+1)(0.4³s+1)]  [4th-order with delay]
M2(s) = (-1.1s+1) / (s³+3s²+3s+1)  [3rd-order, non-minimum phase]
```

**PID Tuning Methods:**
1. **Ziegler-Nichols (Z-N):** Classic FOPDT method - fast but may overshoot
2. **AMIGO:** Åström & Hägglund - balanced performance/robustness
3. **Skogestad/SIMC:** Internal Model Control - most robust, often PI

**Analysis methods:**
- Time response analysis (settling time, overshoot, rise time, peak time)
- Root locus for pole placement and stability analysis
- Bode diagrams for noise sensitivity (high-frequency gain)
- Nyquist diagrams for robustness (gain/phase margins)
- Testing on original plants (not just reduced models)

**Key Metrics:**
- Gain Margin (GM): Good if > 6 dB
- Phase Margin (PM): Good if > 30°
- Overshoot: Lower is better for most applications
- Settling Time: How quickly system reaches steady state

## MATLAB/Simulink Workflow

### Running Lab 2 Analysis

```matlab
cd LAB2/brenos_lab2/Lab2/Lab2_implemented/
matlab_script  % Runs complete analysis pipeline
```

The script automatically:
1. Defines the plant M(s) with delay
2. Creates first-order approximation using graphical method (Padé delay approximation)
3. Runs Simulink simulation `lab2_malha_aberta.slx`
4. Generates comparison plots (3 figures)
5. Calculates and displays RMSE, IAE, and Total Variation for all models

### Running Lab 3 Analysis

```matlab
cd LAB3/lab3_implementation/
RUN_ALL_LAB3  % Runs complete LAB3 pipeline
```

Or run parts individually:
```matlab
LAB3_Part1_Identification  % Identify FOPDT models for M1 and M2
LAB3_Part2_PID_Design      % Design PIDs using 3 tuning methods
LAB3_Part3_Analysis        % Comprehensive graphical analysis
```

The pipeline:
1. **Part 1:** Identifies FOPDT models (K, T, θ) using graphical and toolbox methods
2. **Part 2:** Calculates PID parameters (Kp, Ki, Kd) for 6 controllers
3. **Part 3:** Generates all required plots and comparison tables
4. **Outputs:** 8 PNG figures + 2 MAT files with all results

### Key MATLAB Commands

- **Opening Simulink model**: `open_system('lab2_malha_aberta.slx')`
- **Running simulation**: `simout = sim('lab2_malha_aberta.slx')`
- **System Identification Toolbox**: Access via `systemIdentification` GUI or programmatically
- **Transfer function creation**: `tf(num, den)` or `tf('s')` for symbolic

### Simulink Model Structure

The `lab2_malha_aberta.slx` model contains:
- Step input (U) with configurable timing
- Original plant M with transfer function and delay blocks
- First-order graphical model (G1_atraso) with Padé approximation
- Toolbox-identified models (GTB1, GTB2)
- Output scopes for comparison

## Model Validation Metrics

When comparing identified models to the original plant response:

1. **RMSE (Root Mean Square Error)**: `sqrt(mean((Y - Y_model).^2))`
   - Penalizes large errors more heavily

2. **IAE (Integral Absolute Error)**: `trapz(time, abs(Y - Y_model))`
   - Overall cumulative error measure

3. **Total Variation**: `sum(abs(diff(Y_model)))`
   - Measures signal smoothness/oscillation

Lower values indicate better model fit. Reference: Muroi & Adachi (2015) IFAC-PapersOnLine.

## Report Deliverables

Both labs require technical reports in **CBA/SBAI conference format** (max 6 pages) with:
- Brief theoretical documentation of methods used
- Mathematical models obtained
- Comparison plots and performance metric tables
- Justified selection of best model/controller for each plant

## Dependencies

- MATLAB (tested with recent versions supporting Simulink)
- Simulink
- Control System Toolbox
- System Identification Toolbox (for LAB2 automated identification)
