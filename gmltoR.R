#tell R to fetch the rgdal package to get tools to open the shape file, can also use lib in place of req
require(rgdal)
#this is the filename
filename <- "data/Adair/Adair.gml"
#list layers associated with file
layername <- ogrListLayers("data/Adair/Adair.gml")
#assign shapefile/gml to a variable called adair using readOGR. dsn is location 
adair <- readOGR(dsn= "data/Adair/Adair.gml", layer= layername[1])
