function [moran_global] = GlobalMoran(image, mask)
%% GLOBALMORAN Global Moran's I
% calculate global moran's I with mask.
% 
% Formula: 
% 
% $$I = \frac{\sum_i\sum_j(y_i – \overline{y})(y_j – \overline{y})}{s^2\sum_i\sum_j 
% w_{ij}}$$
% 
% where $s^2 = \frac{\sum (y_i - \overline{y})^2}{n}$, $\overline{y} = \sum^{n}_{i=1} 
% \frac{y_i}{n}$
    [x,y] = size(image);
    image(mask~=1)=NaN;
    x_avg = nanmean(image(:));
    sum_cij = 0;
    s2 = nanstd(image(:))^2;
    count = 0;
    for xi = 1:x
        for yi = 1:y
            if ~isnan(image(xi,yi)) % if current pixel is not empty
                left = xi -1;
                right = xi +1;
                upper = yi -1;
                lower = yi +1;
                if left <= 1
                    left = 1;
                end
                if right >= x
                    right = x;
                end
                if upper <= 1
                    upper = 1;
                end
                if lower >= y
                    lower = y;
                end
                for xj = left:right
                    for yj = upper:lower
                        if ~isnan(image(xj,yj)) % Exclude NaN values in neighbourhood.
                            if (xj==xi && yj == yi) % Exclude centroid.
                            else
                                sum_cij = sum_cij + (image(xi,yi)-x_avg) * (image(xj,yj)-x_avg);
                                count = count + 1;
                            end
                        end
                    end
                end
            end
        end
    end
    moran_global = sum_cij / (count * s2);
end