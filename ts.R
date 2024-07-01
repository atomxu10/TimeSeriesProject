data <- rnorm(100,0,1)
y <- ts(data)
y
x <- ts(data, start=c(1978,1), frequency=12)
x
ts.plot(y)
ts.plot(x)
# add details
ts.plot(y, main="Random number generation", xlab="time",
        ylab="response")

# filter
weights <- c(1/24, rep(1/12,11), 1/24)
ts.ma <- filter(y, filter=weights, sides=2)
ts.plot(ts.ma)

# acf(auto-correlation function)
acf(y)

# Example: An AR(1)process.
# The following Figure shows the acf and a realization of 100 observations from the AR(1) process
# yt = −0.8yt−1 + εt.
y <- arima.sim(100, model=list(ar=-0.8))
ts.plot(y)
acf(y)

# Example: An AR(2) process. 
# Figure 3.2 overleaf shows a realization of the AR(2)
# process yt = 0.5yt−1 + 0.25yt−2 + εt.
y <- arima.sim(100, model=list(ar=c(0.5,0.25)))
ts.plot(y)
acf(y)

# the MA(1) process 
# yt = εt + 0.8εt−1, and the process ACF.
y <- arima.sim(100, model=list(ma=0.8))
ts.plot(y)
acf(y)

# An ARMA(1,1) process.
# a realization of 100 values of the ARMA(1,1) 
# yt = 0.8yt−1 + εt + 0.9εt−1, and the process ACF.
y <- arima.sim(100, model=list(ar=0.8,ma=0.9))
ts.plot(y)
acf(y)


