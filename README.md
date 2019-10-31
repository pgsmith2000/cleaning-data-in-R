Cleaning Data With R
================
Paul G. Smith
10/31/2019

  - [Cleaning Data With R](#cleaning-data-with-r)
      - [Overview](#overview)
      - [Exploring raw data](#exploring-raw-data)
          - [What messy data looks like](#what-messy-data-looks-like)
          - [What clean data looks like](#what-clean-data-looks-like)
          - [Exploring raw data](#exploring-raw-data-1)
          - [Understanding the structure of the
            data](#understanding-the-structure-of-the-data)
          - [Looking at the data](#looking-at-the-data)
          - [Visualizing the data](#visualizing-the-data)
      - [Tidying data](#tidying-data)
      - [Preparing data for analysis](#preparing-data-for-analysis)

# Cleaning Data With R

## Overview

The purpose of this project is to highlight issues related to cleaning
data, and demonstrating many common strategies and techniques using R
programming to clean and prep the data for analysis.

## Exploring raw data

Essential R commands:

  - class, dim, names, str, glimpse, summary
  - head, tail, print
  - hist, plot
  - gather -\> combines multiple columns into two rows with key and
    value (tidyr)
  - spread -\> moves key value columns to multiple columns with keys as
    column names (tidyr)
  - separate - \> splits a column by \_ or whatever seperator you choose
    to multiple columns (tidyr)
  - unite -\> combines multiple columns to one column with \_ as the
    seperator (tidyr)
  - as.character
  - as.numeric
  - as.integer
  - as.factor
  - as.logical
  - ymd - (lubridate)
  - mdy - (lubridate)
  - hms - (lubridate)
  - ymd\_hms - (lubridate)

### What messy data looks like

  - X column is just the row number
  - days are spread but should be part of the date field and have one
    row per date
  - year and month and day should be one data column
  - measures are melted but should be each in a column
  - and so on…

<!-- end list -->

``` r
# load and prep sample tables
weather <- read.csv("data/weather.csv", header=TRUE, sep=",", as.is=TRUE)

# first look at a messy data set
# look at the first 6 rows
head(weather)
```

    ##   X year month           measure X1 X2 X3 X4 X5 X6 X7 X8 X9 X10 X11 X12
    ## 1 1 2014    12  Max.TemperatureF 64 42 51 43 42 45 38 29 49  48  39  39
    ## 2 2 2014    12 Mean.TemperatureF 52 38 44 37 34 42 30 24 39  43  36  35
    ## 3 3 2014    12  Min.TemperatureF 39 33 37 30 26 38 21 18 29  38  32  31
    ## 4 4 2014    12    Max.Dew.PointF 46 40 49 24 37 45 36 28 49  45  37  28
    ## 5 5 2014    12    MeanDew.PointF 40 27 42 21 25 40 20 16 41  39  31  27
    ## 6 6 2014    12     Min.DewpointF 26 17 24 13 12 36 -3  3 28  37  27  25
    ##   X13 X14 X15 X16 X17 X18 X19 X20 X28 X29 X30 X31
    ## 1  42  45  42  44  49  44  37  36  52  41  30  30
    ## 2  37  39  37  40  45  40  33  32  46  36  26  25
    ## 3  32  33  32  35  41  36  29  27  40  30  22  20
    ## 4  28  29  33  42  46  34  25  30  42  26  10   8
    ## 5  26  27  29  36  41  30  22  24  35  20   4   5
    ## 6  24  25  27  30  32  26  20  20  27  10  -6   1

``` r
# look at the last 6 rows
tail(weather)  
```

    ##       X year month            measure   X1   X2   X3   X4   X5   X6   X7
    ## 281 281 2015    12 Mean.Wind.SpeedMPH    6 <NA> <NA> <NA> <NA> <NA> <NA>
    ## 282 282 2015    12  Max.Gust.SpeedMPH   17 <NA> <NA> <NA> <NA> <NA> <NA>
    ## 283 283 2015    12    PrecipitationIn 0.14 <NA> <NA> <NA> <NA> <NA> <NA>
    ## 284 284 2015    12         CloudCover    7 <NA> <NA> <NA> <NA> <NA> <NA>
    ## 285 285 2015    12             Events Rain <NA> <NA> <NA> <NA> <NA> <NA>
    ## 286 286 2015    12     WindDirDegrees  109 <NA> <NA> <NA> <NA> <NA> <NA>
    ##       X8   X9  X10  X11  X12  X13  X14  X15  X16  X17  X18  X19  X20  X28
    ## 281 <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA>
    ## 282 <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA>
    ## 283 <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA>
    ## 284 <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA>
    ## 285 <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA>
    ## 286 <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA> <NA>
    ##      X29  X30  X31
    ## 281 <NA> <NA> <NA>
    ## 282 <NA> <NA> <NA>
    ## 283 <NA> <NA> <NA>
    ## 284 <NA> <NA> <NA>
    ## 285 <NA> <NA> <NA>
    ## 286 <NA> <NA> <NA>

``` r
# look at a summary of the data
str(weather)
```

    ## 'data.frame':    286 obs. of  28 variables:
    ##  $ X      : int  1 2 3 4 5 6 7 8 9 10 ...
    ##  $ year   : int  2014 2014 2014 2014 2014 2014 2014 2014 2014 2014 ...
    ##  $ month  : int  12 12 12 12 12 12 12 12 12 12 ...
    ##  $ measure: chr  "Max.TemperatureF" "Mean.TemperatureF" "Min.TemperatureF" "Max.Dew.PointF" ...
    ##  $ X1     : chr  "64" "52" "39" "46" ...
    ##  $ X2     : chr  "42" "38" "33" "40" ...
    ##  $ X3     : chr  "51" "44" "37" "49" ...
    ##  $ X4     : chr  "43" "37" "30" "24" ...
    ##  $ X5     : chr  "42" "34" "26" "37" ...
    ##  $ X6     : chr  "45" "42" "38" "45" ...
    ##  $ X7     : chr  "38" "30" "21" "36" ...
    ##  $ X8     : chr  "29" "24" "18" "28" ...
    ##  $ X9     : chr  "49" "39" "29" "49" ...
    ##  $ X10    : chr  "48" "43" "38" "45" ...
    ##  $ X11    : chr  "39" "36" "32" "37" ...
    ##  $ X12    : chr  "39" "35" "31" "28" ...
    ##  $ X13    : chr  "42" "37" "32" "28" ...
    ##  $ X14    : chr  "45" "39" "33" "29" ...
    ##  $ X15    : chr  "42" "37" "32" "33" ...
    ##  $ X16    : chr  "44" "40" "35" "42" ...
    ##  $ X17    : chr  "49" "45" "41" "46" ...
    ##  $ X18    : chr  "44" "40" "36" "34" ...
    ##  $ X19    : chr  "37" "33" "29" "25" ...
    ##  $ X20    : chr  "36" "32" "27" "30" ...
    ##  $ X28    : chr  "52" "46" "40" "42" ...
    ##  $ X29    : chr  "41" "36" "30" "26" ...
    ##  $ X30    : chr  "30" "26" "22" "10" ...
    ##  $ X31    : chr  "30" "25" "20" "8" ...

### What clean data looks like

  - Each row is a daily record of the weather
  - There is a lot cleaned up here
  - We will clean this data set in the last section

<!-- end list -->

``` r
# load and prep sample table
weather_clean <- read.csv("./data/weather_clean.csv", header=TRUE, sep=",")
weather_clean[3:23] <- lapply(weather_clean[3:23], as.numeric)
weather_clean$events <- as.character(weather_clean$event)
weather_clean$date <- as.POSIXct(weather_clean$date, tz="", format("%m/%d/%Y"))

# look at the first 6 rows
head(weather_clean)
```

    ##         date    events cloud_cover max_dew_point_f max_gust_speed_mph
    ## 1 2014-12-01      Rain           6              46                 29
    ## 2 2014-12-02 Rain-Snow           7              40                 29
    ## 3 2014-12-03      Rain           8              49                 38
    ## 4 2014-12-04      None           3              24                 33
    ## 5 2014-12-05      Rain           5              37                 26
    ## 6 2014-12-06      Rain           8              45                 25
    ##   max_humidity max_sea_level_pressure_in max_temperature_f
    ## 1           74                     30.45                64
    ## 2           92                     30.71                42
    ## 3          100                     30.40                51
    ## 4           69                     30.56                43
    ## 5           85                     30.68                42
    ## 6          100                     30.42                45
    ##   max_visibility_miles max_wind_speed_mph mean_humidity
    ## 1                   10                 22            63
    ## 2                   10                 24            72
    ## 3                   10                 29            79
    ## 4                   10                 25            54
    ## 5                   10                 22            66
    ## 6                   10                 22            93
    ##   mean_sea_level_pressure_in mean_temperature_f mean_visibility_miles
    ## 1                      30.13                 52                    10
    ## 2                      30.59                 38                     8
    ## 3                      30.07                 44                     5
    ## 4                      30.33                 37                    10
    ## 5                      30.59                 34                    10
    ## 6                      30.24                 42                     4
    ##   mean_wind_speed_mph mean_dew_point_f min_dew_point_f min_humidity
    ## 1                  13               40              26           52
    ## 2                  15               27              17           51
    ## 3                  12               42              24           57
    ## 4                  12               21              13           39
    ## 5                  10               25              12           47
    ## 6                   8               40              36           85
    ##   min_sea_level_pressure_in min_temperature_f min_visibility_miles
    ## 1                     30.01                39                   10
    ## 2                     30.40                33                    2
    ## 3                     29.87                37                    1
    ## 4                     30.09                30                   10
    ## 5                     30.45                26                    5
    ## 6                     30.16                38                    0
    ##   precipitation_in wind_dir_degrees
    ## 1             0.01              268
    ## 2             0.10               62
    ## 3             0.44              254
    ## 4             0.00              292
    ## 5             0.11               61
    ## 6             1.09              313

``` r
# look at the last 6 rows
tail(weather_clean)  
```

    ##           date events cloud_cover max_dew_point_f max_gust_speed_mph
    ## 361 2015-11-26   None           6              49                 28
    ## 362 2015-11-27   None           7              52                 32
    ## 363 2015-11-28   Rain           8              50                 23
    ## 364 2015-11-29   None           4              33                 20
    ## 365 2015-11-30   None           6              26                 17
    ## 366 2015-12-01   Rain           7              43                 17
    ##     max_humidity max_sea_level_pressure_in max_temperature_f
    ## 361          100                     30.87                59
    ## 362          100                     30.63                64
    ## 363           93                     30.20                60
    ## 364           79                     30.42                44
    ## 365           75                     30.53                38
    ## 366           96                     30.40                45
    ##     max_visibility_miles max_wind_speed_mph mean_humidity
    ## 361                   10                 22            79
    ## 362                   10                 26            78
    ## 363                   10                 18            80
    ## 364                   10                 16            58
    ## 365                   10                 14            65
    ## 366                   10                 15            83
    ##     mean_sea_level_pressure_in mean_temperature_f mean_visibility_miles
    ## 361                      30.77                 49                     9
    ## 362                      30.41                 56                     9
    ## 363                      30.16                 51                     9
    ## 364                      30.26                 38                    10
    ## 365                      30.46                 33                    10
    ## 366                      30.24                 39                     8
    ##     mean_wind_speed_mph mean_dew_point_f min_dew_point_f min_humidity
    ## 361                  10               42              34           57
    ## 362                  14               49              47           56
    ## 363                  10               43              36           67
    ## 364                  10               23              15           36
    ## 365                   9               23              18           54
    ## 366                   6               35              25           69
    ##     min_sea_level_pressure_in min_temperature_f min_visibility_miles
    ## 361                     30.64                38                    5
    ## 362                     30.15                48                    5
    ## 363                     30.11                41                    4
    ## 364                     30.19                32                   10
    ## 365                     30.39                28                   10
    ## 366                     30.01                32                    1
    ##     precipitation_in wind_dir_degrees
    ## 361             0.00              180
    ## 362             0.00              209
    ## 363             0.21              358
    ## 364             0.00              326
    ## 365             0.00               65
    ## 366             0.14              109

``` r
# look at a summary of the data
str(weather_clean)
```

    ## 'data.frame':    366 obs. of  23 variables:
    ##  $ date                      : POSIXct, format: "2014-12-01" "2014-12-02" ...
    ##  $ events                    : chr  "Rain" "Rain-Snow" "Rain" "None" ...
    ##  $ cloud_cover               : num  6 7 8 3 5 8 6 8 8 8 ...
    ##  $ max_dew_point_f           : num  46 40 49 24 37 45 36 28 49 45 ...
    ##  $ max_gust_speed_mph        : num  29 29 38 33 26 25 32 28 52 29 ...
    ##  $ max_humidity              : num  74 92 100 69 85 100 92 92 100 100 ...
    ##  $ max_sea_level_pressure_in : num  30.4 30.7 30.4 30.6 30.7 ...
    ##  $ max_temperature_f         : num  64 42 51 43 42 45 38 29 49 48 ...
    ##  $ max_visibility_miles      : num  10 10 10 10 10 10 10 10 10 10 ...
    ##  $ max_wind_speed_mph        : num  22 24 29 25 22 22 25 21 38 23 ...
    ##  $ mean_humidity             : num  63 72 79 54 66 93 61 70 93 95 ...
    ##  $ mean_sea_level_pressure_in: num  30.1 30.6 30.1 30.3 30.6 ...
    ##  $ mean_temperature_f        : num  52 38 44 37 34 42 30 24 39 43 ...
    ##  $ mean_visibility_miles     : num  10 8 5 10 10 4 10 8 2 3 ...
    ##  $ mean_wind_speed_mph       : num  13 15 12 12 10 8 15 13 20 13 ...
    ##  $ mean_dew_point_f          : num  40 27 42 21 25 40 20 16 41 39 ...
    ##  $ min_dew_point_f           : num  26 17 24 13 12 36 -3 3 28 37 ...
    ##  $ min_humidity              : num  52 51 57 39 47 85 29 47 86 89 ...
    ##  $ min_sea_level_pressure_in : num  30 30.4 29.9 30.1 30.4 ...
    ##  $ min_temperature_f         : num  39 33 37 30 26 38 21 18 29 38 ...
    ##  $ min_visibility_miles      : num  10 2 1 10 5 0 5 2 1 1 ...
    ##  $ precipitation_in          : num  0.01 0.1 0.44 0 0.11 1.09 0.13 0.03 2.9 0.28 ...
    ##  $ wind_dir_degrees          : num  268 62 254 292 61 313 350 354 38 357 ...

### Exploring raw data

### Understanding the structure of the data

### Looking at the data

### Visualizing the data

## Tidying data

## Preparing data for analysis
