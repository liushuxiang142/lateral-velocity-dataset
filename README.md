# Real-Vehicle Lateral-Velocity Dataset

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.24440814.svg)](https://doi.org/10.5281/zenodo.24440814)
[![License: CC BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)

**Archived release:** v1.0.0 — DOI [10.5281/zenodo.24440814](https://doi.org/10.5281/zenodo.24440814)
**Concept DOI (always resolves to the latest version):** [10.5281/zenodo.24440813](https://doi.org/10.5281/zenodo.24440813)

Data accompanying the manuscript

> **Vehicle Lateral Velocity Estimation System Embedding Time-Varying Cornering Stiffness Learning Considering Sim-to-Real Gap**

Shuxiang Liu, Letian Gao, Jiarui Mei, Zihao Huang, Xin Xia, and Lu Xiong

---

## 1. What is in this repository

Three continuous real-vehicle recordings from a closed proving ground
(Shanghai, China), sampled at **100 Hz** (10 ms) and synchronised on a common
time grid. Together they contain about 4.4 min of valid aggressive-driving data.

| File | Rows | Columns | Duration | Role in the paper |
|---|---|---|---|---|
| `data/1.csv` | 8 420 | 118 | 84.2 s | Trial 1 — sim-to-real fine-tuning |
| `data/2.csv` | 9 216 | 121 | 92.1 s | Trial 2 — sim-to-real fine-tuning |
| `data/3.csv` | 8 819 | 121 | 88.2 s | Trial 3 — held-out independent test set |

Trials 1 and 2 are used to fine-tune the physics-guided LSTM, whereas Trial 3 is
excluded from training and is used only for evaluation, so it covers the four
driving regimes discussed in the paper (Normal, Small Lateral, Slalom, and
Large Lateral).

`1.csv` carries 118 columns; `2.csv` and `3.csv` carry three additional
smoothed reference channels (`VE_smooth`, `VN_smooth`, `VU_smooth`).

## 2. Reference and measurement systems

| System | Content | Purpose |
|---|---|---|
| GJ-VSMS2000 integrated navigation (FOG + RTK-GNSS) | `Latitude_Fusion`, `Longitude_Fusion`, `ins_VE`, `ins_VN`, `ins_Heading_fusion`, … | Velocity reference, used for slip-angle construction during fine-tuning and for evaluation |
| ASM 330 MEMS IMU | `IMU_ACC_g_*` (g), `IMU_Gyro_degps_*` (deg/s) | Network input |
| Four wheel-speed sensors | `FL/FR/RL/RRwheelspeed` | Network input, longitudinal speed |
| Steering-angle sensor | `SteeringAngle`, `SteeringAngleABS`, `Steer` | Network input |
| Body-frame velocities | `Vx_body`, `Vy_body`, `Vz_body` | Lateral-velocity target |

## 3. Columns used by the estimator

| Column | Unit | Description |
|---|---|---|
| `IMU_ACC_g_x/y/z` | g | Tri-axial acceleration |
| `IMU_Gyro_degps_x/y/z` | deg/s | Tri-axial angular rate |
| `FLwheelspeed`, `FRwheelspeed`, `RLwheelspeed`, `RRwheelspeed` | m/s | Wheel speeds |
| `SteeringAngle` | deg | Steering-wheel angle (δ_sw) |
| `Time` | s | Common time base |
| `Vx_body`, `Vy_body` | m/s | Longitudinal / lateral body velocity |
| `ins_VE`, `ins_VN` | m/s | Reference east / north velocity |

The full 118/121-column header is preserved exactly as logged by the data
acquisition system; unused channels are left untouched for traceability.

## 4. Loading

```python
import pandas as pd

df = pd.read_csv("data/3.csv")
t  = df["Time"].to_numpy()                 # seconds, 10 ms grid
ax = df["IMU_ACC_g_x"].to_numpy()          # g
ay = df["IMU_ACC_g_y"].to_numpy()
r  = df["IMU_Gyro_degps_z"].to_numpy()     # deg/s
vy = df["Vy_body"].to_numpy()              # m/s
```

## 5. License

Released under the **Creative Commons Attribution 4.0 International
(CC BY 4.0)** license — see `LICENSE`. You may share and adapt the data for any
purpose, provided appropriate credit is given.

## 6. Citation

If you use this dataset, please cite the archived release:

```bibtex
@dataset{liu2026lateral,
  author    = {Liu, Shuxiang and Gao, Letian and Mei, Jiarui and
               Huang, Zihao and Xia, Xin and Xiong, Lu},
  title     = {Real-Vehicle Lateral-Velocity Dataset for
               ``Vehicle Lateral Velocity Estimation System Embedding
               Time-Varying Cornering Stiffness Learning Considering
               Sim-to-Real Gap''},
  year      = {2026},
  publisher = {Zenodo},
  doi       = {10.5281/zenodo.24440814},
  url       = {https://doi.org/10.5281/zenodo.24440814}
}
```

## 7. Contact

Letian Gao (corresponding author) — gao_letian@tongji.edu.cn
College of Automotive and Energy Engineering, Tongji University, Shanghai, China.

