# 2D-Music Localization Algorithm

## Function Descriptions

### main_simulation.m
Main function for 2D music localization, handling data loading, preprocessing, and estimation.

**Input**: None

**Output**: None

### path_delays.m
Calculates the delays for direct and reflected paths between the transmitter and receiver.

**Input**:
- `params` (defined in `params.m`)

**Output**:
- `delays` [params.N_signals, 1]
- `path_losses` []

### target_orientations.m
Calculates the angles from the transmitter to the receiver and each target.

**Input**:
- `params` (defined in `params.m`)

**Output**:
- `angles` [1 + params.N_targets, 1]

### receive_data_simulation.m
Simulates the received signal data based on given delays and angles for each path.

**Input**:
- `params` (defined in `params.m`)
- `delays` [params.N_signals, 1]
- `angles` [1 + params.N_targets, 1]

**Output**:
- `received_data` [params.N_subcarriers, params.N_Tx, params.packet_length]

### pdd_remove.m
Removes phase distortion due to propagation delay differences (PDD) from the raw channel state information (CSI).

**Input**:
- `params` (defined in `params.m`)
- `raw_csi` [params.N_subcarriers, params.N_Tx, params.packet_length]

**Output**:
- `corrected_csi` [params.N_subcarriers, params.N_Tx, params.packet_length]

### estimate_aoa_music.m
Estimates the angle of arrival (AOA) of signals using the MUSIC algorithm.

**Input**:
- `received_data` [params.N_subcarriers, params.N_Tx]
- `params` (defined in `params.m`)

**Output**:
- `P_peaks_idx` [params.N_signals, 1]
- `phi_e` [params.N_signals, 1]

### estimate_tof_music.m
Estimates the time of flight (TOF) of signals using the MUSIC algorithm.

**Input**:
- `received_data` [params.N_subcarriers, params.packet_length]
- `params` (defined in `params.m`)

**Output**:
- `delta_delays` [params.N_signals - 1, 1]

### music_2d.m
Performs 2D MUSIC algorithm to estimate the angle of arrival (AOA) and time of flight (TOF) of signals, generating a spectral density map and identifying peaks.

**Input**:
- `received_data` [params.N_subcarriers * params.N_Tx, params.packet_length]
- `params` (defined in `params.m`)

**Output**:
- None (results are visualized through plots and printed to console)
