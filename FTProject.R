library(tseries)
library(timeSeries)
library(forecast)
library(xts)
install.packages("timeSeries")

#Installing quantmod for getSymbols
install.packages('quantmod')
library(quantmod)



getSymbols('SPY',from='2014-01-02',to='2019-09-09')
class(SPY) #class is xts/zoo
#Want the days close price for each trading day 
SPY_Close_Prices = SPY[,4]

#plot the data
par(mfrow=c(1,1)) #to make the plot 
plot(SPY_Close_Prices)
class(SPY_Close_Prices) #class is xts/zoo

#Plot the data and get initial, auto arima pdq values
#To Plot two graphs
par(mfrow=c(1,2))

#spy_close_prices is the data source
#Title is given by main
Acf(SPY_Close_Prices,main = 'ACF For Differenced Series')
Pacf(SPY_Close_Prices,main = 'PACF For Differenced Series')


auto.arima(SPY_Close_Prices,seasonal=FALSE)#pdq  = 3,1,3
#from plots of ACF and PACF above we get 1,1,1 for pdq


#video 2
#log residuals to remove non stationary properties:
#compute the log returns for the stock - makes data more stable
logs = diff(log(SPY_Close_Prices),lag=1)
logs = logs[!is.na(logs)]#ignoring missing value

#Plot log returns for more accurate forecasting - eliminates non-stationary properties
par(mfrow=c(1,1))
plot(logs,type='l',main='log return plot')

#ADF test for p-value
print(adf.test(logs)) #p-value<0.01
#if p-value is small means we have removes most of the non-stationary values

auto.arima(logs,seasonal=FALSE) #AIC/BIC Values should be small,if negative then good
str(logs) #is xts object

#Split the dataset in two parts - 80/20 training and testing
sample_size = floor(0.80 * nrow(logs))
set.seed(109) #random seed number that when reused makes this reproducible
train_indices <- sample(seq_len(nrow(logs)),size=sample_size)

train <- logs[train_indices,]#train indices (80%)
test <- logs[-train_indices, ]#other than train indices(20%)

par(mfrow=c(1,2))
Acf(train, main = 'Acf For Differenced Series')
Pacf(train, main = 'Pacf For Differenced Series')
auto.arima(train,seasonal = FALSE)#pdq=1,0,1 
#from plots of ACF and PACF above we get 7,0,19 for pdq

