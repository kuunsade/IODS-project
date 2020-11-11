# Kuunsäde Mäenpää
# 10.11.2020
# Data wrangling of student data from: https://archive.ics.uci.edu/ml/datasets/Student+Performance

# Reading and exploring the data
student_mat <- read.csv("student-mat.csv", sep = ";")
student_por <- read.csv("student-por.csv", sep = ";")

dim(student_mat)
dim(student_por)

head(student_mat)
head(student_por)

str(student_mat)
str(student_por)

# Both datasets include 33 columns with demogrpahic data such as sex, age, address, family size. There are also columns which include grades
# and course absence info. The student_por table has 649 observations (rows) while student_math has 395 observations.

# Join the datasets

library(dplyr)

join_by <- c("school", "sex", "age", "address", "famsize", "Pstatus", "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery","internet")
students_mathpor <- inner_join(student_mat, student_por, by = join_by, suffix = c(".math", ".por"))

newdata_mathpor <- select(students_mathpor, one_of(join_by))
notjoined_columns <- colnames(student_mat)[!colnames(student_mat) %in% join_by]

# Combine duplicated data according to DataCamp ifelse structure
# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(students_mathpor, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    newdata_mathpor[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    newdata_mathpor[column_name] <- first_column
  }
}


newdata_mathpor <- mutate(newdata_mathpor , alc_use = (Dalc + Walc) / 2, high_use = alc_use > 2)

# The data should have 382 observations and 35 variables.
dim(newdata_mathpor)

# It's correct. Let's save the data.

write.table(newdata_mathpor, file = "alc_mathpor.txt")

test <- read.table("alc_mathpor.txt")

# Everything's cool according to the exercise insturctions. Now, we did receive an email stating that there should be 370 observations
# instead of 382 but I'm going to leave this as is. 