# =====================================================================
# Module 1.4 Supplement: More Permutation
# =====================================================================

# Let's apply what we learned about permutations to another data set

# In this example, we will used the Palmer Penguins data set, 
# which can be loaded by calling the palmerpenguins package
library(palmerpenguins)

# We will also need the ggplot2 and tidyverse packages
library(ggplot2)
library(tidyverse)

# =====================================================================
# Data exploration
# =====================================================================

# The palmerpenguins package comes with a penguins data frame
# Data exploration
head(penguins)

# We will explore whether flipper length and is partially explained by sex

# Visualization of the data
ggplot(penguins, aes(x = sex, y = flipper_length_mm, color = sex)) + 
  geom_violin() +
  geom_point()

# Some of the points might be superimposed
# This is called "overplotting"
# We can solve this by slightly "jittering" the points 
# Using geom_jitter instead of geom_point
ggplot(penguins, aes(x = sex, y = flipper_length_mm, color = sex)) + 
  geom_violin() +
  geom_jitter(width = 0.1, height = 0)

# Remove NAs
sum(is.na(penguins$sex))
penguins_clean <- penguins[!is.na(penguins$sex), ]
# Alternative method:
# penguins_clean = penguins %>% filter(!is.na(sex))

# Visualization of the cleaned data
ggplot(penguins_clean, aes(x = sex, y = flipper_length_mm, color = sex)) + 
  geom_violin() +
  geom_jitter(width = 0.1, height = 0)

# =====================================================================
# Exploring the association between flipper length and sex
# =====================================================================

# Are there differences in flipper length between males and females? 
  
# To make code more readable, we can create an indicator variable
is_female <- penguins_clean$sex == "female"

# Compare the average flipper length across sexes
avg_female <- mean(penguins_clean$flipper_length_mm[is_female])
avg_male <- mean(penguins_clean$flipper_length_mm[!is_female])
diff_flipper_length <- avg_female - avg_male

# Print the outputs
print(paste("Flipper lenth difference between male and female is: ", diff_flipper_length))
print("Is is REAL?")

# To build intuition, let's look at the difference from the within group mean (residual)
# This represents the within group dispersion 
individual_diff_from_mean <- array(NA, nrow(penguins_clean))
individual_diff_from_mean[is_female] <- penguins_clean$flipper_length_mm[is_female] - avg_female
individual_diff_from_mean[!is_female] <- penguins_clean$flipper_length_mm[!is_female] - avg_male

# Add this new variable to the data_frame
penguins_clean_diff <- cbind(penguins_clean, individual_diff_from_mean)

# Visualization of the residuals
ggplot(penguins_clean_diff, aes(x = individual_diff_from_mean, fill = sex)) +
  geom_histogram()

# It looks like the distribution is bi-modal, but this pattern is not driven by sex
# This is also visible on a violin plot
ggplot(penguins_clean_diff, aes(x = sex, y = individual_diff_from_mean, color = sex)) +
  geom_violin() +
  geom_jitter(width = 0.1, height = 0)

# Let's look at how the data are distributed across islands
ggplot(penguins_clean_diff, aes(x = sex, y = individual_diff_from_mean, color = island)) +
  geom_violin() +
  geom_point(position = position_jitterdodge(dodge.width = 0.9))
# Explore why "dodging" is needed

# Ok, so it looks like we need to account for "island" effect
# Let's repeat the same procedure, including the island effect

# =====================================================================
# Adding an island effect
# =====================================================================

# Compare the average flipper length across sexes and islands
avg_by_sex_and_island <- penguins_clean %>% 
                            group_by(sex, island) %>% 
                            summarise(avg = mean(flipper_length_mm))

# Calculate the within group dispersion 
individual_diff_from_mean <- array(NA, nrow(penguins_clean))
for (i in seq(nrow(avg_by_sex_and_island))) {
  ix <- which(penguins_clean$sex == avg_by_sex_and_island$sex[i] &
             penguins_clean$island == avg_by_sex_and_island$island[i])
  individual_diff_from_mean[ix] <- penguins_clean$flipper_length_mm[ix] - avg_by_sex_and_island$avg[i] 
}

# Add this new variable to the data_frame
penguins_clean_diff <- cbind(penguins_clean, individual_diff_from_mean)

# Visualization of the residuals
ggplot(penguins_clean_diff, aes(x = individual_diff_from_mean, fill = sex:island)) + 
  geom_histogram()
ggplot(penguins_clean_diff, aes(x = sex, y = individual_diff_from_mean, color = sex)) + 
  geom_violin() +
  geom_jitter(width = 0.1, height = 0)
ggplot(penguins_clean_diff, aes(x = sex, y = individual_diff_from_mean, color = island)) + 
  geom_violin() +
  geom_point(position = position_jitterdodge(dodge.width = 0.9))

# Ok, so we cannot ignore the island effect...
# Let's calculate the difference between male and female within an island
avg_by_sex_and_island <- penguins_clean %>% 
                            group_by(sex, island) %>% 
                            summarise(avg = mean(flipper_length_mm))

diff_flipper_length <- mean(avg_by_sex_and_island$avg[avg_by_sex_and_island$sex == "female"] - 
                     avg_by_sex_and_island$avg[avg_by_sex_and_island$sex == "male"])

print(paste("Flipper lenth difference between male and female accounting for island is: ", diff_flipper_length))
print("Is is REAL?")

# Put that code in a function, we are going to use it lots of times. 
sex_diff = function(png) {
  avg_by_sex_and_island <- png %>% 
    group_by(sex, island) %>% 
    summarise(avg = mean(flipper_length_mm))
  
  diff_flipper_length <- mean(avg_by_sex_and_island$avg[avg_by_sex_and_island$sex == "female"] - 
                                avg_by_sex_and_island$avg[avg_by_sex_and_island$sex == "male"])
  return(diff_flipper_length)
}

# Bootstrapping 
iter <- 1000
boot_diff <- array(NA, iter)
for (i in seq(iter)) {
  smpl_ix <- sample(nrow(penguins_clean), replace = TRUE)
  # create sample from sample dataframe
  png_boot <- penguins_clean[smpl_ix, ]
  boot_diff[i] <- sex_diff(png_boot)
}

# Plot the results
ggplot(data.frame(flipper_difference = boot_diff), aes(x = flipper_difference)) + 
  geom_histogram()
