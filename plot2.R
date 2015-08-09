# Creating png file with Plot 2

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

# Open file device for plotting
png(file="plot2.png", width=480, height=480)

# Set grid type
par(mfrow=c(1, 1))

# Draw plot with appropriate arguments
with(powerdata, plot(Time, Global_active_power, xlab="", ylab="Global Active Power (kilowatts)", type="l"))

# Close file device
dev.off()
