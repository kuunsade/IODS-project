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

# Week 5 exercise
# 23.11.2020


# Since I'm a bit unhappy with my last week's choices, I'm going to mutate the data a bit before describing the dataset

human <- human %>% rename(country = Country, edu_exp = ed_exp, edu_mean = ed_mean, secondary_eduF = F_secondary_ed, secondary_eduM = M_secondary_ed, labour_forceF = F_labour_force, labour_forceM = M_labour_force, edu_FM = ed_FM)

glimpse(human)

# Data frame has 195 rows and 19 columns. Brief description of the variables:
# HDI: Human development index.HDI emphasises people and their capabilities as the ultimate criteria for assessment of the development of a country instead of economic growth alone
# HDI_rank: Human Development Index rank as in how well a country has been ranked according to HDI.
# Country: Well, a country.
# life_exp: Life expectancy in a country.
# edu_exp: Expected years of education.
# edu_mean: Mean years of education
# GNI: Gross national income.
# GNI_minus_HDI: GNI per capita minus HDI rank
# GII_rank: Gender inequality index rank of a country
# GII: Gender inequality index, reflects gender-based disadvantage in three dimensions—reproductive health, empowerment and the labour market
# mat_mort_ratio: Maternal mortality ratio
# adol_birthrate: Adolescent birthrate
# rep_parliament: Parliamentary representation of women (percent)
# secondary_eduF: Population with secondary education, female
# secondary_eduM: Population with secondary education, male
# labour_forceF: Labour force participation rate, female
# labour_forceM: Labour force participation rate, male
# edu_FM: Population with secondary education, female population divided by male population
# labour_FM: Labour force participation rate, female population divided by male population

# Mutate GNI to numeric
library(stringr)

human <- human %>% mutate(GNI= as.numeric(str_replace(GNI, pattern=",", replace ="")))

# Keep certain columns
keep_columns <- c("country", "edu_FM", "labour_FM", "edu_exp", "life_exp", "GNI", "mat_mort_ratio", "adol_birthrate", "rep_parliament")
human <- select(human, one_of(keep_columns))

# Exclude missing values
human <- human %>% na.omit

# Remove regional observations (not countries)
human$country

# Looks like the last 7 are regional observations

tail(human, 7)

# Define the last indice we want to keep
last <- nrow(human)- 7

# Choose everything until the last 7 observations
human_ <- human[1:last,]

# Add countries as rownames and remove countries
rownames(human_) <- human_$country
human_ <- select(human_, -country)
dim(human_) # 155 and 8 as it should

write.table(human_, file = "human_week5", col.names = TRUE)
