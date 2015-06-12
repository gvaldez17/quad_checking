#tell R to fetch the rgdal package to get tools to open the shape file, can also use lib in place of req
require(rgdal)
#this is the filename
filename <- "data/Adair/Adair.gml"
#list layers associated with file
layername <- ogrListLayers("data/Adair/Adair.gml")
#assign shapefile/gml to a variable called adair using readOGR. dsn is location 
adair <- readOGR(dsn= "data/Adair/Adair.gml", layer= layername[1])
#make a function to convert gml into R and can return a data frame
checkgml <- function(x){
  layername <- ogrListLayers(x)
  
  map_name <- substr(x, 
                     max(gregexpr('/', x, fixed=TRUE)[[1]]) + 1, 
                     max(gregexpr('.', x, fixed=TRUE)[[1]]) - 1)
  
  map <- readOGR(dsn= x, layer= layername[1])
  data.frame(lgdist.test = map@data$diam1 > 500 & map@data$diam2 > 500 
             & map@data$diam3 > 500 & map@data$diam4 > 500)
  data.frame(

  )
  png(file= paste0("figures/", map_name, ".png"))
  plot(map, col = 'red', pch=19, cex = 0.5, main = map_name)
  trash <- dev.off()
}
apply(map,checkgml)
??FUN

