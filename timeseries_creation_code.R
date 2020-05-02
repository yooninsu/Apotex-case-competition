read.csv("sample_data.csv")
sampledata <- sample_data
agg = aggregate(sampledata['Forecast'],sampledata[1:4], FUN = sum)
agg_sorted = agg %>% arrange(agg$year, agg$month)
sample_ts <- ts(agg_sorted$Forecast, frequency = 12, start = c(2017,1))
## timeseries object is created