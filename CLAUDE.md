# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Academic research data repository for China's road and rail transportation networks (1994–2024), supporting Ma and Tang (2024, *Journal of International Economics*). Contains pixel-level infrastructure data, prefecture-to-prefecture travel times, and MATLAB scripts for computing shortest-path travel times via Dijkstra's algorithm.

## Running the Code

All MATLAB scripts are in `sample_codes/`. Run from that directory.

**Full travel-time computation:**
```matlab
% In MATLAB, from sample_codes/
run main.m
```
Configure `main.m` before running: `year_list`, `mode_list`, `input_fname`, `ncores` (each core uses ~5–6 GB RAM), `empty_speed` (default 10 km/h).

**Analysis scripts (no pixel data needed, use pref_pair/ CSVs):**
```matlab
run table_travel_time_diff.m   % LaTeX tables + CSV of travel time differences
run plot_travel_time_trend.m   % Trend visualization PNG
```

**Path configuration:** Edit `sample_codes/codes/define_path.m` to set `pixel_data_path` (points to `../pixel_info/`) and `base_map_path`.

## Architecture

### Data Tiers

1. **Prefecture-level** (`pref_pair/`): 279×279 symmetric travel-time matrices (lower triangle, 38,781 pairs) for road, rail_pass, rail_good. Columns: `origin`, `destination`, `year_YYYY` (hours).

2. **Pixel-level** (`pixel_info/`): Files named `pixel_info_MODE_YEAR.csv`. Each row is a pixel with infrastructure. Key columns: `seg_id`, `pos_x`/`pos_y` (in 12,669×8,829 raster), `index` (= `sub2ind([8829 12669], pos_y, pos_x)`), `speed` (km/h), `time` (hours), `usage_type`, `terrain`.

3. **Segment-level** (`seg_info/`): Named road/rail segments with construction year, rate, design code, and pixel mappings.

### Computation Pipeline (main.m)

```
sample_input.csv → loc_1.m (coords → raster positions)
    → func_friction_map.m (load pixel speeds, build cost matrix)
    → compute_city_city_dijkstra_allow_duplicate.m (multi-source Dijkstra on 8-neighbor graph)
    → output/t_mat_INPUT_MODE_YEAR.csv (travel times in hours)
```

### Key Constants (`define_map_dimension.m`)

- Raster: 12,669 × 8,829 pixels (Albers projection)
- Pixel distance: 0.5097 km
- Time formula: `time = 60 × distance / speed` (minutes)

## Conventions

- **Modes:** `'road'`, `'rail_pass'`, `'rail_good'`
- **Years:** integer 1994–2024
- **Travel time units:** hours in output files, minutes internally in friction maps
- **Raster indexing:** MATLAB-style `sub2ind([8829, 12669], pos_y, pos_x)` — note y-dimension first
- **File naming:** `pixel_info_MODE_YEAR.csv`, `time_cost_prefecture_pair_MODE.csv`, `t_mat_INPUT_MODE_YEAR.csv`
- **Support functions** live in `sample_codes/codes/`; added to path via `addpath('codes')` in scripts

## Algorithm Note

The algorithm was migrated from Fast Marching Method (FMM) to Dijkstra's shortest-path on an 8-neighbor raster graph. Motivation: FMM exhibited excessive sensitivity to local structural perturbations, reducing year-over-year comparability. Dijkstra provides global optimality and stable cross-year results. See `changelog/changelog.md` for details.

## MATLAB Dependencies

- Parallel Computing Toolbox (multi-core via `maxNumCompThreads`)
- Statistics and Machine Learning Toolbox (`prctile`)
- Graph and Network Algorithms (`graph`, `distances`)
