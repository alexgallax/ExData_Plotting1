# Creating png file with Plot 4

# Local setting for days of the week on the plot axis
Sys.setlocale("LC_ALL", "English")

# Dataset file
datafile <- "./household_power_consumption.txt"

# Find rows to read from the dataset file
filter <- grep("^[12]/2/2007", readLines(datafile))  # Get rows matching date conditions
skiplines <- filter[1] - 1                           # Number of rows to skip
readrows <- filter[length(filter)] - skiplines       # Number of rows ro read

# Read data, that match date conditions, from file
datanames <- read.table(datafile, sep=";", header=TRUE, nrows=1)                                         # Read columns headers
powerdata <- read.table(datafile, sep=";", header=FALSE, na.strings="?",skip=skiplines, nrows=readrows)  # Read data from file
names(powerdata) <- names(datanames)                                                                     # Set dataset headers names

# Convert data in date and time columns
powerdata$Date <- as.Date(powerdata$Date, "%d/%m/%Y")             # Convert Date column
powerdata$Time <- paste(powerdata$Date, powerdata$Time, sep=" ")  # Merge Date and Time columns
powerdata$Time <- strptime(powerdata$Time, format="%F %T")        # Convert Time column

# While filtering dataset by specific dates we assume, that data in source file is sorted by date
# But in some cases unwanted dates may be in the middle of reading content if data isn't sorted properly
# So we check out data set if there are unwanted dates

# Check if data set have any unwanted dates
checkdate <- grepl("2007-02-0[12]", powerdata$Date)

# If there are any wrong dates filter data set
if (!all(checkdate)) powerdata <- (subset(powerdata, checkdate))

# Columns and colors for plot
plotcolumns = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")  # Columns for plotting
plotcolors = c("black", "red", "blue")                                 # Colors for plot

# Open file device for plotting
png(file="plot4.png", width=480, height=480)

# Set grid type
par(mfrow=c(2,2))

# Draw plots with appropriate arguments in order
# 1st plot
plot(powerdata$Time, powerdata$Global_active_power, xlab="", ylab="Global Active Power", type="l")

# 2nd plot
plot(powerdata$Time, powerdata$Voltage, xlab="datetime", ylab="Voltage", type="l")

# 3rd plot
plot(powerdata$Time, powerdata[, plotcolumns[1]], xlab="", ylab="Enegy sub metering", type="l", col=plotcolors[1])
lines(powerdata$Time, powerdata[, plotcolumns[2]], type="l", col=plotcolors[2])
lines(powerdata$Time, powerdata[, plotcolumns[3]], type="l", col=plotcolors[3])
legend("topright", legend=plotcolumns, lty="solid", col=plotcolors, bty="n")

# 4th plot
plot(powerdata$Time, powerdata$Global_reactive_power, xlab="datetime", ylab="Global_reactive_power", type="l")

# Close file device
dev.off()
