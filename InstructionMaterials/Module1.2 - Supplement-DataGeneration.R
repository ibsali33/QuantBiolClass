# =====================================================================
# Module 1.2 Supplement: Generating a Dummy Data Set
# =====================================================================

# Recall that it is a best practice to load all the packages/libraries
# needed for running your code at the beginning. In this case we will use
# dplyr, reshape2 and stringr to create the data set we will use for
# data visualization in Module 1.3. If you get an error loading these
# libraries. Be sure to install the packages as outlined in the 
# Module 1.1 supplement

library(dplyr) # data transformation
library(reshape2) # data transformation
library(stringr) # string manipulation

# Set the seed of the random number generator
set.seed(1)

# For our data set we created a vector of 15 gene names, and vectors
# of numeric values simulating the number of counts per million for 
# eight time points. We use 'rnorm()' to select numbers in a random
# distribution and c() to concatenate the groups of 5 numbers into 
# the same vector. The groups of 5 each change systematically in their
# true mean and standard deviation over time.

GeneNames <- c("Gene01", "Gene02", "Gene03", "Gene04", "Gene05", 
               "Gene06", "Gene07", "Gene08", "Gene09", "Gene10", 
               "Gene11", "Gene12", "Gene13", "Gene14", "Gene15")
Hour0 <- c(rnorm(5, mean = 130, sd = 20), 
           rnorm(5, mean = 190, sd = 10), 
           rnorm(5, mean = 240, sd = 60))
Hour1 <- c(rnorm(5, mean = 140, sd = 20), 
           rnorm(5, mean = 185, sd = 12), 
           rnorm(5, mean = 260, sd = 55))
Hour2 <- c(rnorm(5, mean = 150, sd = 20), 
           rnorm(5, mean = 180, sd = 14), 
           rnorm(5, mean = 280, sd = 50))
Hour3 <- c(rnorm(5, mean = 160, sd = 20), 
           rnorm(5, mean = 175, sd = 16), 
           rnorm(5, mean = 300, sd = 45))
Hour4 <- c(rnorm(5, mean = 170, sd = 20), 
           rnorm(5, mean = 170, sd = 18), 
           rnorm(5, mean = 280, sd = 40))
Hour5 <- c(rnorm(5, mean = 180, sd = 20), 
           rnorm(5, mean = 165, sd = 20), 
           rnorm(5, mean = 260, sd = 35))
Hour6 <- c(rnorm(5, mean = 190, sd = 20), 
           rnorm(5, mean = 160, sd = 22), 
           rnorm(5, mean = 240, sd = 30))
Hour7 <- c(rnorm(5, mean = 200, sd = 20), 
           rnorm(5, mean = 155, sd = 24), 
           rnorm(5, mean = 220, sd = 25))
Hour8 <- c(rnorm(5, mean = 210, sd = 20), 
           rnorm(5, mean = 150, sd = 26), 
           rnorm(5, mean = 200, sd = 20))

# =====================================================================
# Supplementary Challenge: Looping and Randomization
# =====================================================================

# Create a loop that systematically generates randomized data for 15 genes
# Include at least two groups of genes that changes in different ways
# over time




# =====================================================================
# Module 1.2 Supplement: Finalizing the data set
# =====================================================================

# We then group the data set using the 'data.frame()' command. Remember
# hitting 'return' after commas will automatically indent your code to 
# improve readability and reduce the need for soft-wrapping the text.
practicedata <- data.frame(GeneNames, Hour0, Hour1, Hour2, Hour3, 
                            Hour4, Hour5, Hour6, Hour7, Hour8)

# Using the 'melt()' function from reshape2, collapse the data set into
# long form using the "GeneNames" vairables as our identifying variables
# noted as id.vars. If you have the dplyr library loaded, you can string
# together multiple commands with the pipe symbol noted as '%>%'. In this
# case we can rename the 'value' as MeanCounts (we are simulating RNA seq
# data in counts per million) and the 'variable' as TimePoint.
practicedata1 <- melt(practicedata, id.vars="GeneNames") %>% 
  rename(MeanCounts = value, TimePoint = variable)

# The stringr package allows us to manipulate vectors and matrices of 
# character data. For exmample, if we want to use our time point info
# as quantitative data, we have to remove the characters "Hour" from 
# each time point listed and convert the values to numbers.

# Create a vector of character strings from the Time Point information in the
# practicedata1 data frame that we can trim using the stringr package. 
timetrim <- as.character(practicedata1$TimePoint)

# Using str_sub, you can systematically remove characters from the beginning
# or end of a character string. In this case we want to remove the first four
# characters. Since indexing with R beings with 1. We want our substring to
# begin at character 5 and end at our last character in the string (noted as
# negative 1). Check out the stringr cheat sheet for the full set of commands
# and the respective syntax.
timetrim <- str_sub(timetrim, 5, -1)

# Replace the information in the TimePoint column of the practicedata1
# data frame.
practicedata1$TimePoint <- as.numeric(timetrim)  

# Add transcript data MeanCountsTranscript
# Here we consider that transcription level (MeanCountsTranscript) is linked to
# expression level (MeanCounts) through a linear function 
# MeanCountsTranscript = alpha + beta * MeanCounts + epsilon
# with epsilon corresponding to individual gene variation in translation (from transcript to protein) measurement
# epsilon follows a normal distribution centered on 0 (mean epsilon = 0),
# with a standard deviation of trans_var
# More info about random variables in Module 1.2
alpha = 100
beta = 10
trans_var = 7000
epsilon = rnorm(n = length(practicedata1$MeanCounts), mean = 0, sd = trans_var)
practicedata1$MeanCountsTranscript <- alpha + practicedata1$MeanCounts * beta + epsilon

# Add protein activity data MeanActivity
# Here we consider that transcription level (MeanActivity) is linked to
# expression level (MeanCounts) through a linear function 
# MeanActivity = alpha + beta * MeanCounts + epsilon
# with epsilon corresponding to individual protein activity measurement 
# epsilon follows a normal distribution centered on 0 (mean epsilon = 0),
# with a standard deviation of trans_var
alpha = 50
beta = 10
trans_var = 100
epsilon = rnorm(n = length(practicedata1$MeanCounts), mean = 0, sd = trans_var)
practicedata1$MeanActivity <- alpha + practicedata1$MeanCounts * beta + epsilon

# Using the 'write.csv()' command create a csv of the data we just created
# this command requires a data frame and a character vector designating the
# file name. See example below:
write.csv(practicedata1, file = "InstructionMaterials/GeneExpressionData.csv")
  
  
