# 2D‑MUSIC

2D‑MUSIC for joint time‑of‑flight and angle‑of‑arrival estimation on simulated radar‑like data.

## What is inside

- **Core algorithm**: `music_2d.m`
- **Estimation helpers**: `estimate_aoa_music.m`, `estimate_tof_music.m`
- **Simulation**: `main_simulation.m`, `receive_data_simulation.m`, `path_delays.m`, `target_orientations.m`
- **Experiment data**: `radar_200.mat`, `radar_2002.mat`, `radar_200_permuted.mat`, `receiver_200.mat`
- **Config**: `parameters.m`

Autosave files with the `.asv` suffix are not needed to run examples. They will be ignored once a `.gitignore` is added.

## Quick start

1. Clone or download the repository.
2. Open MATLAB and set the repo folder as the current directory.
3. Open `parameters.m` and adjust array size, carrier, bandwidth, and SNR if needed.
4. Run the top‑level script:

```matlab
main_simulation
```

This script will:

- Generate or load data from the `.mat` files
- Call the 2D‑MUSIC routine
- Plot the pseudospectrum and report the dominant peak as the joint estimate

## Typical workflow

You can run the estimation directly if you already have baseband snapshots.

```matlab
% X  — snapshots matrix (sensors × snapshots)
% f  — frequency grid or sample rate info
% c  — propagation speed (for ToF)
% d  — sensor spacing (for AoA)
[P, tau_grid, theta_grid] = music_2d(X, f, c, d);
[theta_hat] = estimate_aoa_music(P, theta_grid);
[tau_hat]   = estimate_tof_music(P, tau_grid);
```

The exact arguments match the function headers in the repo.

## Reproducible example

A small example uses the included `radar_200.mat` data set. You can reproduce the figure from the paper notes with:

```matlab
load radar_200.mat
[P, tau, theta] = music_2d(X, fs, c, d);
imagesc(theta, tau, 10*log10(P)); axis xy
xlabel('Angle (deg)'); ylabel('Delay (s)'); title('2D-MUSIC pseudospectrum')
```

## File layout suggestion

To keep things tidy on a lab website you can adopt this structure in the repo:

```
2D-MUSIC/
├─ src/                % all .m source files
├─ data/               % .mat data files
├─ examples/           % minimal runnable demos
├─ figures/            % generated plots saved by scripts
├─ README.md
├─ LICENSE
└─ .gitignore
```

Move code into `src/`, move the `.mat` files into `data/`, and add one short script under `examples/` that loads `data/radar_200.mat` and produces a plot.

## .gitignore for MATLAB

Create a `.gitignore` file with the lines below.

```
# MATLAB
*.asv
*.m~
*.mat
*.mlx
*.fig
.DS_Store
```

Keep data in `data/` and add a `data/.gitkeep` if you plan to host large files elsewhere.

## Citing

If this code helps your work please cite it. A simple BibTeX entry:

```bibtex
@misc{2d_music_mli,
  title        = {2D-MUSIC: MATLAB reference implementation},
  author       = {Li, M.},
  year         = {2025},
  howpublished = {GitHub repository},
  note         = {https://github.com/mli55/2D-MUSIC}
}
```

## Contact

Open an issue or email the maintainer if you have questions or find bugs.
