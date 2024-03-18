# Import data into dataframe and format
loadProfile.df <- read.csv("Hourly_Load_Profiles.csv", col.names=c("ds","y"),
                           header=TRUE, stringsAsFactors=FALSE)
head(loadProfile.df)
tail(loadProfile.df)

# Convert ds column to POSIXct
loadProfile.df$ds <- strptime(loadProfile.df$ds, format = "%d/%m/%Y %H:%M")
# Convert ds column to desired format
loadProfile.df$ds <- format(loadProfile.df$ds, "%Y-%m-%d %H:%M:%S")
head(loadProfile.df)
tail(loadProfile.df)

# make a copy of ds
loadProfile.df <- mutate (
    loadProfile.df,
    haha = ds)


# Import prophet
library(prophet)

# Fit the model calling the prophet function 
prophetModel <- prophet::prophet(loadProfile.df)

# make_future_dataframe function forecasts and produces a dataframe
# it bases this off the model object, "periods" and historical dates
# This adds forecasts to original df so we can evaluate in-sample fit.
future.df = prophet::make_future_dataframe(
  prophetModel, periods=10, freq="quarter")
head(future.df) # this will show original loadProfile.df
tail(future.df) # this will show the end of the appended future.df

# To get our forecast we use the generic predict function
forecast.df <- predict(prophetModel, future.df)

# To look at the uncertainty intervals and seasonal components
tail(forecast.df[c("ds","yhat","yhat_lower","yhat_upper")])

# To plot the forecast, we pass in the model and the forecast dataframe
plot(prophetModel,forecast.df)
# Interactive plot
prophet::dyplot.prophet(prophetModel,forecast.df)

# To see the forecast broken down further into its components
prophet::prophet_plot_components(prophetModel,forecast.df)

