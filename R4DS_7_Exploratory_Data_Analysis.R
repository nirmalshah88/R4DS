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

# ANSWER: Exploring the distribution of x, y, and z variables in diamonds reveals a few things about the shape and variability in each variable. It is evident that the lengths (x) and widths (y) of diamonds are strongly correlated (refer to scatterplot) since most cut diamonds have proportional lengths and widths to form a circular shape, despite a few outliers accounting for non-generic cuts. Moreover, the shape and size of the x and y distributions are almost identical, when viewed in the same scale, with 2 major peaks and 2 minor ones in between, this could mean that a majority of the diamonds fall into these length/width bins but a closer examination is required. The depth (z) of the diamond ranges between 2 and 6 mm, and I assume this is also proportional to x and y in some respect since most cut diamonds that have have a crown with a cone-like base tend to be proportional to the lengths and widths. For depth, there are 2 major peaks suggesting a majority of diamonds have a depth of 2.4 or 4 mm.
??diamonds
# Glimpse @ data
diamonds %>% glimpse()
diamonds %>% select(x, y, z) %>% summary()
# Exploring the x variable (length in mm):
diamonds %>%
  ggplot(., mapping = aes(x = x)) + 
    geom_histogram(binwidth = 0.25) + 
    coord_cartesian(ylim = c(0, 6000), xlim = c(0, 10))
# Exploring the y variable (width in mm):
diamonds %>%
  ggplot(., mapping = aes(x = y)) + 
    geom_histogram(binwidth = 0.25) + 
    coord_cartesian(ylim = c(100, 6000), xlim = c(0, 10))
# Exploring the z variable (depth in mm):
diamonds %>%
  ggplot(., mapping = aes(x = z)) + 
    geom_histogram(binwidth = 0.25) + 
    coord_cartesian(ylim = c(0, 10500), xlim = c(0, 8))

# SIDE-TRACKED:
# i.e. Exploring relationship between x and y linearity
diamonds %>%
  ggplot(mapping = aes(x = x, y = y)) +
    geom_point() + 
    coord_equal()
# NOTE: According to the plot, x and y are positively correlated. This makes sense since most diamonds are cut based on proportional values for length and width to form a circular crown.

# 2. Explore the distribution of price. Do you discover anything unusual or surprising? (Hint: Carefully think about the binwidth and make sure you try a wide range of values.)

# ANSWER: One thing that stands out when you plot the distribution of price is that over 7500 our of 53940 diamonds in the dataset are approximately $1000. In fact, 25% of all the diamonds in the dataset fall below $950! The average price is $3933 and median price is $2401 suggesting that the distribution is skewed right, which is also evident from the histogram. When zooming in, another interesting thing you see is that there is a clear trough at $1500 in the distribution, meaning no diamonds were sold at $1500...interesting, I wonder why?
# Glimpse @ data
??diamonds
diamonds %>% glimpse()
diamonds$price %>% summary()
# Exploring the price variable ($):
diamonds %>% 
  ggplot(aes(x = price)) +
    geom_histogram(binwidth = 1000)
diamonds %>% 
  ggplot(aes(x = price)) +
    geom_histogram(binwidth = 300)
diamonds %>% 
  ggplot(aes(x = price)) +
    geom_histogram(binwidth = 100)
diamonds %>% 
  ggplot(aes(x = price)) +
    geom_histogram(binwidth = 10)
# Zooming into lower price range
diamonds %>% 
  ggplot(aes(x = price)) +
    geom_histogram(binwidth = 10) + 
    coord_cartesian(xlim = c(0, 2000))
# NOTE: First, note that the cheapest diamond is around $300. Also, you can clearly see a trough around $1500. Meaning, none of the diamonds were priced at that price. Interesting...In fact when you look at the below code, it spits out the highest price below $1500, which is $1454, and the lowest price above $1500, which is $1546.
diamonds %>% filter(price < 1500) %>% arrange(desc(price)) %>% summarise(max = max(price))
diamonds %>% filter(price > 1500) %>% arrange(price) %>% summarise(min = min(price))

# 3. How many diamonds are 0.99 carat? How many are 1 carat? What do you think is the cause of the difference?

# ANSWER: According to the zoomed-in plot, there are almost 1600 diamonds with 1 carat and negligible amounts for 0.99. This could be because most diamonds are cut to match one of the standardized weights i.e. 1.0; in other words, 0.99 are rare because they may be due to minor overcutting during the diamond manufacturing. In the real world, to the naked eye at least, they would be indistinguishable. 
# Glimpse @ data
diamonds %>% glimpse()
diamonds$carat %>% summary()
# Explore the carat variable
diamonds %>%
  ggplot(aes(x = carat)) +
  geom_histogram()
diamonds %>%
  ggplot(aes(x = carat)) +
  geom_histogram(binwidth = 0.1)
diamonds %>%
  ggplot(aes(x = carat)) +
    geom_histogram(binwidth = 0.05)
# Zooming in really close to explore 0.99 carat and 1.00 carat diamonds
diamonds %>%
  ggplot(aes(x = carat)) +
  geom_histogram(binwidth = 0.005) + 
  coord_cartesian(xlim = c(0.98, 1.01))
# NOTE: See ANSWER for explanation
# Zooming out into lower carat range
diamonds %>%
  ggplot(aes(x = carat)) +
  geom_histogram(binwidth = 0.01) +
  coord_cartesian(xlim = c(0, 4))
diamonds %>%
  ggplot(aes(x = carat)) +
  geom_histogram(binwidth = 0.01) +
  coord_cartesian(xlim = c(0, 2.5))
# NOTE: There are a few peaks to note here. The highest peaks are 0.3, 0.7, and 1.0. The medium-sized ones are at 0.4, 0.5, 0.9. The less prominent ones are at 1.2, 1.5, and 2.0. These numbers could be because carats are a standardized measure of weight for diamonds, which is also related to the diameter of the diamonds.

# SIDE-TRACKED:
# http://www.lumeradiamonds.com/diamond-education/diamond-carat-weight
# NOTE: When carat weight triples (from 1 to 3 carats), perceived size (represented in the images below) roughly triples as well, however the diameter increases only 45% (from 6.50 to 9.40), and crown area (the surface area visible when the diamond is set) slightly more than doubles.
# SIDE-NOTE: 1.00 carat = $6,000, 2.00 carat = $24,000, 3.00 carat = $54,000 (price = carat*6000)
# i.e. Exploring relationship between length and carats
diamonds %>%
  filter(x > 0, carat > 0) %>%
  ggplot(aes(x = x, y = carat)) + 
  geom_point() +
  geom_smooth()
diamonds %>%
  filter(x > 0, carat > 0) %>%
  ggplot(aes(x = y, y = carat)) + 
  geom_point() +
  geom_smooth() + 
  coord_cartesian(xlim = c(0, 20))
# NOTE: Indeed most 1.00 carat diamonds are approximately 6.5 mm in length

# 4. Compare and contrast coord_cartesian() vs xlim() or ylim() when zooming in on a histogram. What happens if you leave binwidth unset? What happens if you try and zoom so only half a bar shows?

# ANSWER: When using xlim() instead of coord_cartesian(), ggplot rmoved 32 rows which contain non-finite values and also did not include outer edge points specified by (0, 3) at 3. However, when using binwidth(), they plot the same information.
# Glimpse @ data
diamonds %>% glimpse()
# Zooming with coord_cartesian()
diamonds %>%
  ggplot(aes(x = carat)) + 
  geom_histogram() + 
  coord_cartesian(xlim = c(0, 3))
# Zooming with xlim()
diamonds %>%
  ggplot(aes(x = carat)) + 
  geom_histogram() + 
  xlim(c(0, 3))
# Zooming with coord_cartesian() using binwidth
diamonds %>%
  ggplot(aes(x = carat)) + 
  geom_histogram(binwidth = 0.05) + 
  coord_cartesian(xlim = c(0, 3))
# Zooming with xlim() using binwidth
diamonds %>%
  ggplot(aes(x = carat)) + 
  geom_histogram(binwidth = 0.05) + 
  xlim(c(0, 3))

# *****************************************************

# [7.4] Missing Values

# When you encounter missing values but wish to simply continue the rest of your analysis, you can:
# 1. Drop the entire row with unusual values: (NOT RECOMMENDED)
diamonds2 <- diamonds %>% 
  filter(between(y, 3, 20))
# 2. Replace unusual values with missing values (a.k.a. imputation): (RECOMMENDED)
diamonds2 <- diamonds %>% 
  mutate(y = ifelse(y < 3 | y > 20, NA, y)) # NOTE: ifelse(test, yes, no)

# When using ggplot2, it’s not obvious where to plot missing values, so ggplot2 doesn’t include them in the plot, but it does warn you:
ggplot(data = diamonds2, mapping = aes(x = x, y = y)) + 
  geom_point()
# NOTE: To suppress that warning, set na.rm = TRUE:
ggplot(data = diamonds2, mapping = aes(x = x, y = y)) + 
  geom_point(na.rm = TRUE)

# Sometimes you want to understand what makes observations with missing values different to observations with recorded values.
# i.e. For nycflights13::flights, missing values in 'dep_time' may infer cancelled flights
nycflights13::flights %>% 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60
  ) %>% 
  ggplot(mapping = aes(sched_dep_time)) + 
    geom_freqpoly(mapping = aes(colour = cancelled), binwidth = 1/4)
# NOTE: The plot above compares scheduled departure times for cancelled and non-cancelled flights; however, its not the best plot since there are way more non-cancelled than cancelled flights

# *****************************************************

# EXERCISES

# 1. What happens to missing values in a histogram? What happens to missing values in a bar chart? Why is there a difference?

# ANSWER: Histograms remove missing values while barplots don't. This is because continuous variables could take on an infinite number of values so its hard to show where those values could belong; however, barplots are generally take on a finite number of values and so plotting missing values under 'NA' category helps us understand how many missing values there are. Also, histograms use the 'bin' stat so its important to know which bin an observation belongs to in order to plot it; on the other hand, barplots use the 'count' stat so its easier to plot how many missing values exist as opposed to knowing which bin they may belong to.
?geom_histogram
?geom_bar
# i.e. Using nycflights13::flights for demo:
flights2 <- flights %>% 
  mutate(
    origin = factor(origin),
    dest = factor(dest)
  ) %>% glimpse()
flights2 %>% summary()
# Create histogram
flights2 %>% ggplot(aes(x = dep_time)) + geom_histogram(binwidth = 100)
# Create barplot
flights2$origin[100:500] <- NA
flights2 %>% ggplot(aes(x = origin)) + geom_bar()

# 2. What does na.rm = TRUE do in mean() and sum()?

# ANSWER: na.rm = TRUE allows you to calculate aggregate functions like mean() and sum() while omitting NAs. This is useful for doing any analyses prior to taking care of missing data since without including na.rm = TRUE, the results will be NA even if one of the observations is NA. NAs are contagious!
# i.e. Using nycflights13::flights for demo:
flights2 %>% glimpse()
# Summarize using mean() and sum() with NAs
flights2 %>% 
  summarize(
    avg_dep_time = mean(dep_time),
    total_air_time = sum(air_time)
  )
# Summarize using mean() and sum() without NAs
flights2 %>% 
  summarize(
    avg_dep_time = mean(dep_time, na.rm = TRUE),
    total_air_time = sum(air_time, na.rm = TRUE)
  )

# *****************************************************

# [7.5] Covariation

# Covariation = tendency for the values of two or more variables to vary together in a related way
# NOTE: While variation describes the behavior 'within' variables, covariation describes the behavior 'between' variables.
# NOTE: Best way to spot covariation is through visualizing relationship between 2 or more variables

# [7.5.1] A categorical and continuous variable

# i.e. How does the price of a diamond vary with quality?
ggplot(data = diamonds, mapping = aes(x = price)) + 
  geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)
# NOTE: The default appearance of geom_freqpoly() is not that useful to spot covariation because the height is given by the count. This means if one of the groups is significantly smaller than the rest, its hard to spot differences.

# Its hard to spot the difference in distribution b/c the overall counts differ so much:
ggplot(diamonds) + 
  geom_bar(mapping = aes(x = cut))

# To make comparison easier, we will replace 'count' with 'density':
ggplot(data = diamonds, mapping = aes(x = price, y = ..density..)) + 
  geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)
# NOTE: Surprisingly, it appears that fair diamonds (lowest quality) have the highest average price! This could be b/c its hard to interpret overlapping frequency polygons.

# Density = count standardised so that the area under each frequency polygon is one.

# Other than using geom_freqpoly() with 'density' stat, the 'boxplot' is another alternative to display the distribution of a continuous variable broken down by a categorical variable.

# Boxplot = a popular type of visual shorthand for a distribution of values
# > Interquartile range (IQR) = distance represented by the box that stretches from 25th percentile of distribution to 75th percentile
# > Median = the 50th percentile of the distribution represented by a line in the middle of the box
# > Outliers = visual points that display observations that fall more than 1.5 times the IQR from either edge of the box
# > Whisker = a line that extends from each end of the box and goes to the farthest non-outlier point in the distribution
# NOTE: The 3 lines in a boxplot give you a sense of the spread of the distribution and symmetry about the median (skewed or not)

# i.e. Using geom_boxplot() to look @ distribution of diamond prices by cut
diamonds %>% ggplot(aes(x = cut, y = price)) + geom_boxplot()
# NOTE: even though it provides less information about each distribution, boxplots are compact so they are great for making quick comparisons between various groups
# SIDENOTE: This plot supports our counterintuitive finding that, on average, better quality diamonds are cheaper!

# NOTE: 'cut' is an 'ordered factor' (fair < good < very good < premium < ideal). You can use reorder() to create more intuitive ordering
?reorder()
# i.e. How does highway mileage vary across classes (mpg$hwy vs mpg$class)
ggplot(data = mpg, mapping = aes(x = as.factor(class), y = hwy)) +
  geom_boxplot()
# NOTE: This ordering isn't the most intuitive for comparison
ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy))
# NOTE: We can now easily see that smaller vehicles (i.e. sedans, coupes) tend to have a higher highway mileage than larger vehicles (i.e. vans, trucks)
ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy)) +
  coord_flip() +
  labs(x = 'Vehicle Type', y = 'Highway Mileage')
# NOTE: Flipping the coordinate using coord_flip() helps with readability whenever you have lots of factor levels or categories

# *****************************************************

# EXERCISES

# 1. Use what you’ve learned to improve the visualisation of the departure times of cancelled vs. non-cancelled flights.

# ANSWER:
library(nycflights13)
# Original visualization
flights %>% 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60
  ) %>% 
  ggplot(mapping = aes(x = sched_dep_time, color = cancelled)) +
    geom_freqpoly(binwidth = 1/4)
# NOTE: This is hard to compare since there are lot fewer cancelled flights than non-cancelled flights
# Using density & geom_freqpoly()
flights %>% 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60
  ) %>% 
  ggplot(mapping = aes(x = sched_dep_time, y = ..density..)) +
    geom_freqpoly(aes(color = cancelled), binwidth = 1/4) + 
    labs(title = 'Density Distribution of Scheduled Departure Time (Cancelled Flights)', 
         x = 'Scheduled Departure Time', 
         y = 'Density', 
         color = 'Cancelled')
# NOTE: This is also hard to compare since they are overlapping plots
# Using boxplot
flights %>% 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60
  ) %>% 
  ggplot(mapping = aes(x = cancelled, y = sched_dep_time)) +
    geom_boxplot() + 
    coord_flip() + 
  labs(title = 'Distribution of Scheduled Departure Time (Cancelled Flights)', 
       x = 'Cancelled', 
       y = 'Scheduled Departure Time')
# NOTE: This is easier to compare in terms of where the median lies. Notice that the scheduled departure times are much later in the evening for cancelled flights, roughly around 5 PM, than non-cancelled flights which are scheduled to depart in the afternoon, around 2 PM.

# 2. What variable in the diamonds dataset is most important for predicting the price of a diamond? How is that variable correlated with cut? Why does the combination of those two relationships lead to lower quality diamonds being more expensive?

# ANSWER: 
# Glimpse @ data
diamonds %>% glimpse()
# Scatterplot Matrix to explore correlations
diamonds %>% pairs(~price + carat, data = ., main = 'Diamonds Scatterplot Matrix')
# Explore relationships between price and carat
d1 <- diamonds %>%
  filter(x > 0, y > 0, z > 0, depth > 0, carat > 0, price > 0) %>%
  filter(carat < 3) %>%
  ggplot(mapping = aes(x = carat, y = price)) + 
  geom_point() + 
  geom_smooth()
d1 + facet_wrap(~cut)

diamonds %>%
  filter(x > 0, y > 0, z > 0, depth > 0, carat > 0, price > 0) %>%
  filter(carat < 3) %>%
  ggplot(mapping = aes(x = carat, y = price)) + 
  geom_point()

# 3. Install the ggstance package, and create a horizontal boxplot. How does this compare to using coord_flip()?

# ANSWER: TODO

# 4. One problem with boxplots is that they were developed in an era of much smaller datasets and tend to display a prohibitively large number of “outlying values”. One approach to remedy this problem is the letter value plot. Install the lvplot package, and try using geom_lv() to display the distribution of price vs cut. What do you learn? How do you interpret the plots?

# ANSWER: TODO

# 5. Compare and contrast geom_violin() with a facetted geom_histogram(), or a coloured geom_freqpoly(). What are the pros and cons of each method?

# ANSWER: TODO

# 6. If you have a small dataset, it’s sometimes useful to use geom_jitter() to see the relationship between a continuous and categorical variable. The ggbeeswarm package provides a number of methods similar to geom_jitter(). List them and briefly describe what each one does.

# ANSWER: TODO

# *****************************************************

# [7.5.2] Two categorical variables

# To visualise the covariation between categorical variables, you’ll need to count the number of observations for each combination.

# i.e. One way to do that is to rely on the built-in geom_count():
ggplot(data = diamonds) +
  geom_count(mapping = aes(x = cut, y = color))
# NOTE: The size of each circle in the plot displays how many observations occurred at each combination of values. Covariation will appear as a strong correlation between specific x values and specific y values.

# i.e. Another approach is to compute the count with dplyr, then visualise with geom_tile() and the fill aesthetic:
diamonds %>% 
  count(color, cut) %>%  
  ggplot(mapping = aes(x = color, y = cut)) +
    geom_tile(mapping = aes(fill = n))
# NOTE: If the categorical variables are unordered, you might want to use the seriation package to simultaneously reorder the rows and columns in order to more clearly reveal interesting patterns.
# NOTE: For larger plots, you might want to try the d3heatmap or heatmaply packages, which create interactive plots.

# *****************************************************

# EXERCISES

# 1. How could you rescale the count dataset above to more clearly show the distribution of cut within colour, or colour within cut?

# 2. Use geom_tile() together with dplyr to explore how average flight delays vary by destination and month of year. What makes the plot difficult to read? How could you improve it?

# 3. Why is it slightly better to use aes(x = color, y = cut) rather than aes(x = cut, y = color) in the example above?

# *****************************************************

# 7.5.3 Two continuous variables

