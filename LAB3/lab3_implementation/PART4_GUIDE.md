# LAB3 Part 4: Controller Selection Guide

## What Part 4 Does

Part 4 is the **final decision-making and report generation** phase that brings everything together from Parts 1-3.

### Key Features:

1. **Objective Scoring System** - No guesswork!
2. **Automated Controller Selection** - Based on weighted criteria
3. **Complete Justifications** - Ready for your report
4. **Additional Visualizations** - 4 new figures
5. **Report-Ready Text** - Copy-paste into your document

---

## How to Run

### Option 1: Run Part 4 Only (After Parts 1-3)

```matlab
cd LAB3/lab3_implementation
LAB3_Part4_Selection_and_Report
```

### Option 2: Run Complete Pipeline

```matlab
RUN_ALL_LAB3  % Runs all 4 parts with pauses between
```

---

## What Gets Generated

### **Data File:**
- `LAB3_Part4_metrics.mat` - All scores and selections

### **Figures (4 new):**

1. **`metrics_comparison.png`**
   - 6-panel bar chart comparison
   - Rise time, settling time, overshoot
   - Gain margin, phase margin, noise sensitivity
   - Side-by-side M1 and M2 comparison

2. **`overall_scores.png`**
   - Final weighted scores (0-100 scale)
   - Clear visual winner for each plant

3. **`performance_radar.png`**
   - Spider/radar charts
   - 4 axes: Speed, Overshoot, Robustness, Noise
   - Shows performance profile of each method

4. **`selected_controllers_performance.png`**
   - Step response of winners on ORIGINAL plants
   - M1: 4th-order plant (not FOPDT)
   - M2: 3rd-order plant (not FOPDT)

### **Report Text:**
- **`LAB3_Part4_Report_Text.txt`**
  - Executive summary
  - M1 justification paragraph
  - M2 justification paragraph
  - Methodology recap
  - Conclusions
  - Ready to copy-paste into your CBA/SBAI report!

---

## The Scoring System

### Criteria & Weights:

| Criterion | Weight | What It Measures |
|-----------|--------|------------------|
| **Speed** | 20% | Rise time + settling time |
| **Overshoot** | 25% | Peak overshoot % |
| **Robustness** | 30% | Gain margin + phase margin |
| **Noise Rejection** | 25% | High-frequency gain (lower = better) |

**Total:** 100%

### How Scoring Works:

1. **Normalize** each metric to 0-100 scale
   - For metrics where "lower is better" (like overshoot), invert the scale
   - For metrics where "higher is better" (like GM), use as-is

2. **Apply weights** to each normalized score

3. **Sum** to get total score (0-100)

4. **Rank** controllers (1st, 2nd, 3rd)

5. **Select winner** automatically

---

## Understanding the Results

### Console Output Sections:

#### **1. Scoring Table**
```
M1 - Overall Scores (0-100):
┌─────────────┬─────────┬─────────┬─────────┬─────────┬─────────┐
│ Method      │  Speed  │Overshoot│ Robust. │  Noise  │  TOTAL  │
├─────────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Z-N         │   xx.x  │   xx.x  │   xx.x  │   xx.x  │   xx.x  │
│ AMIGO       │   xx.x  │   xx.x  │   xx.x  │   xx.x  │   xx.x  │
│ SIMC        │   xx.x  │   xx.x  │   xx.x  │   xx.x  │   xx.x  │
└─────────────┴─────────┴─────────┴─────────┴─────────┴─────────┘

M1 Winner: [METHOD] (Score: xx.x/100)
```

#### **2. Detailed Justification**
- Key strengths of winner
- Ranking for each metric (1st/2nd/3rd place)
- Comparison with alternatives
- Why alternatives were not selected

#### **3. Testing Results**
- Performance on original plants
- Validation that FOPDT reduction worked well

---

## Expected Winners (Based on Your Data)

From your command_window_output.txt:

### **M1: Likely AMIGO** ✅
- Best overshoot (2.80%)
- Excellent GM (11.06 dB - highest)
- Good settling time (9.211 s)
- Balanced performance

**Why not Z-N?**
- Low GM (4.16 dB < 6 dB threshold) ⚠️
- Higher overshoot (7.76%)

**Why not SIMC?**
- Lower overall score
- Less balanced

### **M2: Likely AMIGO** ✅
- Lowest overshoot (3.12%)
- Best GM (11.05 dB)
- Good settling time (14.952 s)
- Best for non-minimum phase plant

**Why not Z-N?**
- Low GM (4.08 dB) ⚠️
- High overshoot (11.76%)

**Why not SIMC?**
- Lower overall score

---

## For Your Report

### What to Include:

1. **Part 4 Methodology**
   ```
   "A weighted multi-criteria decision matrix was used to objectively
   select the optimal PID tuning method for each plant. Criteria included
   speed (20%), overshoot (25%), robustness (30%), and noise rejection
   (25%), with scores normalized to 0-100 scale."
   ```

2. **Scoring Table** (from console output)
   - Copy the formatted table directly

3. **Justification Paragraphs**
   - Use text from `LAB3_Part4_Report_Text.txt`
   - Already formatted and ready!

4. **Figures to Include:**
   - `metrics_comparison.png` - Shows all raw metrics
   - `overall_scores.png` - Shows clear winner
   - `performance_radar.png` - Shows performance profile
   - `selected_controllers_performance.png` - Validates on original plants

5. **Key Insight for M2:**
   ```
   "The non-minimum phase characteristic of M2 (inverse response due
   to RHP zero) makes it more challenging to control. The selected
   controller effectively manages this behavior while maintaining
   stability margins."
   ```

---

## Adjusting Weights (Optional)

If you want different priorities, edit the script (lines ~90-93):

```matlab
% Current weights
w_speed = 0.20;       % 20%
w_overshoot = 0.25;   % 25%
w_robustness = 0.30;  % 30% - highest priority
w_noise = 0.25;       % 25%
```

**Example alternatives:**

**For fast processes:**
```matlab
w_speed = 0.40;       % Prioritize speed
w_overshoot = 0.20;
w_robustness = 0.25;
w_noise = 0.15;
```

**For safety-critical:**
```matlab
w_speed = 0.10;
w_overshoot = 0.35;   % Minimize overshoot
w_robustness = 0.40;  % Maximize robustness
w_noise = 0.15;
```

---

## Troubleshooting

### "Part 2 data not found"
→ Run `LAB3_Part2_PID_Design.m` first

### Unexpected winner selected
→ Check the scoring table to see why
→ Possibly adjust weights if needed
→ Remember: This is OBJECTIVE, not subjective!

### Want to see calculations
→ Check `LAB3_Part4_metrics.mat` in MATLAB
→ Contains all intermediate scores

---

## Summary

Part 4 **completes your LAB3** by:
- ✅ Objectively selecting best controllers
- ✅ Providing complete justifications
- ✅ Generating report-ready text
- ✅ Creating final visualizations
- ✅ Validating on original plants

**Everything you need for the report is now generated!** 🎉

---

## Report Writing Checklist

After running Part 4:

- [ ] Copy scoring tables from console to report
- [ ] Include 4 Part 4 figures in report
- [ ] Use justification text from `LAB3_Part4_Report_Text.txt`
- [ ] Mention weighted criteria methodology
- [ ] Explain why alternatives were not selected
- [ ] Include validation results on original plants
- [ ] Discuss M2 non-minimum phase challenge
- [ ] Conclude with practical recommendations

**Total Report Length:** ~6 pages (CBA/SBAI format)

Good luck! 📝🎓
