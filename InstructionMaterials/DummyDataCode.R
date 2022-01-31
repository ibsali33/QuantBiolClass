library(dplyr) # data transformation
library(reshape2) # data transformation
library(stringr) # string manipulation


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

practicedata  <- data.frame(GeneNames, Hour0, Hour1, Hour2, Hour3, Hour4, Hour5, Hour6, Hour7, Hour8)

write.csv(practicedata, file = "HeatmapData.csv")

practicedata1 <- melt(practicedata,id.vars="GeneNames") %>% 
  rename(MeanCounts = value,
         TimePoint = variable)

timetrim <- as.character(practicedata1$TimePoint)
timetrim <- str_sub(timetrim, 5, -1)

practicedata1$TimePoint <- as.numeric(timetrim)  
  
write.csv(practicedata1, file = "GeneExpressionData.csv")
  
  