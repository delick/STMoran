% Choose mask file.
[FileNameGet,PathNameGet]=uigetfile({'*.tif'},'Choose mask file','MultiSelect','off','E:\postgraduate\曲线相似度\result\S2_rice.tif');
[mask, R0] = geotiffread(strcat(PathNameGet,FileNameGet));
[x,y] = size(mask);

% Choose EVI minus file.
[FileName,PathName]=uigetfile({'*.tif'},'Choose EVI minus file','MultiSelect','on','E:\postgraduate\曲线相似度\result\S2_rice.tif');
[a,b] = size(FileName);
IM = zeros(x,y,b);
IM = double(IM);
for i = 1:b
    [IM(:,:,i),R] = geotiffread(strcat(PathName,char(FileName(i))));
end

% Minus images
% Store values
im = zeros(x,y,b-1);
for i = 1:b-1
    im(:,:,i) = IM(:,:,i+1) - IM(:,:,i);
end

% Store values
moran = zeros(x,y);
coordRefSysCode = 32649; % set coordinate reference system code, 326 for 'WGS84 / UTM northern hemisphere', '49' for UTM zone number.

% Weight matrix using moving window style(3 * 3)
for i = 1:b-1
    for m = 2:x-1
        for n = 2:y-1
            window = zeros(3,3);
            count = 1;
            if mask(m,n) ~= 0
                window(2,2) = im(m,n,i);
                count = count +1;
                if mask(m-1,n-1) ~= 0
                    window(count) = 1;
                    count = count +1;
                end
                if mask(m-1,n) ~= 0
                    window(1,2) = 1;
                    count = count +1;
                end
                if mask(m-1,n+1) ~= 0
                    window(1,3) = 1;
                    count = count +1;
                end
                if mask(m,n-1) ~= 0
                    window(2,1) = 1;
                    count = count +1;
                end
                if mask(m,n+1) ~= 0
                    window(2,3) = 1;
                    count = count +1;
                end
                if mask(m+1,n-1) ~= 0
                    window(3,1) = 1;
                    count = count +1;
                end
                if mask(m+1,n) ~= 0
                    window(3,2) = 1;
                    count = count +1;
                end
                if mask(m+1,n+1) ~= 0
                    window(3,3) = 1;
                end
            end
            window = window ./count;
            moran(m,n) = get_moran(im(m-1:m+1,n-1:n+1,i),window);
        end
    end
    Filenames = char(FileName(i));
    Filenames = Filenames(1:end-4);
    geotiffwrite(strcat(PathName,'\Moran\',Filenames,'_moran.tif'), moran, R,'CoordRefSysCode', coordRefSysCode);
end