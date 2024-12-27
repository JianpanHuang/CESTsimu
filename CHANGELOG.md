## To be developed

- spin lock (extent tab): setting flip angle and tip Mz by vector rotation
- inter-pulse spoil (extent tab): reset Mxy inside the solver
- simulation using MT lineshape (e.g., super-Lorentzian)

## CESTsimu v0.71 (20241227)

### Bug Fixes

- Correct the typo of "Quick setting" of the 2D phantom experiment setting window

### Updates

- Save "zspecBatch_m0" variable to the output .MAT file.
  - PS: When generating **1D Z-spectra data**, CESTsimu stores the Z-value at the M0 offset along with other frequency offsets in the “zspecHoldonCell” variable. When **generating 2D phantom data**, CESTsimu stores the (ROI-averaged) Z-value at the M0 offset in a separate “zspecBatch_m0” variable.

## CESTsimu v0.7 (20241111)

### Bug Fixes

- Fixed an issue where, after adding noise or recalculating in a 2D phantom, the red line in the Z-spectrum plot and the corresponding map were reset, but the `FreqoffsppmSlider` value remained unchanged.
- Fixed a bug where enabling "Reset init. mag." prevented proper generation of the 2D map, with an error indicating an unrecognized variable `magn_P_recTemp`.
- Addressed a bug that prevented proper reading of pulsed-RF trains from PulseqCEST.
- Corrected the definition of Recovery Time (Trec): Previously, the GUI-defined Recovery Time was erroneously treated as Time of Repetition (TR), which includes both `Tsat` and `Trec`.

### New Features

- Added custom sampling points for shaped RF pulses in the saturation section, with a default value set to 200:
  - Save and load functionality.
  - Enable/disable functionality.
  - Interpolation applied when values are modified via the GUI (`ShapedRFsamplesEditFieldValueChanged`).
- Implemented B0/B1 map import functionality:
  - Imports specific variables (named as "B0map" or "B1map") from `.mat` files.
  - Applies polynomial smoothing and interpolation, then assigns the results to the GUI.
- Added the ability to customize parameters for individual phantoms in a 2D phantom via a pop-up window, saving settings as "app.phantomExpSetting":
  - Before computation, checks whether `app.phantomExpSetting` is empty and prompts the user to set parameters if needed.
  - Ensures pools are validated during group iteration using `PoolsCheck`, removing invalid pools.
- Introduced a "Load Experiment" function to read from `.mat` or `.xlsx` files saved by CESTsimu.
- Functionality to adjust the shaped pulse paramters in the GUI and in a pop-up window.

### Updates

- Removed dependencies on external toolboxes:
  - **Statistics and Machine Learning Toolbox**: Replaced `normrnd(0, sigma^2, N)` with `sigma * randn(N)`.
  - **Signal Processing Toolbox**: Replaced `sinc(x)` with a custom implementation: `my_sinc = @(x) (x == 0) + (x ~= 0) .* (sin(pi * x) ./ (pi * x))`.
  - **Parallel Computing Toolbox**: Replaced `sprintfc` with `string`.
- Changed B0 input to direct numerical input via "B0EditField" instead of a dropdown menu ("B0DropDown").
- Renamed tabs in the 2D phantom display:
  - Replaced "CEST" with "Z-value".
  - Replaced "MTR" with "MTRasym".
- Updated data import to use variable search instead of line-by-line parsing for enhanced backward compatibility.
  - Developed a new function `assignValueToUI` to handle GUI assignments. It searches for variables in input files and assigns values, using defaults if not found.
- Adjusted B1 max calculation to maintain constant B1rms when pulse parameters change.
- Enhanced pulse waveform imports via the "Other" option:
  - Automatically detects if the waveform corresponds to CW, sinc, etc., and switches the selection accordingly.
- Changed the unit for exchange pool concentration to Molar (M):
  - Adjusted YAML file imports from PulseqCEST accordingly.
  - Converted concentrations to relative values in pools via `poolsRead`.
- Aligned the display order of exchange pools in the GUI with the order used in the `bmesolver`.
- Added noise simulation for 1D Z-spectrum.

### Notes

- Gaussian Noise Application:

  - To generate noise X∼N(0,σ^2), where σ is the standard deviation defined in the GUI, use `σ*randn(N)`. This is equivalent to `normrnd(0, σ^2, N)`.

- SNR-Based Gaussian Noise:

  - Gaussian noise is typically defined by its standard deviation or variance. An alternative is to use functions like `awgn` to specify the SNR and compute the noise variance indirectly.
  - SNR-to-variance conversion assumes sufficient samples for signal power estimation and is suitable for 2D images (averaging over ROI) but not for individual samples.

  $$
  \sigma^2=P_{noise}=P_{signal}/10^{\frac{SNR}{19}}\\
  where\quad P_{signal}=var(signal)
  $$


## CESTsimu v0.6 (20240909)

### Updated

- Solver Enhancements:

  - **Offset Frequency (offs_hz) Precision**: Offset frequency values (`offs_hz`) are now saved to `.seq` files with six significant figures. The solver calculates `offs_hz` from `offs_ppm` and keeps six digits of precision.
  - **Frequency Offset (t_delay) Setting**:star:: The solver now sets `offs = 0` when the B1 amplitude is zero.
  - **dB0 Assignment**: `dB0` is applied to pools instead of directly to offsets.

### Added

- **RF Accumulate Phase**:

  - Added in `addRFAccumPhase()` function, adjusting RF phases in `pulse_cell` within the `bmesolver` loop on each offset.
  - Phase parameters:
    - **Accumulated RF Phase (Correction)**: Uses a checkbox to enable accumulated RF phase correction, approximated to six significant figures (consistent with Pulseq-CEST).
    - **Simulated Scanner Accumulated Phase**: Simulates theoretical accumulated phase without precision loss.
  - **UI Integration**: `phase_cycle` from the UI or SATPARA file is used, and the checkbox defaults to enabled when loading SEQ files, saved to the SATPARA file.

- **Gaussian Noise Control**: Gaussian noise toggle now uses a checkbox for easier control.

- **Trec Functionality**:

  - Modified all functions calling `bmesolver`: `zspecBatchCalculatefromExpUI_pair`、`zmap_1pool_1offs`、`bmesimulate` to incorporate Trec:

    - Adjusted `zspecBatchCalculatefromExpUI_pair` to accommodate Trec in loop processing.
    - Updated `zmap_1pool_1offs` to include relaxation magnetization vectors between TR intervals.
    - Optimized B0map and B1map computation within `Calculation`.

  - Solver Modifications:

    - Bypasses rotation matrix processing when `pulsecell` is empty and adds `cs_mat` directly to `t_post`.
    - `ss_mat` is now computed with a fixed formula `magn_final=[zeros(pool_num*2,1); fract(:)] / fract(1)` to avoid linking to `magn0`.
  
  - **Checkbox Control**: Added checkbox to toggle Trec (disabling Trec dims the option, and TR delay is ignored in this state).
  
  - Ensures `Trec` remains greater than `Tsat`.
  
- **Stop Button**: Added a stop button to interrupt ongoing processes.

- **Custom Legend for Hold-on Plots**:

  - Added a dialog box to input custom text for each plot when "Hold on" is enabled.
  - The legend adjusts dynamically based on the number of plotted curves.



## CESTsimu v0.5 (20240424)

### Added

- **B0/B1 Inhomogeneity Map Calculation**: Added functionality to calculate B0 and B1 inhomogeneity maps.

### Changed

- **Phantom Calculation**: Phantom computations now only execute when the "Calculate" button is clicked, and results are stored in global variables (`phantom_CEST`, `phantom_MTR`).
- **Frequency Offset Adjustments**: Updating either the frequency offset slider or input box now calls global variables and refreshes plots.

### Removed

- Automatic Plotting: Removed automatic plotting functionality triggered by:

  - Changing mask size.
- Modifying group number.