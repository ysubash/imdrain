###################################################################
## This script is to read IMD gridded NetCDF rainfall data
## 0.25 degree resolution, extract for the region of interest (roi)
## and dump the output to a csv
####################################################################
remove(list = ls())
library(ncdf4)
library(pracma)
library(rgdal)
library(raster)

crs.LongLat = CRS("+init=epsg:4326")

dir.data <- "/home/user/path/to/nc/files"
dir.out <- "/home/user/path/to/output"

files <- list.files(dir.data,pattern = "*.nc",full.names = TRUE,recursive = TRUE)


precip.list <- list()
dt.list <- list()
count = 1

for (ii in 1:length(files)){      
  
  tryCatch(
    {
      # Reading the netcdf file
      nc_data <- nc_open(files[ii])
      
      v <- nc_data$var[[1]]
      size <- v$size
      dims <- v$ndims
      vname <- v$name
      
      # Get the dimensions and variable data
      lon <- ncvar_get(nc_data, "lon")
      lat <- ncvar_get(nc_data, "lat")
      time <- ncvar_get(nc_data, "time")
      dt_origin <- nc_data$dim[[3]]$units
      iyear <- substr(basename(files[ii]),4,7)
      dt_start <- as.Date(paste0(iyear,'-01-01'))
      dt_end <- as.Date(paste0(iyear,'-12-31'))
      dt <- seq.Date(from = dt_start,to = dt_end, by = 'days')
      # dt <- strftime(dt,"%d-%m-%Y")
      dt.list[[ii]] <- dt
      
      
      precip <- ncvar_get(nc_data, "rf")
      fillvalue <- v$missval
    
      nc_close(nc_data)
      
      for (jj in 1:size[3]){
        
        
        precip.day <- precip[, , jj] 
        
        r <- raster(t(precip.day), xmn=min(lon)-0.125, xmx=max(lon)+0.125, ymn=min(lat)-0.125, ymx=max(lat)+0.125, crs=crs.LongLat)
        r1 <- flip(r, direction='y')
        
        # Extraction code for your Region of Interest(roi)
        xx <- seq(73,83,0.25)
        yy <- seq(20,28,0.25)

        xy.grid <- meshgrid(xx, yy)
        xy.grid <- cbind(c(xy.grid$X),c(xy.grid$Y))
        precip.roi <- extract(r1, xy.grid,cellnumbers = T,df=T)

        
        if (ii == 1){
          
          coords <- xyFromCell(r1,precip.roi$cell)
          
        }
        
        precip.list[[count]] <- precip.roi$layer
        
        count = count + jj
        
      }
  
      
      },error = function(e){
        print(ii)
        message("error message:")
        message(e)})


  
}



precip.mat <- do.call(rbind,precip.list)
out <- rbind(t(coords),precip.mat)
dt.all <-  do.call("c", dt.list)
dt.all.new <- c(NA,NA,dt.all)

precip.out <- data.frame(dt.all.new,out)

ofileName <- "output_pnt25_degree_daily_rain.csv"
write.table(precip.out,file.path(dir.out,ofileName),sep=",",row.names = FALSE,col.names = FALSE)

ofileName <- "output_dates.csv"
write.table(dt.all,file.path(dir.out,ofileName),sep=",",row.names = FALSE,col.names = FALSE)





