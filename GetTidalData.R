# Obtain NOAA PORTS data for plotting
# Both original Excel VBA and new R scripts developed by John Yagecic, P.E.
#  JYagecic@gmail.com


setwd("~/PORTSgraphs")
PORTS<-read.csv("PORTSstations.csv")

# Below are components of NOAA PORTS API search string
# see http://co-ops.nos.noaa.gov/api/

url1<-"http://tidesandcurrents.noaa.gov/api/datagetter?begin_date="
url2<-"&end_date="
url3<-"&station="
url4<-"&product="
url5<-"&interval=h&datum=MLLW&units=metric&time_zone=lst_ldt&application=DRBC&format=csv"
# Time zone for data is GMT

for (yyy in 1:nrow(PORTS)){ # Loop for locations
 
  EndDate=format(Sys.Date()+10, "%Y%m%d") # Establishing search date range based on 
  NowDate=format(Sys.Date(), "%Y%m%d")    #  code execution date.
  BeginDate=format(Sys.Date()-5, "%Y%m%d")
 
 
  print(BeginDate)
  print(NowDate)
  print(EndDate)
  
 for (jjj in 1:2){ # Loop for Predicted vs. Observed water surface elevations 1=predicted, 2=observed
  if (jjj==1){
    Product="predictions"
  }
  if (jjj==2){
    Product="water_level"
  }
  fileURL<-paste0(url1, BeginDate, url2, EndDate, url3, PORTS$PORTSID[yyy], url4, Product, url5)
  myfilename=paste0(PORTS$StationName[yyy], Product, "_RAW.csv")
  download.file(fileURL, destfile=myfilename)
  
 }
  
}


