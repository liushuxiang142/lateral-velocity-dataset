# CarSim Simulation Dataset for Vehicle Lateral-Velocity Estimation

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.24440813.svg)](https://doi.org/10.5281/zenodo.24440813)
[![License: CC BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)

**Concept DOI (always resolves to the latest version):** [10.5281/zenodo.24440813](https://doi.org/10.5281/zenodo.24440813)
**Version DOI (this release, v2.0.0):** [10.5281/zenodo.24456059](https://doi.org/10.5281/zenodo.24456059)

Simulation data accompanying the manuscript

> **Vehicle Lateral Velocity Estimation System Embedding Time-Varying Cornering Stiffness Learning Considering Sim-to-Real Gap**

Shuxiang Liu, Letian Gao, Jiarui Mei, Zihao Huang, Xin Xia, and Lu Xiong

---

## 1. What is in this repository

Nine CarSim runs exported from the high-fidelity vehicle-dynamics model used to
build the pre-training dataset of the manuscript. Each run is a continuous log
sampled at **100 Hz** with **580 channels**.

| Archive | Runs | Raw size | Download |
|---|---|---|---|
| `data/carsim_sim_runs_121-123.zip` | 121, 122, 123 | 212 MB | 81 MB |
| `data/carsim_sim_runs_124-126.zip` | 124, 125, 126 | 221 MB | 82 MB |
| `data/carsim_sim_runs_127-129.zip` | 127, 128, 129 | 236 MB | 88 MB |

Each zip contains the original CSV files, byte-for-byte as exported by CarSim.
Unzip into one folder before use.

| Run | Rows | Duration | Road friction μ |
|---|---|---|---|
| 121 | 10 501 | 105 s | 0.50 |
| 122 | 9 501 | 95 s | 0.50 |
| 123 | 9 501 | 95 s | 0.50 |
| 124 | 9 501 | 95 s | 0.50 |
| 125 | 9 501 | 95 s | 0.50 |
| 126 | 11 001 | 110 s | 0.70 |
| 127 | 10 001 | 100 s | 0.70 |
| 128 | 11 001 | 110 s | 0.70 |
| 129 | 11 001 | 110 s | 0.70 |

All runs start from rest and cover straight running, transient steering
reversals and sustained near-limit cornering, i.e. the linear region as well as
nonlinear tire saturation.

## 2. Units

The export keeps CarSim's default display units, so the columns are **not**
uniformly SI:

| Quantity | Unit |
|---|---|
| `Vx`, `Vy`, `Vz` | km/h |
| `Ax`, `Ay`, `Az` | g |
| `Yaw`, `Roll`, `Pitch` | deg/s (rates) |
| `Steer_SW`, `Alpha_*`, `Camber*`, `Beta` | deg |
| `Fy_*`, `Fx_*`, `Fz_*` | N |
| `Mx_*`, `My_*`, `Mz_*` | N·m |
| `Station`, `Xcg_TM`, `X_*`, `Y_*`, `Z_*` | m |
| `Kappa_*` | – (slip ratio) |

Column names are unchanged from the CarSim export; `_L1`, `_L2`, `_R1`, `_R2`
denote the front-left, rear-left, front-right and rear-right wheels.

## 3. Channels used by the estimator

| Column | Unit | Description |
|---|---|---|
| `Time` | s | Time base, 10 ms grid |
| `Vx`, `Vy` | km/h | Longitudinal / lateral velocity of the body |
| `Yaw` | deg/s | Yaw rate |
| `Ax`, `Ay` | g | Longitudinal / lateral acceleration |
| `Steer_SW` | deg | Steering-wheel angle |
| `Fy_L1`, `Fy_L2`, `Fy_R1`, `Fy_R2` | N | Wheel lateral forces |
| `Alpha_L1`, `Alpha_L2`, `Alpha_R1`, `Alpha_R2` | deg | Wheel slip angles |
| `Fz_L1`, `Fz_L2`, `Fz_R1`, `Fz_R2` | N | Wheel vertical loads |
| `MuX_*`, `MuY_*` | – | Tire–road friction coefficients |

## 4. Loading

```python
import zipfile, pandas as pd

with zipfile.ZipFile("data/carsim_sim_runs_121-123.zip") as z:
    z.extractall("sim")                     # -> sim/121.csv, sim/122.csv, sim/123.csv

df = pd.read_csv("sim/121.csv")
t  = df["Time"].to_numpy()                  # s
vx = df["Vx"].to_numpy() / 3.6              # km/h -> m/s
vy = df["Vy"].to_numpy() / 3.6
r  = df["Yaw"].to_numpy()                   # deg/s
```

## 5. License

Released under the **Creative Commons Attribution 4.0 International
(CC BY 4.0)** license — see `LICENSE`. You may share and adapt the data for any
purpose, provided appropriate credit is given.

## 6. Citation

```bibtex
@dataset{liu2026carsim,
  author    = {Liu, Shuxiang and Gao, Letian and Mei, Jiarui and
               Huang, Zihao and Xia, Xin and Xiong, Lu},
  title     = {CarSim Simulation Dataset for ``Vehicle Lateral Velocity
               Estimation System Embedding Time-Varying Cornering Stiffness
               Learning Considering Sim-to-Real Gap''},
  year      = {2026},
  publisher = {Zenodo},
  doi       = {10.5281/zenodo.24440813},
  url       = {https://doi.org/10.5281/zenodo.24440813}
}
```

## 7. Contact

Letian Gao (corresponding author) — gao_letian@tongji.edu.cn
College of Automotive and Energy Engineering, Tongji University, Shanghai, China.

