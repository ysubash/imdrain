# Reading IMD gridded rainfall in R

The IMD gridded rainfall can be freely downloaded from http://www.imdpune.gov.in/Clim_Pred_LRF_New/Grided_Data_Download.html

The script is to convert imd .grd gridded rainfall of resolution 0.25 degrees to NetCDF (.nc) format and extract the rainfall for region of interest.

There are 3 steps.

(i) Creation of control File (.ctl) for each rain file (.grd)
(ii) Convert .grd to .nc file using CDO
(iii) Extract the rainfall for region of interest (roi) and dump to .csv

