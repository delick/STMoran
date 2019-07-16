function [moranStat] = Blocking(image, mask, n)
%Divide image to n blocks and caculate stats for Moran's I.
%   image - raw image.
%   mask - mask file. 0 for unwanted values.
%   n - the number of blocks.

%% Dealing with size and values
[x,y] = size(image);
block = sqrt(n);   % num of blocks per row / column

m = int64(x / block);	% section width
n = int64(y / sqrt(n));	% section height
block = round(block);

% store moran.
moran = zeros(block,block);

%% for each block
% we need to scan each block to delete some 'bad' pixels.
for a = 1:(block)   % num of block horizontally
    for b = 1:(block)   % num of block vertically 
        % Coordinate of 4 boundaries.
        left = (a-1) * m + 1;
        right = a * m;
        upper = (b-1) * n + 1;
        lower = b * n;
        
        % In case index exceeds matrix dimension
        if (right > x)
            right = x;
        end
        if (lower > y)
            lower = y;
        end
        
        rasterWindow = image(left:right, upper:lower);
        maskWindow = mask(left:right, upper:lower);
        moran(a,b) = Moran(rasterWindow, maskWindow);
    end
end

statWind = moran(:);
avgM = nanmean(statWind);    % mean value.
stdM = nanstd(statWind);  % standard deviation.
maxM = nanmax(statWind);   % maximum value.
minM = nanmin(statWind);   % minimum value.

moranStat = [avgM,stdM,maxM,minM];

end
