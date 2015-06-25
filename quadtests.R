#two tests 1) is azimuth 1 over 90degrees 2) diameter 1 and diameter 2
data.frame(az.test = map@data$az1 > 90, diam.test = is.na(map@data$diam1) & !is.na(map@data$diam2))
#this test doent work because they are not numerical?
data.frame(val.test = map@data$species1 > 0 & map@data$species2 > 0)
#test to see if tree one has no value (0) while tree two has a value (distance)
data.frame(nodist.test = adair@data$dist1==0 & adair@data$dist2 > 0)
#test to see if two trees have same data(diameters)..how to write: do any two trees have the same data all across the board?
data.frame(twin.test = map@data$diam1 == map@data$diam2 & dist 1 and 2)
#test to see if a tree hass too small of a diameter (what would too small be?). is 1 okay to use?
data.frame(smdiam.test = map@data$diam1 < 1 | map@data$diam2 < 1 | map@data$diam3 < 1 | adair@data$diam4 < 1)
# test to see if distance recorded is >500
data.frame(lgdist.test = map@data$dist1 > 500 | map@data$dist2 > 500 | map@data$dist3 > 500 | map@data$dist4 > 500)
#test to see if diameter is greater than 60 inches OR in between
data.frame(lgdiam.test = map@data$diam1 > 60 | map@data$diam2 > 60 | map@data$diam3 > 60 & map@data$diam4 > 60)
#test to see if tree one has no value (0) while tree two has a value (diameter)
data.frame(nodiam.test = map@data$diam1==0 & map@data$diam2 > 0)
#test to see if ree one has no value (0) while tree two has a value (azimuth)
dat.frame(noaz.test = map@data$az1==0 & map@data$az2 >0)
#test to see if both trees have a distance greater than 75
matchlgdist.test = map@data$dist1 > 75 & map@data$dist2 > 75
#test to see if two trees have theexact same data
ddtwin.test= map@data$dist1 == map@data$dist2 & 
                 map@data$diam1 == map@data$diam2 & 
          