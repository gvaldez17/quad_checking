#two tests 1) is azimuth 1 over 90degrees 2) diameter 1 and diameter 2
data.frame(az.test = adair@data$az1 > 90, diam.test = is.na(adair@data$diam1) & !is.na(adair@data$diam2))
#this test doent work because they are not numerical?
data.frame(val.test = adair@data$species1 > 0 & adair@data$species2 > 0)
#test to see if tree one has no value (0) while tree two has a value
data.frame(dist.test = adair@data$dist1==0 & adair@data$dist2 > 0)
#test to see if two trees have same data..how to write: do any two trees have the same data all across the board?
data.frame(twin.test = adair@data$diam1 == adair@data$diam2)
#test to see if a tree hass too small of a diameter (what would too small be?). is 1 okay to use?
data.frame(small.test = adair@data$diam1 < 1 & adair@data$diam2 < 1 & adair@data$diam3 < 1 & adair@data$diam4 < 1)
# test to see if distance recorded is >500
data.frame(lgdist.test = map@data$dist1 > 500 & map@data$dist2 > 500 & map@data$dist3 > 500 & map@data$dist4 > 500)
