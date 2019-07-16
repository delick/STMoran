# Moran
Calculate Moran stats in each subblock of an image.



## Dependencies
- `Moran.m` function to calculate Moran's I of a given block.
- `Blocking.m` function to divide an image into equal blocks.
*Note: Script `woorkflow.m` will use these 2 functions, so it's better to keep them in the exact same folder.*

# Usage
## How to run
run `Workflow.m` in Matlab &copy.
## Input params
- mask: `GeoTiff` | Mask image where 0 is masked and 1 is used for calculation. Default: `FinelRice0915.tif`
- raw images: `GeoTiff` | Input at least 2 images. Single images may throw an error. Default: `NDRE.tif`
*Note: mask and raw images should share the exact same spatial reference. Otherwise, Matlab won't output result and errors may occur.*
## Output params
Stats of Moran's I. From left to right, they are:


|	1st image | | | | | 	2nd image|
|	-- | -- | -- | -- | -- | -- |
| # of division | mean | std | max | min	|		…………………………		|
