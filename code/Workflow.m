%% Spatio - Temporal Stability Index Workflow
% This script is a workflow for caculating spatio-temporal stability index.
% Dynamic time warping is used to measure the distance between time series
% of each pixel. First we caculate the mean distance between a pixel and its
% neighbours(sliding windows) with DTW. Then we caculate the spatial
% autocorrelation of the distances.

% results(|*.csv| format) include:
% * Mean value of block Moran's I.
% * Standard deviation of block Moran's I.
% * Maximum of block Moran's I.
% * Minimum of block MOran's I.
%
% Calling functions:
% * |Moran.m|, global moran's I with mask.
% * |Blocking.m|, caculate stats for moran's I.
%
% Author: Delick Tang(China University of Geosciences, Beijing)
% Version: 1.1 Added timer and csv output. (13/Jul/2018)


%% Inputs and Outputs (I/O)
% Read mask files and NDRE images, and pre-allocate space for results.

% Choose mask file.
[File, Path]=uigetfile({'*.tif'},'Choose mask file.','Multiselect','off','/home/delick/文档/SpatialChange/NDRE2');
[mask, R0] = geotiffread(strcat(Path, File));
[x,y] = size(mask);

% Choose Imagery.
[file, path] = uigetfile({'*.tif'}, 'Choose imagery.', 'Multiselect', 'on', '/home/delick/文档/SpatialChange/NDRE2');
[a, b] = size(file);
IM = zeros(x,y);
dates= zeros(b);

% Output results.

tic     % Timer start.
for n = 1:b
    [IM(:,:,n), R] = geotiffread(strcat(path, char(file(n))));
    char(file(n))
    image = IM(:,:,n);
    time = toc
end

%% Interpolation of time seires.



% Output results.

totaltime = toc     % Timer end. Total running time.