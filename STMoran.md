---
title: Local Spatial-temporal Moran's I with mask
categories:
- GIS, code
tags:
- autocorrelation
- spatial temporal
- code
date: 2019-05-13
mathjax: true
---

Translated from IDL program: `ENVI_BATCH_TIMESERIES_PSTI.PRO`

# Formula
The $STI$ at location $i$ between time $t$ and $t'$ can be calculated by:
$$ STI_{t,t'}^{i} = \frac{
  n\left( x_t^i - \overline{x_t} \right) \sum_{j=1}^n w_{ij}^* \left( x_{t'}^j - \overline{x_{t'}} \right) }{ \sqrt{\sum_{i=1}^n \left( x_t^i - \overline{x_t} \right)^2} \sqrt{\sum_{j=1}^n \left( x_{t'}^j - \overline{x_{t'}} \right)^2}  } $$

where $\overline{x_t}, \overline{x_{t'}}$ are overall mean values of $x$ at time $t$ and $t'$.
