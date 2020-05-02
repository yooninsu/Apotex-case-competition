library(tidyverse)
library(dplyr)
library(data.table)
library(tidyr)


bid_data<-read.csv("C:/Users/yis82/Desktop/insu/document/Case competition/Apotex case package/Apotex case package/Data Sets/Bid Data1.csv")
forecast<-read.csv("C:/Users/yis82/Desktop/insu/document/Case competition/Apotex case package/Apotex case package/Data Sets/Forecast1.csv")
bid_data1<-na.omit(bid_data)
forecast1<-na.omit(forecast)
merged_data <- left_join(bid_data1,forecast, by=c("Product.Family"="ProductFamily"))
data<-na.omit(merged_data)
z<-split(bid_data1, bid_data1$Product.Family)
x<-simplify2array(lapply(z,`[`,,"Monthly..units"))
d
for (i in 1:length(x)){
   assign(paste0("Product.Family",i),unlist(x[i]))
  }

