#Libraries


############### Creating Function for map above
TXCountyMap <- function (countyname){
  
  #Selecting one county
  county <- TXgeocre %>% 
    filter(ctname == countyname)
  
  #Creating map for County
  pal <- brewer.pal(5, "YlOrBr")
  mapplot <- tm_shape(county) +
    tm_fill(col = "predrt_3", style = "quantile",palette = pal, title = "% people with 3+ risk factors") +
    tm_borders(col = "Grey", lwd = 1) +
    tm_layout(main.title =str_c(county$ctname, " People with 3+ Risk Factors Rate"),
              legend.position = c("right","bottom")
    )
  mapplot #output mapplot 
}




############################# Plotting in Series
#Creating for loop for all the counties 
TXcounties <- unique(TXgeocre$ctname)

savemap <- function (name, folder){
  jpeg(filename = str_c(folder,"/",name,".jpeg"))
  print(TXCountyMap(name))
  dev.off()
}


# Running In Series
ptm <- proc.time()

lapply(TXcounties, savemap, folder = "Map_Example/MapOutput/Series_Maps/")

series <- proc.time() - ptm
print(c("Series",series))

############################## Plotting in Parallel

library(parallel)
detectCores()

ptm <- proc.time()
cl <- makeCluster(3) #Include setting up into time

clusterExport(cl,c("TXCountyMap",'TXgeocre')) #Exporting data and function TXCountyMap
clusterEvalQ(cl, {
  #Libraries
  library(tidyverse)
  library(tmap)
  library(tigris)
  library(sf)
  library(RColorBrewer)})



parLapply(cl,TXcounties, savemap, folder = "Map_Example/MapOutput/Parallel_Maps/")


parallel <- proc.time() - ptm
print(c("Parallel",parallel))
stopCluster(cl)

print(c("Saved",series - parallel)) # Saves time on my pc 26 seconds
