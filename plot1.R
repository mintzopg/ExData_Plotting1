# load the lubridate library
library(lubridate)
# load the data from the working directory into R env.
household_power_consumption <- read.csv("./household_power_consumption.txt", sep=";")

# convert the Date and Time fields to chacater vec.
x<-within(
    household_power_consumption,
    {
        Date<-as.character(Date)
        Time<-as.character(Time)
    }
    )

# load data to a new data frame called x (for name convenience), with Dates tranformed to POSIXct dates, 
# using the lubridate dmy() function
x<-within(household_power_consumption,{Date=dmy(Date)})

# remove from memory the original data set
rm(household_power_consumption)
# select the sample data requested in the project, where dates between 2007-02-01 and 2007-02-02,
# using the lubridate ymd() function
sample.x<-x[x$Date>=ymd("2007-02-01") & x$Date<=ymd("2007-02-02"),]
rm(x)
# convert everything to numeric
sample.x<-within(sample.x,
{
    Global_active_power=as.numeric(as.character(Global_active_power))
    Global_reactive_power=as.numeric(as.character(Global_reactive_power))
    Voltage=as.numeric(as.character(Voltage))
    Global_intensity=as.numeric(as.character(Global_intensity))
    Sub_metering_1=as.numeric(as.character(Sub_metering_1))
    Sub_metering_2=as.numeric(as.character(Sub_metering_2))
    Sub_metering_3=as.numeric(as.character(Sub_metering_3))
})

# chceck if any missing values exist (no action taken, just info)
any(sample.x$Global_active_power=="?")

# hist: breaks="Sturges" algorithm. 
with(sample.x,hist(Global_active_power,main="Global Active Power",xlab="Global Active Power(killowatts)",freq=T,col="red",ylim=c(0,1200)))

# write it to file
dev.copy(png,file="plot1.png")
dev.off()