# Kuunsäde Mäenpää
# 03.11.2020 Exercise 2

lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

# Check the first 6 data points
head(lrn14)
dim(lrn14)

# Check the data structure
str(lrn14)

# The data have 183 rows and 60 columns. 
# Most columns include integers with different scales of numbers (e.g. attitude, age, SU08), but there is one column which includes factors (gender).

library(dplyr)

# Creating the data analysis set according to DataCamp exercises

# Questions related to deep, surface and strategic learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# Select the columns related to deep learning and create column 'deep' by averaging
deep_columns <- select(lrn14, one_of(deep_questions))
lrn14$deep <- rowMeans(deep_columns)

# Select the columns related to surface learning and create column 'surf' by averaging
surface_columns <- select(lrn14, one_of(surface_questions))
lrn14$surf <- rowMeans(surface_columns)

# Select the columns related to strategic learning and create column 'stra' by averaging
strategic_columns <- select(lrn14, one_of(strategic_questions))
lrn14$stra <- rowMeans(strategic_columns)

# Choose the columns to keep
keep_columns <- c("gender","Age","Attitude", "deep", "stra", "surf", "Points")

# Select the 'keep_columns' to create a new dataset
learning2014 <- select(lrn14, one_of(keep_columns))

# Exclude zero points
learning2014 <- filter(learning2014, Points > 0)

# The data should now have 166 rows and 7 columns
dim(learning2014)

# It's correct. Now let's unify the column names so that all variables start with a smaller case letter

learning2014 <- rename(learning2014, age = Age, attitude = Attitude)

# Save the new dataset

write.table(learning2014, file = "learning2014.txt")

# Double check we did it right

doublecheck <- read.table("learning2014.txt")

dim(doublecheck) == dim(learning2014)
str(learning2014)
str(doublecheck)

# We are good.