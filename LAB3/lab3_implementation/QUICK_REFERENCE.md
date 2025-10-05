# LAB3 Quick Reference Card

## Run Everything

```matlab
cd LAB3/lab3_implementation
RUN_ALL_LAB3
```

## What You Get

### Data Files
- `LAB3_Part1_models.mat` - Identified FOPDT models
- `LAB3_Part2_controllers.mat` - All 6 PID controllers

### Figures (8 total)
1. `M1_identification_results.png` - M1 model comparison
2. `M2_identification_results.png` - M2 model comparison
3. `error_metrics_comparison.png` - RMSE/IAE bar charts
4. `time_response_comparison.png` - Step responses with metrics
5. `root_locus_comparison.png` - Pole placement
6. `bode_analysis.png` - Noise sensitivity
7. `nyquist_analysis.png` - Robustness (GM/PM)
8. `original_plant_response.png` - Controllers on full-order plants

## The 3 PID Tuning Methods

| Method | Characteristics | When to Use |
|--------|----------------|-------------|
| **Ziegler-Nichols** | Fast, aggressive, may overshoot | Need quick response, can tolerate overshoot |
| **AMIGO** | Balanced, moderate speed & overshoot | General purpose, good compromise |
| **SIMC** | Slow, robust, minimal overshoot | Need reliability, can't tolerate overshoot |

## Key Formulas

### FOPDT Model
```
G(s) = K * e^(-θs) / (T*s + 1)
```
- **K** = Steady-state gain
- **T** = Time constant
- **θ** = Time delay

### PID Controller
```
C(s) = Kp + Ki/s + Kd*s
```
- **Kp** = Proportional gain
- **Ki** = Integral gain (Kp/Ti)
- **Kd** = Derivative gain (Kp*Td)

## Understanding Results

### Good Controller Has:
- ✓ Settling time < 10-15 seconds (depends on application)
- ✓ Overshoot < 20%
- ✓ Gain Margin > 6 dB (>12 dB excellent)
- ✓ Phase Margin > 30° (>60° excellent)
- ✓ Low high-frequency gain (noise rejection)

### Trade-offs:
- **Fast response** ↔ **High overshoot**
- **Tight control** ↔ **Noise sensitivity**
- **Performance** ↔ **Robustness**

## Console Output Sections

The scripts print formatted tables you can copy to your report:

1. **Part 1:** FOPDT parameters (K, T, θ), error metrics (RMSE, IAE, TV)
2. **Part 2:** PID parameters table (Kp, Ki, Kd) for all 6 controllers
3. **Part 3:**
   - Time response characteristics table
   - Closed-loop poles
   - High-frequency gains
   - Gain/Phase margins table

## For Your Report

### Required Sections:
1. **Introduction** - Objectives and methodology
2. **Theory** - Brief explanation of 3 tuning methods
3. **Part 1** - Plant identification results
4. **Part 2** - PID parameters for all methods
5. **Part 3** - Graphical analysis:
   - Time response comparison
   - Root locus interpretation
   - Bode analysis (noise)
   - Nyquist analysis (robustness)
6. **Part 4** - Testing on original plants
7. **Conclusion** - Controller selection with justification

### Justification Template:

"For M1, we selected **[METHOD]** because:
- Time response: [settling time/overshoot values]
- Robustness: [GM/PM values]
- Noise sensitivity: [high-freq gain]
- Performance on original plant: [observations]

This method provides the best balance between [trade-offs] for this application."

## Plants Overview

### M1: 4th-order with delay
- Stable, no zeros
- Well-behaved step response
- Delay makes control challenging

### M2: 3rd-order non-minimum phase
- Has zero in RHP (numerator: -1.1s+1)
- **Inverse response** (goes negative first!)
- More challenging to control

## Troubleshooting

**"Models not found"**
→ Run scripts in order (Part1 → Part2 → Part3)

**"Toolbox not available"**
→ OK, graphical method will be used

**Plots missing**
→ Check current directory for PNG files

**Controller unstable**
→ Check FOPDT parameters are positive
→ Verify model identification was successful

## Tips

- Run `RUN_ALL_LAB3` first to see if everything works
- Use console output for report tables
- Include ALL 8 figures in your report
- Explain M2 inverse response in your report
- Compare your results with `novo.slx`
- Test different τc values in SIMC if needed

## Time Estimate

- Running all scripts: ~2-5 minutes
- Reviewing results: ~30 minutes
- Writing report: ~4-6 hours

Good luck! 🚀
