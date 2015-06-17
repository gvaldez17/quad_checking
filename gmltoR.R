#tell R to fetch the rgdal package to get tools to open the shape file, can also use lib in place of req
require(rgdal)
#this is the filename
filename <- "data/Adair/Adair.gml"
#list layers associated with file
layername <- ogrListLayers("data/Adair/Adair.gml")
#assign shapefile/gml to a variable called adair using readOGR. dsn is location 
adair <- readOGR(dsn= "data/Adair/Adair.gml", layer= layername[1])
#make a function that converts gml into R and can return a data frame
checkgml <- function(x){
  #function taking in a file name, opeing it up as a spatial points data.frame,
  #running tests, making a plot and outputting the tests as a data.frame
  layername <- ogrListLayers(x)
  
  map_name <- substr(x, 
                     max(gregexpr('/', x, fixed=TRUE)[[1]]) + 1, 
                     max(gregexpr('.', x, fixed=TRUE)[[1]]) - 1)
  
  map <- readOGR(dsn= x, layer= layername[1])
  tests <- data.frame(lgdist = map@data$dist1 > 500 & map@data$dist2 > 500 &
                                      map@data$dist3 > 500 & map@data$dist4 > 500,
                      nodist = map@data$dist1==0 & map@data$dist2 > 0,
                      az = map@data$az1 > 90, diam.test = is.na(map@data$diam1) & !is.na(map@data$diam2),
                      val = is.na(map@data$species1) & !is.na(map@data$species2),
                      twin = map@data$diam1 == map@data$diam2,
                      smdiam = map@data$diam1 < 1 & map@data$diam2 < 1 & map@data$diam3 < 1 & map@data$diam4 < 1,
                      lgdiam = map@data$diam1 > 60 & map@data$diam2 > 60 &
                                     map@data$diam3 > 60 & map@data$diam4 > 60,
                      nodiam = (map@data$diam1==0 | is.na(map@data$diam1)) & map@data$diam2 > 0,
                      noaz = map@data$az1==0 & map@data$az2 >0
                      )
 #opening and closing the plotting device
  png(file= paste0("figures/", map_name, ".png"))
  plot(map, col = 'red', pch=19, cex = 0.5, main = map_name)
  trash <- dev.off()
  
  list("x","y", lgdist, nodist, az, diam.test, val, twin, small, lgdiam, nodiam, noaz)
} 

allfiles <- list.files('data/', recursive = TRUE, full.names = TRUE, pattern = 'gml')
map_tests <- (lapply(allfiles,checkgml))
              
map_tests
#making a vector of values for the first file
rowSums(map_tests[[1]])
#apply the rowSums function to the map_tests list, giving a vector of values for each file
lapply(map_tests,rowSums)

??coordinates

