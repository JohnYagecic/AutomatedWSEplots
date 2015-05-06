# Plotting of NOAA PORTS data and tidal thresholds

# Both original Excel VBA and new R scripts developed by John Yagecic, P.E.
#  JYagecic@gmail.com


setwd("~/PORTSgraphs")
PORTS<-read.csv("PORTSstations.csv")

myToday<-as.character(format(Sys.Date(), "%m/%d/%Y"))

for (jjj in 1:nrow(PORTS)){
  
  for (qqq in 1:2){ # Loop for Predicted vs. Observed water surface elevations 1=predicted, 2=observed
    if (qqq==1){
      Product="predictions"
    }
    if (qqq==2){
      Product="water_level"
    }
    
    myfilename=paste0(PORTS$StationName[jjj], Product, "_RAW.csv")
    mydf<-read.csv(myfilename)
    mydf$Date.Time<-strptime(mydf$Date.Time, format("%Y-%m-%d %H:%M"))
  
    if (qqq==2){
      mydf<-mydf[,1:2]
    }
    
    names(mydf)<-c("LocTime","MLLW")
    mydf$numdat<-as.numeric(mydf$LocTime)
    
    if (qqq==1){
      Preds<-mydf
    }
    if (qqq==2){
      Obs<-mydf
    }
    
  }
  
  plotname<-paste0(PORTS$StationName[jjj], ".png")
  plottitle<-paste0("Water Surface Elevations NOAA PORTS ", PORTS$StationName[jjj], "\nData Retrieved ",
                    myToday)
  png(file=plotname)
    plot(Preds$LocTime, Preds$MLLW, type="l", col="blue", ylim=c(-1.2, 3.9),
         xlab="Date & Time (local time zone)",
         ylab="WSE Meters (MLLW)", main=plottitle)
    points(Obs$LocTime, Obs$MLLW, type="l", col="red")
    abline(h=PORTS$Minor[jjj], col="purple4", lwd=1)
    abline(h=PORTS$Moderate[jjj], col="purple4", lwd=2)
    abline(h=PORTS$Major[jjj], col="purple4", lwd=3)
    abline(h=PORTS$Nav[jjj], lty=3, lwd=1)
    abline(h=PORTS$BWT[jjj], lty=3, lwd=3)
    legend("topleft", c("Predicted", "Observed"), col=c("blue", "red"), lty=c(1,1))
    legend("topright", c("Major Flooding", "Moderate Flooding", "Minor Flooding"),
           col=c("purple4", "purple4", "purple4"), lwd=c(3,2,1))
    legend("bottomright", c("Federal Navigation Basis", "Blow Out Tide"), lty=c(3,3), lwd=c(1,3))
  dev.off()

}


