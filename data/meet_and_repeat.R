# Kuunsäde Mäenpää
# 30.11.2020

library(dplyr)
library(tidyr)

BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep  =" ", header = T)
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", sep = "\t", header = T)

glimpse(BPRS);glimpse(RATS)

# BPRS has 40 rows and 11 columns.
# RATS has 16 rows and 13 columns.
# R has interpreted all of the variables as integers.

summary(BPRS);summary(RATS)

# Both datasets have two categorical variables (which we'll convert them to in a minute): BPRS has treatment and subject
# RATS has ID and Group. Both have longitudal data from different time points in their own columns. With BPRS, the weekly median
# goes down with time, but RATS is the opposite: the median values go up.

# Convert to factors
BPRS$treatment <- as.factor(BPRS$treatment)
BPRS$subject <- as.factor(BPRS$subject)
RATS$ID <- as.factor(RATS$ID)
RATS$Group <- as.factor(RATS$Group)

# Extract week number or time
BPRSL <-  BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject) %>% mutate(week = as.integer(substr(weeks, 5,5)))
RATSL <- RATS %>%  gather(key = WD, value = Weight, -ID, -Group) %>% mutate(Time = as.integer(substr(WD, 3, 4))) 

glimpse(BPRSL);glimpse(RATSL)

# Both datasets now have 5 columns, but BPRSL has 360 rows (previously 40) and RATSL has 176 rows (previously 16). The previous dataset rows
# correspond to each research subject and the columns indicated information on said research subject. It's the same with long form.
# BUT! Now we have gathered the longitudal data into multiple rows, so each subject has "repeats" after a certain point.
# This hopefully makes it easier to analyse and visualise in furhter steps.

write.table(RATSL, "RATSL.txt")
write.table(BPRSL, "BPRSL.txt")
