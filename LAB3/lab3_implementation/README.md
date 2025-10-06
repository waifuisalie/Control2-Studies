# LAB3 Implementation Guide

## Overview

This directory contains a complete implementation of LAB3 (Practical Laboratory 3) for IOSC 2025-PUCPR: Critical Analysis of PID Tuning Rules.

## File Structure

```
lab3_implementation/
├── README.md                          # This file - Usage guide
├── QUICK_REFERENCE.md                 # Quick lookup card
├── PART4_GUIDE.md                     # Part 4 detailed guide
├── RESULTS_ANALYSIS.md                # ⭐ Complete results analysis
│
├── RUN_ALL_LAB3.m                     # ⭐ Master script - runs all 4 parts
├── LAB3_Part1_Identification.m        # Part 1: System identification
├── LAB3_Part2_PID_Design.m            # Part 2: PID controller design
├── LAB3_Part3_Analysis.m              # Part 3: Graphical analysis
├── LAB3_Part4_Selection_and_Report.m  # ⭐ Part 4: Controller selection
│
├── create_simulink_model.m            # (Optional) Creates Simulink models
│
├── LAB3_Part1_models.mat              # Generated: FOPDT models
├── LAB3_Part2_controllers.mat         # Generated: All 6 PID controllers
├── LAB3_Part4_metrics.mat             # Generated: Scores and metrics
├── LAB3_Part4_Report_Text.txt         # ⭐ Generated: Report-ready text
│
└── *.png (12 files)                   # Generated: All figures
    ├── M1_identification_results.png
    ├── M2_identification_results.png
    ├── error_metrics_comparison.png
    ├── time_response_comparison.png
    ├── root_locus_comparison.png
    ├── bode_analysis.png
    ├── nyquist_analysis.png
    ├── original_plant_response.png
    ├── metrics_comparison.png
    ├── overall_scores.png
    ├── performance_radar.png
    └── selected_controllers_performance.png
```

## Quick Start

### Option 1: Run Everything at Once ⭐ (Recommended)

```matlab
cd LAB3/lab3_implementation
RUN_ALL_LAB3
```

**This will run all 4 parts:**
1. **Part 1:** Identify FOPDT models for M1 and M2
2. **Part 2:** Design 6 PID controllers (3 methods × 2 plants)
3. **Part 3:** Perform comprehensive graphical analysis
4. **Part 4:** Select best controllers and generate report text

**Output:** 12 PNG figures + 3 MAT files + 1 TXT report file

**Time:** ~2-5 minutes (with pauses between parts)

### Option 2: Run Parts Individually

```matlab
% Part 1: Identify plants
LAB3_Part1_Identification

% Part 2: Design PIDs (requires Part 1)
LAB3_Part2_PID_Design

% Part 3: Analyze and compare (requires Part 2)
LAB3_Part3_Analysis

% Part 4: Select and justify (requires Part 2)
LAB3_Part4_Selection_and_Report
```

### Option 3: Run Only Part 4 (After Parts 1-3)

```matlab
% If you've already run Parts 1-3 and want to regenerate Part 4
LAB3_Part4_Selection_and_Report
```

## What Each Part Does

### Part 1: System Identification

**File:** `LAB3_Part1_Identification.m`

- Defines M1 (4th-order with delay) and M2 (3rd-order non-minimum phase)
- Identifies first-order models with delay (FOPDT) using:
  - Graphical method (Smith method, two-point method)
  - MATLAB System Identification Toolbox
- Calculates error metrics (RMSE, IAE, Total Variation)
- Selects best model for each plant
- **Outputs:**
  - `LAB3_Part1_models.mat` - Identified models
  - `M1_identification_results.png`
  - `M2_identification_results.png`
  - `error_metrics_comparison.png`

### Part 2: PID Controller Design

**File:** `LAB3_Part2_PID_Design.m`

- Loads FOPDT models from Part 1
- Calculates PID parameters using 3 tuning methods:
  1. **Ziegler-Nichols** (FOPDT method)
  2. **AMIGO** (Åström & Hägglund)
  3. **Skogestad/SIMC** (Internal Model Control)
- Creates 6 PID controllers total (3 for M1, 3 for M2)
- Displays parameter tables
- **Outputs:**
  - `LAB3_Part2_controllers.mat` - All PID controllers

### Part 3: Graphical Analysis

**File:** `LAB3_Part3_Analysis.m`

Performs 4 types of analysis as required by the lab:

1. **Time Response Analysis**
   - Settling time, overshoot, rise time, peak time
   - Step response plots

2. **Root Locus Analysis**
   - Pole placement visualization (uses Padé approximation for delays)
   - Closed-loop poles for each controller

3. **Bode Diagram Analysis**
   - Noise sensitivity (high-frequency gain)
   - Gain/phase margins

4. **Nyquist Diagram Analysis**
   - Robustness metrics (GM, PM)
   - Stability analysis

5. **Original Plant Testing**
   - Tests controllers on full-order M1 and M2 (not reduced models)

**Outputs:**
- `time_response_comparison.png`
- `root_locus_comparison.png`
- `bode_analysis.png`
- `nyquist_analysis.png`
- `original_plant_response.png`

### Part 4: Controller Selection and Report Generation ⭐

**File:** `LAB3_Part4_Selection_and_Report.m`

Automatically selects the best controller for each plant using weighted multi-criteria analysis:

**Weighted Scoring System:**
- Speed (rise + settling time): 20%
- Overshoot: 25%
- Robustness (GM + PM): 30%
- Noise Rejection: 25%

**Process:**
1. Loads all controllers from Part 2
2. Recalculates all performance metrics
3. Normalizes metrics to 0-100 scale
4. Applies weights and calculates total scores
5. Selects winners automatically
6. Generates detailed justifications
7. Tests selected controllers on original plants
8. Creates report-ready text file

**Outputs:**
- `metrics_comparison.png` (6-panel bar chart)
- `overall_scores.png` (final scores)
- `performance_radar.png` (spider charts)
- `selected_controllers_performance.png` (original plant testing)
- `LAB3_Part4_metrics.mat` (all scores and data)
- `LAB3_Part4_Report_Text.txt` ⭐ (ready for copy-paste into report)

## PID Tuning Methods Used

### 1. Ziegler-Nichols (Z-N)
- Classic method, typically aggressive
- Good for fast response
- May have significant overshoot
- Formula based on FOPDT parameters (K, T, θ)

### 2. AMIGO
- More conservative than Z-N
- Better disturbance rejection
- Improved overshoot characteristics
- Good balance between performance and robustness

### 3. Skogestad/SIMC
- Most conservative (robust)
- Often produces PI controllers (Kd = 0)
- Excellent robustness (high phase margin)
- May be slower than other methods

## Understanding the Results

### Time Response Metrics

- **Rise Time:** How quickly the output reaches the setpoint (lower = faster)
- **Settling Time:** Time to stay within 2% of setpoint (lower = faster)
- **Overshoot:** Peak above setpoint as percentage (lower = less oscillation)
- **Peak Time:** Time to reach maximum overshoot

### Robustness Metrics

- **Gain Margin (GM):** How much gain can increase before instability
  - Good: GM > 6 dB
  - Excellent: GM > 12 dB

- **Phase Margin (PM):** How much phase lag before instability
  - Good: PM > 30°
  - Excellent: PM > 60°

### Noise Sensitivity

- **High-frequency gain:** Controller gain at high frequencies
  - Lower = better noise rejection
  - High derivative gain → high noise amplification

## Choosing the Best Controller

Consider these trade-offs:

| Criterion | Favor |
|-----------|-------|
| Fast response | Z-N |
| Low overshoot | AMIGO or SIMC |
| Robustness | SIMC |
| Noise rejection | SIMC (lower Kd) |
| Balance | AMIGO |

The script automatically suggests controllers based on these criteria.

## Important Files to Review

### 📊 For Understanding Results:
1. **`RESULTS_ANALYSIS.md`** ⭐ **READ THIS FIRST!**
   - Complete breakdown of Part 4 results
   - Why SIMC was selected
   - Detailed comparison tables
   - Key insights and interpretation

2. **`LAB3_Part4_Report_Text.txt`**
   - Pre-written report sections
   - Controller justifications
   - Ready to copy-paste into your report

3. **`command_window_output.txt`**
   - All console output from running the scripts
   - Contains all numerical tables
   - Performance metrics for all controllers

### 📚 For Reference:
4. **`QUICK_REFERENCE.md`** - Quick lookup for formulas and tips
5. **`PART4_GUIDE.md`** - Detailed Part 4 explanation

## For Your Report

The lab requires a technical report (CBA/SBAI format, max 6 pages) with:

### Required Sections:

1. **Introduction & Objectives**
   - Brief overview of LAB3 goals

2. **Theoretical Background**
   - Brief theory of the 3 tuning methods (Z-N, AMIGO, SIMC)
   - FOPDT model reduction approach

3. **Methodology**
   - Part 1: System identification (graphical + toolbox)
   - Part 2: PID parameter calculation
   - Part 3: Graphical analysis methods
   - Part 4: Weighted multi-criteria selection

4. **Results**
   - **Include all 12 figures** (or select most important)
   - **Copy tables from console output** (formatted and ready!)
   - Part 1: FOPDT models for M1 and M2
   - Part 2: PID parameters table
   - Part 3: Performance metrics (time response, GM, PM, noise)
   - Part 4: Scoring table and final selection

5. **Discussion**
   - Why SIMC was selected (from `LAB3_Part4_Report_Text.txt`)
   - Comparison of methods
   - Trade-offs analysis
   - Validation on original plants

6. **Conclusions**
   - Controller recommendations
   - When to use each method
   - Practical implications

**Tips:**
- ✅ Use text from `LAB3_Part4_Report_Text.txt` for conclusions
- ✅ Copy formatted tables from `command_window_output.txt`
- ✅ Refer to `RESULTS_ANALYSIS.md` for interpretation
- ✅ Include metrics from Part 3 output
- ✅ Explain why Z-N failed (low GM < 6 dB threshold)

## Expected Results Summary

After running `RUN_ALL_LAB3`, you should get:

### Selected Controllers:
- **M1:** SIMC (Score: 67.5/100)
- **M2:** SIMC (Score: 71.1/100)

### Why SIMC Won:
- ✅ Best noise rejection (Kd = 0, no derivative)
- ✅ Best settling time
- ✅ Good overshoot (4.05%)
- ✅ Adequate robustness (GM > 6 dB threshold)

### Why Z-N Failed:
- ❌ GM = 4.16 dB (M1) and 4.08 dB (M2) **< 6 dB threshold**
- ❌ Worst noise sensitivity
- ❌ Highest overshoot

### Why AMIGO Was Close Second:
- ✅ Best overshoot (2.80-3.12%)
- ✅ Best robustness (GM ~11 dB)
- ⚠️ But worse noise rejection than SIMC (has derivative)

**Read `RESULTS_ANALYSIS.md` for detailed explanation!**

## Troubleshooting

### "Part X models not found"
- Make sure to run parts in order (1 → 2 → 3 → 4)
- Or use `RUN_ALL_LAB3.m`

### "System Identification Toolbox not available"
- The scripts will fall back to graphical methods
- Results will still be valid

### "Adding polar plot to axes not supported"
- Fixed in updated `LAB3_Part4_Selection_and_Report.m`
- Make sure you have the latest version
- Uses `subplot(1,2,1,polaraxes)` syntax

### Plots look wrong
- Check that your models are stable
- Verify FOPDT parameters are reasonable (K, T, θ > 0)

### Different controller selected than expected
- Check the weighting in Part 4 (lines ~90-93)
- Current: Speed 20%, Overshoot 25%, Robustness 30%, Noise 25%
- You can adjust weights if needed

## Notes

- The implementation follows the structure of `novo.slx` (your friend's Simulink model)
- Uses same 3 tuning methods: Ziegler-Nichols, AMIGO, Skogestad/SIMC
- M2 has inverse response (non-minimum phase zero) - this is normal!
- All methods work on the reduced FOPDT models, then test on original plants
- Generated plots are saved automatically in the current directory
- Part 4 automatically selects best controller using objective scoring

## Additional Resources

- **`RESULTS_ANALYSIS.md`** - Complete results breakdown ⭐
- **`LAB3_Part4_Report_Text.txt`** - Report-ready text
- **`QUICK_REFERENCE.md`** - Formulas and quick tips
- **`PART4_GUIDE.md`** - Part 4 detailed guide
- **LAB3 assignment PDF** - Original requirements
- **CLAUDE.md** (in repository root) - Overall project guide

## Questions?

Refer to:
- LAB3 assignment PDF (`IOSC_2025B_Lab03.pdf`)
- CLAUDE.md in the repository root
- Your friend's `novo.slx` for reference
- `RESULTS_ANALYSIS.md` for result interpretation

Good luck with your report! 🎓📝
