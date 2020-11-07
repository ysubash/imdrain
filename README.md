# Reading IMD gridded rainfall in R

The IMD gridded rainfall can be freely downloaded from http://www.imdpune.gov.in/Clim_Pred_LRF_New/Grided_Data_Download.html

The script is to convert imd .grd gridded rainfall of resolution 0.25 degrees to NetCDF (.nc) format and extract the rainfall for region of interest.

There are 3 steps.

- (i) Creation of control File (.ctl) for each rain file (.grd)
- (ii) Convert .grd to .nc file using CDO tool. 
- (iii) Extract the rainfall for region of interest (roi) and dump to .csv

###### Windows users having difficulty in using Climate Data Operator (CDO) command line tool (https://github.com/ysubash/imdrain/edit/main/README.md) from R
###### can run the conversion from .grd to .nc from Cygwin using the following lines from the terminal 

```
$ for FILE in *.ctl; do OUTPUTFILE=$(echo "$FILE" | awk '{gsub(".ctl",".nc"); print}'); echo $OUTPUTFILE ; cdo -f nc import_binary $FILE $OUTPUTFILE; done
```
 
