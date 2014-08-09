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

# plot
sample.x$DateTime<-with(sample.x,paste(Date,Time))
# the lubridate ymd_hms funct. will get the timeseries needed from the concatenated 
# Date and Time columns; ymd_hms(sample.x$DateTime)

Sys.setlocale("LC_TIME", "English") # set system local to English

# do the actual plot
par(mfcol = c(2, 2), mar = c(4, 4, 2, 1), oma = c(0, 0, 2, 0))
with(sample.x,
     {
         plot(ymd_hms(sample.x$DateTime),Global_active_power,type="l",xlab="",ylab="Global Active Power (killowatts)")
        {
             plot(ymd_hms(sample.x$DateTime),Sub_metering_1,type="l",xlab="",ylab="Energy Sumetering",ylim=c(0,40))
             par(new=T)
             plot(ymd_hms(sample.x$DateTime),Sub_metering_2,type="l",col="red",xlab="",ylab="Energy Sumetering",ylim=c(0,40))
             par(new=T)
             plot(ymd_hms(sample.x$DateTime),Sub_metering_3,type="l",col="blue",xlab="",ylab="Energy Sumetering",ylim=c(0,40))
             legend("topright", lty=1, col = c("black", "red","blue"), legend = c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"),xjust=1,bty="n")
         }
        plot(ymd_hms(sample.x$DateTime),Voltage,type="l",xlab="datetime",ylab="Voltage")
        plot(ymd_hms(sample.x$DateTime),Global_reactive_power,type="l",xlab="datetime",ylab="Global_reactive_power")
     })

# write it to file
dev.copy(png,file="plot4.png",width=480,height=480)
dev.off()