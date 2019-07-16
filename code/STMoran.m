function [PSTI] = STMoran(im1, mask1, im2, mask2, lags, lagt)
%% STMORAN Partial Space-time Moran's I
% Translated from IDL program: |ENVI_BATCH_TIMESERIES_PSTI.PRO|
% 
% The $\mathrm{STI}$ at location $i$ between time $t$ and $t^{'}$ can be 
% calculated by:
% 
% $$STI_{t,t'}^{i} = \frac{  n\left( x_t^i - \overline{x_t} \right) \sum_{j=1}^n 
% w_{ij}^* \left( x_{t'}^j - \overline{x_{t'}} \right) }{ \sqrt{\sum_{i=1}^n \left( 
% x_t^i - \overline{x_t} \right)^2} \sqrt{\sum_{j=1}^n \left( x_{t'}^j - \overline{x_{t'}} 
% \right)^2}  }$$

%% Inputs
% - im1: 1st image.
% - mask1: `binary image` | mask for 1st image.
% - im2: 2nd image.
% - mask2: `binary image` | mask for 2nd image.
% - lags: `int` | spatial lag.
% - lagt: `int` | temporal lag.

%% Outputs
% 2D STI matrix, the same size as `im2`.

%% Update
% [May 27, 2019] Change output result to PSTI; Add waitbar.
% [May 29, 2019] Improved performance.

%% Code
[x,y] = size(im1);   % get dimension of image.
im1(mask1 == 0)= NaN;  % set masked values to NaN.
% im1(im1 == 0) = NaN;
im2(mask2 == 0)= NaN;  % set masked values to NaN.
% im2(im2 == 0) = NaN;
PSTI = nan(x,y);
newim1 = nan(x+2*lags,y+2*lags);
newim2 = nan(x+2*lags,y+2*lags);
newim1(lags+1:x + lags, lags+1:y+lags) = im1;
newim2(lags+1:x + lags, lags+1:y+lags) = im2;

% Overall Stats for image 1 and 2.
mean1 = nanmean(im1(:));
std1 = nanstd(im1(:));
mean2 = nanmean(im2(:));
std2 = nanstd(im2(:));
% Calculate STI and PSTI
% numForePixels2 = nansum(mask2);
temp1 = (newim1 - mean1) / std1;
% wb = waitbar(0, 'Starting...');
% set(wb,'Name','ST Moran');
CSTV = (newim2 - mean2) ./ std2;
for m = 1:x
    for n = 1:y
        left = m - lags;
        right = m + lags;
        upper = n - lags;
        lower = n + lags;
        weightMat = ones(2*lags+1,2*lags+1);
        weightMat(lags+1,lags+1) = 0;
        temp2 = zeros(2*lags+1,2*lags+1);
        if ~isnan(newim2(m,n)) % Centroid not empty.
            rawMat = newim2(left:right,upper:lower);
            if nansum(rawMat(:)) ~= 0   % Neighbour not empty.
                % Normalize weight
                if nansum(weightMat) ~= 0
                    weightMat = weightMat / nansum(weightMat(:));
                end
                % Pixel at t1 and neighbourhood at t2
                
                temp2 = weightMat .* CSTV(left:right, upper:lower);
                % temp3 = nansum(temp2(:));
            end
            PSTI(m,n) = lagt * temp1(m,n) * nansum(temp2(:));
        end
        % Waitbar update
        
    end
    % disp(strcat('lines _', num2str(m), '_ of _', num2str(x),'_, Percentage: _',num2str(100*m/x),'%.'))
    % waitbar(m/x,wb,strcat(num2str(100*m/x),'%.'));
end
% delete(wb);

% STI = nansum(PSTI ./ numForePixels2);
end