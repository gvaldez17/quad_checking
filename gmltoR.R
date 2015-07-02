#tell R to fetch the rgdal package to get tools to open the shape file, can also use lib in place of req
require(rgdal)
#make a function that converts gml into R and can return a data frame
checkgml <- function(x){
  #function taking in a file name, opeing it up as a spatial points data.frame,
  #running tests, making a plot and outputting the tests as a data.frame
  cat(x)
  layername <- ogrListLayers(x)
  
  map_name <- substr(x, 
                     max(gregexpr('/', x, fixed=TRUE)[[1]]) + 1, 
                     max(gregexpr('.', x, fixed=TRUE)[[1]]) - 1)
  
  map <- try(readOGR(dsn= x, layer= layername[1]))
  
  if(class(map)=='try-error'){
    return(list(geo=data.frame(map_name=NA, coords.x1 = NA, coords.x2=NA),
                tests = data.frame(lgdist = NA,
                                    nodist = NA,
                                    az = NA,
                                    val = NA,
                                    twin = NA,
                                    smdiam = NA,
                                    lgdiam = NA,
                                    nodiam = NA,
                                    noaz = NA,
                                    matchlgdist = NA,
                                    ddtwin = NA,
                                    noname = NA )))
  }
  
  ###############################################################################
  #  This is to flip the distances and diameters.  They were entered incorrectly.
  #  This should only happen once, we're flagging 'flipped' shapefiles with a new
  #  column called 'flipped', so if the dataset is missing the column then we accept
  #  it and move on, otherwise we flip:
  
  if(!'flipped' %in% names(map)){
    flip_dist <- map@data[ , regexpr('^diam[1-4]$', names(map))>0]
    flip_diam <- map@data[ , regexpr('^dist[1-4]$', names(map))>0]
    
    map@data[ ,regexpr('^dist[1-4]$', names(map))>0] <- flip_dist
    map@data[ ,regexpr('^diam[1-4]$', names(map))>0] <- flip_diam
    map@data$flipped <- TRUE
    writeOGR(obj = map, dsn= x, layer= layername[1], overwrite=TRUE, driver = 'GML')
  }
  
  #making a dataframe which includes the map name and x and y coordinates
  geo <- data.frame(map_name,coordinates(map))
  #making a dataframe which includes column names for each test
  tests <- data.frame(lgdist = map@data$dist1 > 500 | map@data$dist2 > 500 |
                                      map@data$dist3 > 500 | map@data$dist4 > 500,
                      nodist = map@data$dist1==0 & map@data$dist2 > 0,
                      az = map@data$az1 > 90, 
                      val = is.na(map@data$species1) & !is.na(map@data$species2),
                      twin = map@data$diam1 == map@data$diam2,
                      smdiam = map@data$diam1 < 1 & map@data$diam2 < 1 & 
                                     map@data$diam3 < 1 & map@data$diam4 < 1,
                      lgdiam = map@data$diam1 > 60 & map@data$diam2 > 60 &
                                     map@data$diam3 > 60 & map@data$diam4 > 60,
                      nodiam = (map@data$diam1==0 | is.na(map@data$diam1)) & map@data$diam2 > 0,
                      noaz = map@data$az1==0 & map@data$az2 >0,
                      matchlgdist = map@data$dist1 > 75 | map@data$dist2 > 75,
                      ddtwin = map@data$dist1 == map@data$dist2 & 
                                    map@data$diam1 == map@data$diam2,
                      noname =  is.na(map@data$species1) & (!is.na(map@data$dist1) | !is.na(map@data$diam1)) | is.na(map@data$species2) & 
                                    (!is.na(map@data$dist2) | !is.na(map@data$diam2)))
  keep <- rowSums(is.na(tests)) == 0
 #opening and closing the plotting device
  png(file= paste0("figures/", map_name, ".png"))
  plot(map, col = 'red', pch=19, cex = 0.5, main = map_name)
  trash <- dev.off()
  #list that includes the data frames geo and tests
  
 list(geo = geo[keep,],tests = tests[keep,])
 
} 
#assigns a path to a variable, allfiles
allfiles <- list.files('\\\\discovery\\Williams\\students\\Former_Students\\BenS\\DigitizingMI\\quadPts', recursive = TRUE, full.names = TRUE, pattern = 'gml')
#takes allfiles and runs check gml on each file, 
#then assigns it to a variable called map_tests
map_tests <- (lapply(allfiles,checkgml))

#map_tests runs the entire function over all of the files              
#map_tests
#making a vector of values for the first file
#rowSums(map_tests[[1]])
#apply the rowSums function to the map_tests list, get a vector of values for each file
#lapply(map_tests,rowSums)

#assign the data.frame function to a variable
primarydata_frame<- lapply(map_tests,function(x){
  data.frame(x$geo,flags = rowSums(x$tests),x$tests)
})
#plotting a data frame for all of the individual data sets together
big_frame <- na.omit(do.call(rbind.data.frame, primarydata_frame))

coordinates(big_frame) <- ~coords.x1 + coords.x2

writeOGR(big_frame, 
         dsn='C:\\Users\\willlab\\Documents\\GitHub\\quad_checking\\data_check.shp', 
         'data_check',
         driver = 'ESRI Shapefile', overwrite= TRUE)

#plot the data from big_frame and use the x1 coord as x axis and x2coord as y axis
plot(big_frame$coords.x1, big_frame$coords.x2, col=big_frame$flags)
#flags of zero or NA not included
plot(coords.x2 ~ coords.x1, data = big_frame[big_frame$flags>0,], col = flags, pch=19, cex=0.5)
#write a new .csv file for excel to keep track of the flags
write.csv(big_frame@data,'check_files_v2.csv')
