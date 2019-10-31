# load and prep sample table
weather <- read.csv("./data/weather.csv", header=TRUE, sep=",", as.is=TRUE)

# Understanding the structure of the data
# look at the class
class(weather)

# look at the dimentions (size)
dim(weather)

# look at the structure
str(weather)