function [moran] = Moran(im, mask)
%Caculate weight matrix for both Moran's I and Geary's C.
%   You can apply a mask to you image by specifing a mask matrix. If you
%   don't need a mask, plesas specify a ones matrix with the same dimension
%   of im.
%   * im and mask must share the same dimension.
%
% Author: Delick Tang (China University of Geosciences, Beijing)
% Version: 1.2 Major bug fix.(13/Jul/2018)

[x,y] = size(im);   % get dimension of image.
im(mask == 0)= NaN;  % set masked values to NaN.
temp = im(:);
avg = nanmean(temp);   % mean value (NaN values excluded).
variance = var(temp,'omitnan');  % variance.
num = 0;    % store numerator.
den = 0;    % store denominator.
totalW = 0;

% for each point in im (without border)
for a = 2:x-1
    for b = 2:y-1
        % within the 3 * 3 window
        for m = 1:3
            for n = 1:3
                xi = a+m-2;
                yi = b+n-2;
                if xi < x && xi > 0
                    if yi < y && yi > 0
                        i = 3*(n-1) + m;
                        wt = zeros(9,9);
                        if mask(xi,yi) ~= 0
                            for m1 = 1:3
                                for n1 = 1:3
                                    xj = a+m-2;
                                    yj = b+n-2;
                                    j = 3*(n1-1) + m1;
                                    if m1 == 2
                                        if n1 == 2
                                            wt(i,j) = 0;
                                        end
                                    end
                                    if mask(xj,yj) ==1
                                        wt(i,j) = 1;
                                        % Caculate numerator and denominator.
                                        num = num + wt(i,j) * (im(xi,yi)- avg) * (im(xj,yj) - avg);
                                        totalW = totalW + wt(i,j);
                                    end
                                    if mask(xj,yj) ~=1
                                        wt(i,j) = 0;
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        % This is the end of neighbouring window.
    end
end
den = totalW * variance;
moran = num / (den * totalW);
end