## First process the data and choose the rows needed for the analysis
# Use the first row of the dataset to help process the time data 
first_row <- read.table("household_power_consumption.txt", header = TRUE,
                        sep = ";", na.strings = "?", stringsAsFactors = FALSE,
                        nrows = 1)
file_start <- strptime(paste(first_row$Date, first_row$Time, sep = " "),
                       format = "%d/%m/%Y %H:%M:%S")

# Start and end datetimes for the range of interest

start_datetime <- strptime("2007-02-01 00:00:00", format = "%Y-%m-%d %H:%M:%S")
end_datetime <- strptime("2007-02-02 23:59:00", format = "%Y-%m-%d %H:%M:%S")

# Determine the number of rows to skip and the number to read

skipRow <- difftime(start_datetime, file_start, units = "mins")
dataRow <- difftime(end_datetime, start_datetime, units = "mins") + 1

# Use colClasses, skip and nrows to load data quickly
classes <- sapply(first_row, class)
column_names <- colnames(first_row)
data <- read.table("household_power_consumption.txt", header = TRUE,
                   sep = ";", na.strings = "?",
                   colClasses = classes,
                   skip = skipRow,
                   nrows = dataRow)

# Recover column names

colnames(data) <- column_names

dTime <- strptime(paste(data[ , 1], data[ , 2], sep = " "), "%d/%m/%Y %H:%M:%S")

dateTime <- as.POSIXct(dTime)

# Generate the graph

windows()

png(filename = "plot2.png", width = 480, height = 480)

plot(dateTime, data$Global_active_power,type = "l",xlab = "", ylab = "Global Active Power (kilowatts)")

dev.off()