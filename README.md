# Analysis of Daily Temperatures in Melbourne

Temperature data is usually analyzed and utilized as time series data. Time series models are frequently used to analyze trends and predict the future.

The goal of this project is to analyze and model temperatures in Melbourne. All corresponding codes (R Markdown) can be found in the [tsp.Rmd](https://github.com/atomxu10/TimeSeriesProject/blob/main/tsp.Rmd).

## Content
- [Data](#1)
- [Methodology](#2)
- [Data exploration (Daily data)](#3)
    - [Structure](#3-1)
    - [Analysis](#3-2)
- [Model I (Monthly data)](#4)
    - [Structure](#4-1)
    - [Model fitting (𝑆𝐴𝑅𝐼𝑀𝐴)](#4-2)
        - [Parameter selection](#4-2-1)
        - [Residual analysis](#4-2-2)
- [Model II (Weekly data)](#5)
    - [Structure](#5-1)
    - [Model fitting (𝐴𝑅𝐼𝑀𝐴)](#5-2)
        - [Parameter selection](#5-2-1)
        - [Residual analysis](#5-2-2)
    - [Forecasting](#5-3)
- [Conclusion](#6)

<a name="1"></a>
## Data
A time series data set consisting of daily maximum temperatures in Melbourne can be found in the file [TempMelbPRO1](https://github.com/atomxu10/TimeSeriesProject/blob/main/TempMelbPRO.csv). The dataset covers a period of 1 January 1981 to 31 December 1990 and it is kindly provided for educational use by the Time Series Data Library and the data provider DataMarket (DataMarket.com).
<a name="1-1"></a>

## Methodology
The total number of data is 3650. In order to make a final prediction, the data of 1989 and 1990 are used as the test set, and the data of the first eight years are used as the training set.

In terms of data selection, the data dimension is divided into daily data (original data set data), weekly data (weekly average maximum temperature data) and monthly data (monthly average maximum temperature data). The data is not divided by annual average data because of insufficient data volume.


The experimental design steps are as follows:
1. Structuring the data and describing the structure (trend, cyclicality, seasonality)
2. Model selection based on the data structure (𝐴𝑅𝐼𝑀𝐴, 𝑆𝐴𝑅𝐼𝑀𝐴)
3. Fitting model (stationary test, order of differences, parameter (p, q) selection)
4. Test model (residual diagnostics)
5. Prediction (comparison with testing set)

## Data exploration (Daily data)
### Structure
Structurally split the original data set. Figure 1 shows the data after decomposition which shows that the original data like wavy, and we guess it is cyclical or seasonal.

<div align="center">
    <img src="plot2/figure1.png" width="800px" alt="Figure 1">
</div>

<p align="center">Figure 1: Decomposition plot (Daily data)</p>


By observing the image, the trend cannot be clearly described, so the linear regression method is introduced to explore whether there is a trend. The linear fitting result is shown in [Figure 18](https://github.com/atomxu10/TimeSeriesProject/blob/main/plot2/figure18.png), and the time series data shows a downward trend.

The seasonal and non-seasonal data are separated for observation (Figure 2). The p-value of the ADF test of non-seasonal data [Figure 19](https://github.com/atomxu10/TimeSeriesProject/blob/main/plot2/figure19.png) is less than 0.05, which can be considered that the non-seasonal data is stationary.

<div align="center">
    <img src="plot2/figure2_.png" width="900px" alt="Figure 2">
</div>

<p align="center">Figure 2: Non-seasonal data plot (Daily data) & Seasonal data plot (Daily data)</p>

### Analysis
Seasonal difference is required to eliminate the influence of seasonality on the data. However, the seasonal difference function does not support lag greater than 350 in R, therefore the seasonal data is differentiated separately. Figure 3 shows the data image obtained after the first difference, which still shows obvious seasonality, and there is no significant seasonality after the 2nd order difference (Figure 3b). Multiple seasonal differences will reduce the period length of the series, which may cause the model to fail to capture seasonal changes, thus affecting the accuracy of prediction.

In the meanwhile, performing multiple seasonal differences will result in a loss of data, because each difference will reduce the dataset. Therefore, daily data will not be considered as a dataset.

<div align="center">
    <img src="plot2/figure3.png" width="900px" alt="Figure 3">
</div>

<p align="center">Figures 3a & 3b: Seasonal data after the 1st differencing & 2nd differencing </p>

## Model I (Monthly data)
We proceed by dividing the data into months and taking the mean value to obtain a dataset, consisting of the average maximum temperature of each month. The size of the training set is 96, and the testing set is 24.

### Structure
Figure 4 is the decomposed image of monthly data. Similar to the daily data, the monthly data shows significant seasonality. The degree to which the time series is affected by the 12-month seasonal fluctuation is 0.99. Using regression analysis to test the trend of the time series, the p-values of the regression coefficients are less than 0.05. The series shows a slight downward trend.

<div align="center">
    <img src="plot2/figure4.png" width="700px" alt="Figure 4">
</div>

<p align="center">Figure 4: Decomposition plot (Monthly data) </p>

### Model fitting (𝑆𝐴𝑅𝐼𝑀𝐴)
We use the SARIMA model to process time series data with seasonal structure. The SARIMA model decomposes the time series into seasonal and non-seasonal components and establishes an ARIMA model for each component separately. The SARIMA model can be expressed as 𝑆𝐴𝑅𝐼𝑀𝐴(𝑝, 𝑑, 𝑞) × (𝑃, 𝐷, 𝑄)𝑠.

Seasonal differencing can eliminate the seasonal structure and make the time series more stationary. Figure 5 is the data after 1st seasonal difference (lag=12). Compared with the data image before the difference, the seasonality after the seasonal difference is not as significant, and the degree of influence by the 12-month seasonal fluctuation is reduced to 0.63 (Figure 22). Multiple seasonal differences may lead to loss of data information. To retain more data and ensure the accuracy of the model, we will no longer continue to perform multiple seasonal differences.

<div align="center">
    <img src="plot2/figure5.png" width="700px" alt="Figure 5">
</div>

<p align="center">Figure 5: Data after 1st seasonal difference </p>

The ADF test is a commonly used method in time series analysis, which is used to test the stationarity of the sequence. ([Figure 23a](https://github.com/atomxu10/TimeSeriesProject/blob/main/plot2/figure23.png)) is the ADF test result of the data with seasonal differences. The null hypothesis cannot be rejected (H0: the time series is non-stationary), so it cannot be concluded that the time series is stationary.
To obtain a stationary series, the data needs to be differentiated once. The differenced data can be considered as a stable sequence after the ADF stationarity test ([Figure 23b](https://github.com/atomxu10/TimeSeriesProject/blob/main/plot2/figure23-2.png)).

#### Parameter selection
We determine the seasonal AR and MA order by observing the PACF and ACF plots after the seasonal difference to estimate P and Q (Figure 6). The ACF plot (Figure 6a) shows a sharp drop at 1st lag, which suggests that the series can be explained by a moving average model with 1 lag, therefore we set Q = 1. The PACF plot (Figure 6b) shows that almost all values are within the confidence interval and there is no exponential downward trend and we set P = 0.

<div align="center">
    <img src="plot2/figure6.png" width="800px" alt="Figure 6">
</div>

<p align="center">Figures 6a and 6b: ACF & PACF plots after 1st seasonal difference </p>

In the same way, The ACF plot (Figure 7a) shows a sharp drop at 2nd lag, so set q = 2. The PACF plot (Figure 7b) shows a sharp exponential decrease at 2nd lag, so set p = 2.

<div align="center">
    <img src="plot2/figure7.png" width="800px" alt="Figure 7">
</div>

<p align="center">Figures 7a and 7b: ACF & PACF plots after 1st seasonal difference and 1st difference </p>







