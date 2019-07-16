---
title: Global Moran's I with mask file
categories:
- GIS
- code
tags:
- spatial autocorrelation
- code
date: 2019-05-09
mathjax: true
---
# Math formula
Given a weighted matrix, with units $i$ and $j$, a global Moran's I can be calculated. Moran's I measures the similarities between units, which is the product of the differences between $y_i$ and $y_j$ with the overall mean.

- Similarity:
$$s^2 = \frac{\sum (y_i - \overline{y})^2}{n},$$
where $\overline{y} = \sum^{n}_{i=1} \frac{y_i}{n}.$

- The Moran’s I is calculated using the basic form, which is divided by the sample variance:
$$I = \frac{\sum_i\sum_j(y_i – \overline{y})(y_j – \overline{y})}{s^2\sum_i\sum_j w_{ij}}$$

Formula: Aki-Hiro Sato. [Applied Data-Centric Social Sciences: Concepts, Data, Computation and Theory](https://drive.google.com/file/d/0B71AiLdQdpC9NXkyYnMxV25lSzQ/view?usp=sharing). Japan, Springer, 2014. pp. 137-138.

source: [Statistics How To](https://www.statisticshowto.datasciencecentral.com/morans-i/) & [LI Xu's World](https://lixuworld.blogspot.com/2016/03/matlab-global-morans-i.html)

# Explanation
{% blockquote ESRI https://pro.arcgis.com/en/pro-app/tool-reference/spatial-statistics/h-how-spatial-autocorrelation-moran-s-i-spatial-st.htm ArcGIS help %}
The Spatial Autocorrelation (Global Moran's I) tool is an inferential statistic, which means that the results of the analysis are always interpreted within the context of its null hypothesis. For the Global Moran's I statistic, the null hypothesis states that the attribute being analyzed is randomly distributed among the features in your study area; said another way, the spatial processes promoting the observed pattern of values is random chance.
{% endblockquote %}

Moran's I is multi-directional and multi-dimensional, so it is capable of finding spatial (or spatial-temporal) patterns in large datasats. It resembles correlation coefficients, with a range from -1 to 1. The value of Moran's I can be interpreted as:

| Moran's I 	| Explanation        	|                                 	|
|-----------	|--------------------	|---------------------------------	|
| -1        	| perfect dispersion 	| strong negative autocorrelation 	|
| 0         	| perfect randomness 	| no autocorrelation              	|
| +1        	| perfect clustering 	| strong positive autocorrelation 	|

# Results

| Grid 	| Mean            	| Std             	| Max             	| min             	|
|------	|-----------------	|-----------------	|-----------------	|-----------------	|
| $2^2$  	| 0.8775464892387 	| 0.1411349736443 	| 1.0543619394302 	| 0.7437012791634 	|
| $2^4$  	| 0.8163935095072 	| 0.1919355394268 	| 1.0505152940750 	| 0.5168324708939 	|
| $2^6$  	| 0.6860341671854 	| 0.1927662562530 	| 1.0690231323242 	| 0.4576362967491 	|
| $2^8$  	| 0.6373897302056 	| 0.1879458321173 	| 1.0579684972763 	| 0.3981954157352 	|
| $2^{10}$ 	| 0.5884883901    	| 0.1741593748    	| 1.086454153     	| 0.07224321365   	|
| $2^{12}$ 	| 0.5491929527    	| 0.1666835233    	| 1.296874523     	| -0.3333334029   	|
| $2^{14}$ 	| 0.515981241     	| 0.1753342867    	| 1.723862052     	| -1.787027955    	|
| $2^{16}$ 	| 0.461822037     	| 0.1968235223    	| 1.4595263       	| -1.475658655    	|
| $2^{18}$ 	| 0.3472288659    	| 0.2467294149    	| 2.115040541     	| -1.915917993    	|
| $2^{20}$ 	| 0.1688128682    	| 0.2709873377    	| 1.341372013     	| -1.865889907    	|
| $2^{22}$ 	| -0.3107034675   	| 0.0959450011    	| 0.6666665673    	| -0.5000001192   	|

# Code
{% codeblock Global Moran lang:matlab https://github.com/delick/Moran/blob/master/code/GlobalMoran.m %}
function [moran_global] = GlobalMoran(image, mask)
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
{% endcodeblock %}
