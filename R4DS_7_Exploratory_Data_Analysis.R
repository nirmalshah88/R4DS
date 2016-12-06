#############################################################################
# R for Data Science (Garrett Grolemund, Hadley Wickham)
#############################################################################

# [7] EXPLORATORY DATA ANALYSIS

browseURL('http://r4ds.had.co.nz/exploratory-data-analysis.html')

# [7.1] Introduction

# Exploratory Data Analysis (EDA) = iterative process of using visualization and transformation in a systematic way

# EDA Steps:
# 1. Generate questions about the data
# 2. Search for answers by visualizing, transforming, and modeling your data
# 3. Use what you learn to refine your questions or generate new ones
# Repeat until you have answered your questions using data-driven methods

# NOTE: 'EDA is a state of mind'!
# i.e. Data cleaning is an application of EDA b/c we ask questions about whether or not the data meets your expectations or not

# [7.1.1] Prerequisites

library(tidyverse)

# [7.2] Questions

# EDA Goal = develop a deep understanding of your data, by using questions as a guide
# NOTE: The key to asking quality questions is to generate a large quantity of questions

# There are no right questions, but here's a good starting point:
# 1. What type of variation occurs 'within' my variables?
# 2. What type of covariation occurs 'between' my variables?

# Common Terms to Remember:
# > Variable = a quantity, quality, or property that you can measure
# > Value = the state of a variable when you measure it (may change from measurement to measurement)
# > Observation (AKA data point) = a set of measurements made under similar conditions (you usually make all of the measurements in an observation at the same time and on the same object)
# > Tabular data = a set of values, each associated with a variable and an observation

# [7.3] Variation

# > Variation = tendency of values of a variable to change from measurement to measurement
# NOTE: If you measure any continuous variable twice, you will get two different results. Categorical variables can also vary if you measure across different subjects or times.

# [7.3.1] Visualizing distributions

# NOTE: How you visualise the distribution of a variable will depend on whether the variable is CATEGORICAL or CONTINUOUS.

# > Categorical: variable that can take only a finite set of values
# NOTE: Usually saved as factors or character vectors

# i.e. To examine the distribution of a categorical variable, use a bar chart:
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))
# NOTE: You can compute the height of each bar manually using count():
diamonds %>%
  count(cut)

# > Continuous: variable that can take any of an infinite set of ordered values
# NOTE: Examples include Numbers and DateTime
ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.5)
# NOTE: You can compute this by hand using count():
diamonds %>% 
  count(cut_width(carat, 0.5))

# NOTE: When plotting a histogram, make it a habit to try different binwidths
# i.e. Zooming into data to observe diamonds that are less than 3 carats
smaller <- diamonds %>% 
  filter(carat < 3)
ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.1)

# NOTE: For overlaying multiple histograms, use geom_freqpoly() (uses lines instead of bars)
ggplot(data = smaller, mapping = aes(x = carat, color = cut)) +
  geom_freqpoly(binwidth = 0.1)

# NOTE: The key to asking good follow-up questions will be to rely on your CURIOUSITY (What do you want to learn more about?) as well as your SKEPTICISM (How could this be misleading?)

# [7.3.2] Typical values

# In both bar charts & histograms, tall bars show the common values of a variable, and shorter bars show less-common values. 

# To turn this information into useful questions, look for anything unexpected:
# > Which values are the most common? Why?
# > Which values are rare? Why? Does that match your expectations?
# > Can you see any unusual patterns? What might explain them?

# i.e. When looking at histogram below, what questions come to mind?:
ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.01)
# NOTE: Questions that might come to mind...
# 1. Why are there more diamonds at whole carats and common fractions of carats (i.e. 1/2, 1/4)?
# 2. Why are there more diamonds slightly to the right of each peak than there are slightly to the left of each peak?
# 3. Why are there no diamonds bigger than 3 carats?

# Clusters of similar values suggest that subgroups exist in your data. 
# NOTE: To understand the subgroups, ask:
# 1. How are the observations within each cluster similar to each other?
# 2. How are the observations in separate clusters different from each other?
# 3. How can you explain or describe the clusters?
# 4. Why might the appearance of clusters be misleading?

# i.e. The histogram below shows the length (in minutes) of 272 eruptions of the Old Faithful Geyser in Yellowstone National Park.
ggplot(data = faithful, mapping = aes(x = eruptions)) + 
  geom_histogram(binwidth = 0.25)
# NOTE: Eruption times appear to be clustered into 2 groups: short eruptions (of around 2 minutes) and long eruptions (4-5 minutes), but little in between

# NOTE: Many of the questions above will prompt you to explore a relationship BETWEEN variables

# [7.3.3] Unusual values

# Outliers = observations that are unusual or that don’t seem to fit the pattern
# NOTE: Outliers can be data entry errors but sometimes could suggest important science!

# Outliers are sometimes difficult to see in a histogram, for example:
ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5)
# NOTE: The y variable measures one of the three dimensions of these diamonds, in mm

# To make it easy to see the unusual values, we need to zoom into to small values of the y-axis with coord_cartesian():
ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
  coord_cartesian(ylim = c(0, 50))
# NOTE: coord_cartesian() also has an xlim() argument for when you need to zoom into the x-axis

# i.e. From the above there are three unusual values: 0, ~30, and ~60
# Use dplyr to investigate further:
unusual <- diamonds %>% 
  filter(y < 3 | y > 20) %>% 
  arrange(y)
unusual
# NOTE: We know that diamonds can’t have a width of 0mm, so these values must be incorrect. We might also suspect that measurements of 32mm and 59mm are implausible: those diamonds are over an inch long, but don’t cost hundreds of thousands of dollars!

# It’s good practice to repeat your analysis with and without the outliers.
# > If they have minimal effect on the results, and you can’t figure out why they’re there, it’s reasonable to replace them with missing values, and move on.
# > If they have a substantial effect on your results, you shouldn’t drop them without justification.

# *****************************************************

# EXERCISES

# 1. Explore the distribution of each of the x, y, and z variables in diamonds. What do you learn? Think about a diamond and how you might decide which dimension is the length, width, and depth.

# ANSWER: TODO
# Glimpse @ data
diamonds %>% glimpse()
# Exploring the x variable:
diamonds %>%
  ggplot(., mapping = aes(x = x)) + 
  geom_histogram(binwidth = 0.25) + 
  coord_cartesian(ylim = c(0, 6000))
# Exploring the y variable:
diamonds %>%
  ggplot(., mapping = aes(x = y)) + 
  geom_histogram(binwidth = 0.25) + 
  coord_cartesian(ylim = c(0, 6000))
# Exploring the z variable:
diamonds %>%
  ggplot(., mapping = aes(x = z)) + 
  geom_histogram(binwidth = 0.25) + 
  coord_cartesian(ylim = c(0, 10500))

# ANSWER:

# 2. Explore the distribution of price. Do you discover anything unusual or surprising? (Hint: Carefully think about the binwidth and make sure you try a wide range of values.)

# ANSWER: TODO

# 3. How many diamonds are 0.99 carat? How many are 1 carat? What do you think is the cause of the difference?

# ANSWER: TODO

# 4. Compare and contrast coord_cartesian() vs xlim() or ylim() when zooming in on a histogram. What happens if you leave binwidth unset? What happens if you try and zoom so only half a bar shows?

# ANSWER: TODO

# *****************************************************

# [7.4] Missing Values


