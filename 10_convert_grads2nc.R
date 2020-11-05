## Installation of CDO https://www.isimip.org/protocol/preparing-simulation-files/cdo-help/
## Thanks to Paul Hiemstra for the code to convert binary to netCDF
grads2nc = function(ctl_input, nc_output, verbose = TRUE) {  
# https://www.r-bloggers.com/2012/01/converting-grads-files-to-netcdf-from-within-r-using-cdo/
  if(Sys.which("cdo")[[1]] == "") stop("cdo executable not found. Check PATH or install cdo.") 
  if(verbose) ext = "" else ext = "> /dev/null"
  cmd = sprintf("cdo -f nc import_binary %s %s %s", ctl_input, nc_output, ext)
  t = system.time(ret_code <- system(cmd))
  if(verbose & (ret_code != 127)) {
    message(print("Conversion of grads file to nc success"))
    message(sprintf("Processing \"%s\" to \"%s\" is done, time spent:", ctl_input, nc_output))
    print(t)
  } else {
    stop("Conversion of grads file to nc failed")
  }
  return(invisible(ret_code))
}

library(lubridate)


dir.out <- "/home/user/path/to/netcdf"

yr.start <- 1990
yr.end <- 2019

for (iyear in yr.start:yr.end){
  
  file.ctl <- file.path(dir.out,'rf.ctl')
  tx  <- readLines(file.ctl)
  tx2  <- gsub("1990",iyear,x = tx)
  if (lubridate::leap_year(iyear)){
    
  tx2  <- gsub(365,366,x = tx2)
  }
  
  ofileName <- file.path(dir.out,paste0("rf_",iyear,".ctl"))
  writeLines(tx2, con=ofileName)

  grads2nc(ofileName, file.path(dir.out,paste0("rf_",iyear,".nc")))
}



