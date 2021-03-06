kDat <- read.delim(file.path("data", "gapminderWithColorsAndSorted.txt"), as.is = 7) # protect colour
library(lattice)
str(kDat)
jYear <- c(1952, 2007)
yDat <- subset(kDat, year %in% jYear)
str(yDat)

# start with simple scatterplot of gdp (log scale) vs year by continent
xyplot(lifeExp ~ gdpPercap | factor(year), yDat, aspect = 2/3,
       grid = TRUE, scales = list(x = list(log = 10, equispaced.log = FALSE)))
# now add the panel function, no change seen
#xyplot(lifeExp ~ gdpPercap | factor(year), yDat, aspect = 2/3,
#       grid = TRUE, scales = list(x = list(log = 10, equispaced.log = FALSE),
#       panel = function(...) {
#        panel.xyplot(...)
#       }))

# again no change, adding x,y into the panel function
#xyplot(lifeExp ~ gdpPercap | factor(year), yDat, aspect = 2/3,
#       grid = TRUE, scales = list(x = list(log = 10, equispaced.log = FALSE),
#       panel = function(x, y, ...) {
#        panel.xyplot(x, y, ...)
#       }))

# getting more advanced: sizing each coutry by relative to its population
jCexDivisor <- 1500  # arbitrary scaling constant
jPch <- 21
xyplot(lifeExp ~ gdpPercap | factor(year), yDat, aspect = 2/3,
       grid = TRUE, scales = list(x = list(log = 10, equispaced.log = FALSE)),
       cex = sqrt(yDat$pop/pi)/jCexDivisor, 
       panel = function(x, y, ..., cex, subscripts) {
         panel.xyplot(x, y, cex = cex[subscripts], pch = jPch, ...)
       })

# getting beautiful: assigning each country a colour
jDarkGray <- 'grey20'
xyplot(lifeExp ~ gdpPercap | factor(year), yDat, aspect = 2/3,
       grid = TRUE, scales = list(x = list(log = 10, equispaced.log = FALSE)),
       cex = sqrt(yDat$pop/pi)/jCexDivisor, fill.color = yDat$color,
       col = jDarkGray,
       panel = function(x, y, ..., cex, fill.color, subscripts) {
         panel.xyplot(x, y, cex = cex[subscripts],
                      pch = jPch, fill = fill.color[subscripts], ...)
       })

# adding a legend (key)
continentColors <- read.delim(file.path("data", "gapminderContinentColors.txt"), as.is = 3) # protect colour
continentKey <-
  with(continentColors,
       list(x = 0.95, y = 0.05, corner = c(1, 0),
            text = list(as.character(continent)),
            points = list(pch = jPch, col = jDarkGray, fill = color)))
xyplot(lifeExp ~ gdpPercap | factor(year), yDat, aspect = 2/3,
       grid = TRUE, scales = list(x = list(log = 10, equispaced.log = FALSE)),
       cex = sqrt(yDat$pop/pi)/jCexDivisor, fill.color = yDat$color,
       col = jDarkGray, key = continentKey,
       panel = function(x, y, ..., cex, fill.color, subscripts) {
         panel.xyplot(x, y, cex = cex[subscripts],
                      pch = jPch, fill = fill.color[subscripts], ...)
       },
       layout = c(1, 2))