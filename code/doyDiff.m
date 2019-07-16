function [days] = doyDiff(date1,date2)
%Calculates the days between doy1 and doy2
%   DOY should be in 'YYYYDDD' format (string). e.g. 1999067

% Get year info.
year1 = fix(date1 ./ 1000);
year2 = fix(date2 ./ 1000);

% Get doy info
doy1 = mod(date1, 1000);
doy2 = mod(date2, 1000);

% Calcuate difference.
days = (year2 - year1) .* 365 + doy2 - doy1;
days = int16(days);

end

