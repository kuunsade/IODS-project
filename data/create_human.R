# Kuunsäde Mäenpää
# 16.11.2020

library(dplyr)

# Read the datasets

hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

# Exploring the datasets

glimpse(hd)
glimpse(gii)

# Both have 195 observations. Human development (hd) has 8 columns while gender inequality (gii) has 10 columns. Both have data from different countries around the world.

# Summaries

summary(hd)
summary(gii)

# Renaming the variables with shorter names

hd <- rename(hd, HDI_rank = HDI.Rank, HDI = Human.Development.Index..HDI., life_exp = Life.Expectancy.at.Birth, ed_exp = Expected.Years.of.Education, ed_mean = Mean.Years.of.Education, GNI = Gross.National.Income..GNI..per.Capita, GNI_minus_HDI = GNI.per.Capita.Rank.Minus.HDI.Rank)
head(hd) # Whew, much better

gii <- rename(gii, GII_rank = GII.Rank, GII = Gender.Inequality.Index..GII., mat_mort_ratio = Maternal.Mortality.Ratio, adol_birthrate = Adolescent.Birth.Rate, rep_parliament = Percent.Representation.in.Parliament, F_secondary_ed = Population.with.Secondary.Education..Female., M_secondary_ed = Population.with.Secondary.Education..Male., F_labour_force = Labour.Force.Participation.Rate..Female., M_labour_force = Labour.Force.Participation.Rate..Male.)
head(gii) # Again, much better

gii <- gii %>% mutate(ed_FM = F_secondary_ed/M_secondary_ed, labour_FM = F_labour_force, M_labour_force)
head(gii) # Looks good

# Join the datasets
human <- inner_join(hd, gii, by = "Country")
dim(human) # 195 and 19 as it should

write.table(human, file = "human.txt")
