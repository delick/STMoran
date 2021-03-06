# Moran
Calculate spatial-temporal Moran's I and search for forest disturbance.

## Dependencies
- `Moran.m` function to calculate Moran's I of a given block.
- `Blocking.m` function to divide an image into equal blocks.
- `natsort.m` & `natsortfiles.m` function to sort filenames with numbers.
*Note: Path of dependencies should be included in MATLAB search folder.*

# Usage
## What scripts to run? In what order?
1. **`STI_LowMemory.mlx`** Calculates the spatial temporal Moran's I. (See code for detailed formula.)
2. **`DistMarker.mlx`** Mark the time and place of disturbance. 1 for disturbance, 0 for no disturbance.
3. **`StartEndMarker2.mlx`** Find the starting and ending date of each disturbance. Output image includes `year` and `month` images.
*Set output variables to `doy` for duration. The default output result can't be used to calculate duration.*
4. **`Duration.mlx`** Calculates the duration (in days) of each disturbance.
5. **`distMaxDuration.mlx`** Max and min stats of forest disturbance duration.

## Input / output params
Detailed documentations are in `*.mlx` scripts. They will guide you what to input and how to interpret results.
