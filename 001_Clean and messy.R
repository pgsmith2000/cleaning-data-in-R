
# load and prep sample tables
weather <- read.csv("./data/weather.csv", header=TRUE, sep=",", as.is=TRUE)
weather_clean <- read.csv("./data/weather_clean.csv", header=TRUE, sep=",")
weather_clean[3:23] <- lapply(weather_clean[3:23], as.numeric)
weather_clean$events <- as.character(weather_clean$event)
weather_clean$date <- as.POSIXct(weather_clean$date, tz="", format("%m/%d/%Y"))

# first look at a messy data set
# look at the first 6 rows
head(weather)
# look at the last 6 rows
tail(weather)  
# look at a summary of the data
str(weather)


# now look at a clean data set
# look at the first 6 rows
head(weather_clean)
# look at the last 6 rows
tail(weather_clean)  
# look at a summary of the data
str(weather_clean)

