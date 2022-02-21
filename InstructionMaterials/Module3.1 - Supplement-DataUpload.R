# Create a "data" directory
dir.create("Data/RNAData")

# Download the data provided by your collaborator
# using a for loop to automate this step
for(i in c("counts_raw.csv", "counts_transformed.csv", "sample_info.csv", "test_result.csv")){
  download.file(
    url = paste0("https://github.com/tavareshugo/data-carpentry-rnaseq/blob/master/data/", i, "?raw=true"),
    destfile = paste0("Data/RNAData/", i)
  )
}

raw_cts = read.csv("Data/RNAData/counts_raw.csv")
trans_cts = read.csv("Data/RNAData/counts_transformed.csv")
sample_info = read.csv("Data/RNAData/sample_info.csv")
test_result = read.csv("Data/RNAData/test_result.csv")

# load the package
library(tidyverse)

# "gather" the counts data
trans_cts_long <- trans_cts %>% 
  pivot_longer(cols = wt_0_r1:mut_180_r3, 
               names_to = "sample", 
               values_to = "cts")

# raw_cts_long <- raw_cts %>% 
#   pivot_longer(cols = wt_0_r1:mut_180_r3, 
#                names_to = "sample", 
#                values_to = "cts")

trans_cts_long <- full_join(trans_cts_long, sample_info, by = "sample")

#raw_cts_long <- full_join(raw_cts_long, sample_info, by = "sample")

write.csv(trans_cts_long, file = "Data/RNAData/counts_transformed_tidy.csv")
