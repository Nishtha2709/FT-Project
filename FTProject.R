library(quantmod)
library(tseries)
library(timeseries)
library(forecast)
library(xts)
install.packages("timeSeries")

getSymbols('SPY',from='24-01-01',to='2019-09-09')
class(SPY)