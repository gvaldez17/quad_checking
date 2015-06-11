#two tests 1) is azimuth 1 over 90degrees 2) diameter 1 and diameter 2
data.frame(az.test = adair@data$az1 > 90, diam.test = is.na(adair@data$diam1) & !is.na(adair@data$diam2))
#this test doent work because they are not numerical?
data.frame(val.test = adair@data$species1 > 0 & adair@data$species2 > 0)
#test to see if tree one has no value (0) while tree two has a value
data.frame(val.test = adair@data$dist1==0 & adair@data$dist2 > 0)
