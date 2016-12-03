#############################################################################
# R for Data Science (Garrett Grolemund, Hadley Wickham)
#############################################################################

# [5] DATA TRANSFORMATION

# [5.1] Prerequisites

library(nycflights13)
library(tidyverse)

# [5.1.2] nycflights13

# To explore the basic data manipulation verbs of dplyr, we’ll use nycflights13::flights. This data frame contains all 336,776 flights that departed from New York City in 2013. The data comes from the US Bureau of Transportation Statistics, and is documented in ?flights.
nycflights13::flights
# NOTE: This is a 'tibble'

# Variable Types:
# > int = integers
# > dbl = doubles
# > chr = characters / strings
# > dttm = date-times
# > lgl = logical (T/F)
# > fctr = factor (categorical)
# > date = dates

# [5.1.3] dplyr basics

# The 6 key dplyr functions that allow you to solve the vast majority of your data manipulation challenges:
# 1. filter() = Pick observations by their values
# 2. arrange() = Reorder the rows
# 3. select() = Pick variables by their names
# 4. mutate() = Create new variables with functions of existing variables
# 5. summarize() = Collapse many values down to a single summary
# 6. group_by() = Changes the scope of each function from operating on the entire dataset to operating on it group-by-group

# All verbs work similarly:
# 1. The first argument is a data frame.
# 2. The subsequent arguments describe what to do with the data frame, using the variable names (without quotes).
# 3. The result is a new data frame.

# *****************************************************

# [5.2] Filter rows with filter()

# filter() allows you to subset observations based on their values.

# i.e. Select all flights on January 1st
(jan1 <- filter(flights, month == 1, day == 1))

# i.e. Select all flights on December 25th
(dec25 <- filter(flights, month == 12, day == 25))

# [5.2.1] Comparisons

# To use filtering effectively, you have to know how to select the observations that you want using the comparison operators. 
# R provides the standard suite: >, >=, <, <=, != (not equal), and == (equal).

# Common problem you might encounter when using ==: floating point numbers!
sqrt(2) ^ 2 == 2 # This is FALSE!
1/49 * 49 == 1 # This is FALSE too!
# NOTE: Computers use finite precision arithmetic (they obviously can’t store an infinite number of digits!) so remember that every number you see is an approximation. 

# Solution for floating point numbers: Instead of relying on ==, use near():
near(sqrt(2) ^ 2,  2) # This is TRUE
near(1/49 * 49, 1) # This is TRUE

# [5.2.2] Logical operators

# y & !x
# x
# x | y
# x & y
# xor(x, y)
# x & !y
# y

# i.e. Select all flights that departed in November or December
(nov_dec <- filter(flights, month == 11 | month == 12))
# NOTE: A useful short-hand for this problem is x %in% y. This will select every row where x is one of the values in y. 

# i.e. We could use %in% to rewrite the code above:
(nov_dec <- filter(flights, month %in% c(11, 12)))

# NOTE: De Morgan's Law
# !(x & y) is the same as (!x | !y)
# !(x | y) is the same as (!x & !y)

# i.e. Select flights that weren't delayed (on arr or dep) by more than 2 hours
filter(flights, !(arr_delay < 120 & dep_delay < 120))
filter(flights, !arr_delay < 120 | !dep_delay < 120)

# [5.2.3] Missing values

# NA represents an unknown value so missing values are “contagious”.
# Almost any operation involving an unknown value will also be unknown:
NA > 5 # NA
10 == NA # NA
NA + 10 # NA
NA / 2 # NA
NA == NA # NA (Huh?)

# Easier to understand if you think of NA as "WE DON'T KNOW"
# Say x = NA is Mary's age and y = NA is Rob's age, then x == y is NA b/c we don't know their ages
x = NA
y = NA
x == y # NA

# If you want to determine if a value is missing, use is.na()
is.na(x) # TRUE

# NOTE: filter() only returns rows which are TRUE, not FALSE or NA
# If you want to preserve missing values, you must ask R explicitly
df <- tibble(x = c(1, NA, 3))
filter(df, x > 1) # NA not included
filter(df, is.na(x) | x > 1) # NA included

# *****************************************************

# EXERCISES

# 1. Find all flights that:
# > Had an arrival delay of 2 or more hours
filter(flights, arr_delay > 120)
# > Flew to Houston (IAH or HOU)
filter(flights, dest %in% c('IAH', 'HOU'))
# > Were operated by United (UA), American (AA), or Delta (DL)
filter(flights, carrier %in% c('UA', 'AA', 'DL'))
# > Departed in summer (July, August, and September)
filter(flights, month %in% c(7, 8, 9))
filter(flights, month >= 7 & month <= 9)
# > Arrived more than 2 hours late, but didn't leave late
filter(flights, arr_delay > 120, dep_delay <= 0)
# > Were delayed by at least an hour, but made up over 30 minutes in flight
filter(flights, dep_delay >= 60, (dep_delay-arr_delay) > 30)
# > Departed between midnight and 6AM (inclusive)
filter(flights, dep_time <= 600 | dep_time == 2400)

# 2. Another useful dplyr filtering helper is between(). What does it do? Can you use it to simplify the code needed to answer the previous challenges?
?between()
filter(flights, between(flights$month, 7, 9))
filter(flights, !between(dep_time, 601, 2359))
# ANSWER: between() is a shortcut for testing 2 inequalities at once: it tests if first argument is >= to second, and <= to its third.

# 3. How many flights have a missing dep_time? What other variables are missing? What might these rows represent?
glimpse(filter(flights, is.na(dep_time)))
summary(flights)
# ANSWER: 8255 flights have a missing dep_time, 8255 have a missing dep_delay, 8713 have a missing arr_time, 9430 have a missing arr_delay, and 9430 have a missing air_time. We can speculate that these are flights that failed to depart or arrive, since a flight that departs normally but is then rerouted will probably have a normally recorded departure but no similar record for it's arrival. However, these could also just be lost data about perfectly normal flights.

# 4. Why is NA ^ 0 not missing? Why is NA | TRUE not missing? Why is FALSE & NA not missing? Can you figure out the general rule? (NA * 0 is a tricky counterexample!)
NA ^ 0 
# ANSWER: Anything to the power of 0 is 1, so even though we don't know original value, we know it's being taken to the zeroth power
NA | TRUE 
# ANSWER: With NA | TRUE, since the | operator returns TRUE if either of the terms are true, the whole expression returns true because the right half returns true.
FALSE & NA
# ANSWER: We know that & returns TRUE when both terms are true. So, for example, TRUE & TRUE evaluates to TRUE. In FALSE & NA, one of the terms is false, so the expression evaluates to FALSE. As does something like FALSE & TRUE.
NA * 0
# ANSWER: NA * 0 could represent more than just 0, because the NA could represent Inf, and Inf * 0 is NaN (Not a Number), rather than NA.

# *****************************************************

# [5.3] Arrange rows with arrange()

# arrange() works similarly to filter() except that instead of selecting rows, it changes their order.
arrange(flights, year, month, day)

# Use desc() to re-order by a column in descending order:
arrange(flights, desc(arr_delay))

# Missing values are always sorted at the end:
df <- tibble(x = c(5, 2, NA))
arrange(df, x)
arrange(df, desc(x))

# *****************************************************

# EXERCISES

# 1. How could you use arrange() to sort all missing values to the start? (Hint: use is.na())
# ANSWER:  
df <- tibble(x = c(5, 2, NA))
arrange(df, desc(is.na(x)))
arrange(df, -(is.na(x)))

# 2. Sort flights to find the most delayed flights. Find the flights that left earliest.
# ANSWER:
arrange(flights, desc(dep_delay), desc(arr_delay))
arrange(flights, dep_delay)

# 3. Sort flights to find the fastest flights
# ANSWER:
arrange(flights, (arr_time - dep_time), air_time)

# 4. Which flights travelled the longest? Which travelled the shortest?
arrange(flights, desc(distance))
arrange(flights, distance)

# *****************************************************

# [5.4] Select columns with select()

# select() allows you to rapidly zoom in on a useful subset using operations based on the names of the variables.

# Select columns by name:
select(flights, year, month, day)

# Select all columns between year and day (inclusive):
select(flights, year:day)

# Select all columns except those from year to day (inclusive)
select(flights, -(year:day))

# Helper Functions:
# > starts_with('abc'): matches names that begin with 'abc'
select(flights, starts_with('dep'))
# > ends_with('xyz'): matches names that end with 'xyz'
select(flights, ends_with('time'))
# > contains('ijk'): matches names that contain 'ijk'
select(flights, contains('arr'))
# > matches('(.)\\1'): selects variables that match a REGEX.
select(flights, matches('(r)\\1')) # selects repeated 'r'
# > num_range('x', 1:3): matches x1, x2, and x3
select(flights, num_range('x', 1:3))

?select

# select() can be used to rename variables, but it’s rarely useful because it drops all of the variables not explicitly mentioned. Instead, use rename(), which is a variant of select() that keeps all the variables that aren’t explicitly mentioned
rename(flights, tail_name = tailnum)
?dplyr::rename

# Another option is to use select() in conjunction with the everything() helper. This is useful if you have a handful of variables you’d like to move to the start of the data frame.
select(flights, time_hour, air_time, everything())
?dplyr::everything

# *****************************************************

# EXERCISES

# 1. Brainstorm as many ways as possible to select dep_time, dep_delay, arr_time, and arr_delay from flights
# ANSWER:
select(flights, dep_time, dep_delay, arr_time, arr_delay)
select(flights, starts_with('dep_'), starts_with('arr_'))
select(flights, ends_with('_time'), ends_with('_delay'), -contains('sched'), -contains('air'))

# 2. What happens if you include the name of a variable multiple times in a select() call?
# ANSWER:
select(flights, dep_time, dep_time, dep_time)
# You only get that variable once.

# 3. What does the one_of() function do? Why might it be helpful in conjunction with this vector?
vars <- c('year', 'month', 'day', 'dep_delay', 'arr_delay')
# ANSWER:
select(flights, one_of(vars))
# It returns all of the variables you asked for that are stored in the vector

# 4. Does the result of running the following code surprise you? How do you select helpers deal with case by default? How can you change that default?
select(flights, contains('TIME'))
# ANSWER:
select(flights, contains('TIME', ignore.case = FALSE))
# The default helper functions are insensitive to case. This can be changed by setting ignore.case = FALSE

# *****************************************************

# [5.5] Add new variables with mutate()

# mutate() always adds new columns at the end of your dataset so we’ll start by creating a narrower dataset so we can see the new variables. 
flights_sml <- select(flights,
  year:day,
  ends_with('delay'),
  distance,
  air_time
)
mutate(flights_sml,
  gain = arr_delay - dep_delay,
  speed = distance / air_time * 60
)

# Note that you can refer to columns that you’ve just created:
mutate(flights_sml,
  gain = arr_delay - dep_delay,
  hours = air_time / 60,
  gain_per_hour = gain / hours
)

# If you only want to keep the new variables, use transmute():
transmute(flights,
  gain = arr_delay - dep_delay,
  hours = air_time / 60,
  gain_per_hour = gain / hours
)

# [5.5.1] Useful creation functions

# There are many functions for creating new variables that you can use with mutate(). The key property is that "the function MUST BE vectorized".

# > Arithmetic operators: +, -, *, /, ^ ==> these are vectorized & useful with aggregate functions (i.e. sum, mean)

# > Modular arithmetic: %/% (integer division) and %% (remainder) ==> handy tool because it allows you to break integers up into pieces
# i.e. in the flights dataset, you can compute hour and minute from dep_time:
transmute(flights,
  dep_time,
  hour = dep_time %/% 100,
  minute = dep_time %% 100
)

# > Logs: log(), log2(), log10() ==> logarithms are an incredibly useful tranformation for dealing with data that ranges across multiple orders of magnitude.
?log()
?log2()
?log10()
# NOTE: They also convert multiplicative relationships to additive, a feature we’ll come back to in modelling.
# NOTE: All else being equal, I recommend using log2() because it’s easy to interpret: a difference of 1 on the log scale corresponds to doubling on the original scale and a difference of -1 corresponds to halving.

# > Offsets: lead() and lag() ==> allow you to refer to leading or lagging values. This allows you to compute running difference (i.e. x - lag(x)) or find when values change (i.e. x != lag(x)).
?lead()
?lag()
# NOTE: They are most useful in conjunction with group_by().
(x <- 1:10)
lag(x)
lead(x)

# > Cumulative and rolling aggregates: functions for running sums, products, mins, and maxes (i.e. cumsum(), cumprod(), cummin(), cummax()) and dplyr::cummean() for cumulative means.
# NOTE: If you need rolling aggregates (i.e. a sum computed over a rolling window), try RcppRoll package
x
cumsum(x)
cummean(x)
library(help = 'RcppRoll')

# > Logical comparisons: <. <=, >. >=, !=

# > Ranking: there are many ranking functions, but you should start with min_rank(). It does the most usual type of ranking (i.e. 1st, 2nd, ...). This default gives smallest values the small ranks.
# NOTE: Use desc(x) to give the largest values the smallest ranks
y <- c(1, 2, 2, NA, 3, 4)
min_rank(y)
min_rank(desc(y))
# NOTE: If min_rank() doesn't do what you need, look for variants:
row_number(y)
dense_rank(y)
percent_rank(y)
cume_dist(y)

# *****************************************************

# EXERCISES

# 1. Currently dep_time and sched_dep_time are convenient to look at, but hard to compute with because they’re not really continuous numbers. Convert them to a more convenient representation of number of minutes since midnight.
# ANSWER:
# explore dep_time and sched_dep_time
summary(flights$dep_time)
summary(flights$sched_dep_time)
# visualize dep_time and sched_dep_time
ggplot(flights) + geom_histogram(aes(x = dep_time), binwidth = 10)
ggplot(flights) + geom_histogram(aes(x = sched_dep_time), binwidth = 10)
# mutate dep_time and sched_dep_time to represent 'minutes since midnight'
flights_conv <- mutate(flights,
  dep_time_conv = (dep_time %/% 100) * 60 + (dep_time %% 100),
  sched_dep_time_conv = (sched_dep_time %/% 100) * 60 + (sched_dep_time %% 100)) %>% 
  select(dep_time, dep_time_conv, sched_dep_time, sched_dep_time_conv)
# explore flights_conv
summary(flights_conv)
ggplot(flights_conv) + geom_histogram(mapping = aes(x = dep_time_conv), binwidth = 10)
ggplot(flights_conv) + geom_histogram(mapping = aes(x = sched_dep_time_conv), binwidth = 10)

# 2. Compare air_time with arr_time - dep_time. What do you expect to see? What do you see? What do you need to do to fix it?
# ANSWER:
# calculate air_time = arr_time - dep_time
mutate(flights,
  air_time_calc = arr_time - dep_time
) %>% select(arr_time, dep_time, air_time, air_time_calc)
# NOTE: air_time != air_time_calc b/c dep_time, sched_dep_time, arr_time, sched_arr_time are clock-format and need to be converted to minutes-from-midnight format.
mutate(flights,
  dep_time_conv = (dep_time %/% 100) * 60 + (dep_time %% 100),
  arr_time_conv = (arr_time %/% 100) * 60 + (arr_time %% 100),
  sched_dep_time_conv = (sched_dep_time %/% 100) * 60 + (sched_dep_time %% 100),
  sched_arr_time_conv = (sched_arr_time %/% 100) * 60 + (sched_arr_time %% 100),
  air_time_calc = (arr_time_conv - dep_time_conv) %% (60*24) - air_time
) %>% select(arr_time, dep_time, air_time, arr_time_conv, dep_time_conv, air_time_calc)
# NOTE: arr_time - dep_time can be very different from air_time.

# 3. Compare dep_time, sched_dep_time, and dep_delay. How would you expect those three numbers to be related?
# ANSWER:
# explore dep_time, sched_dep_time, and dep_delay
flights %>% select(dep_time, sched_dep_time, dep_delay)
# NOTE: At first glance it seems as though the 3 variables are related by following function: dep_time - sched_dep_time = dep_delay
# calculate dep_delay_calc and dep_delay_error to make comparison with dep_delay
flights_dep <- flights %>% mutate(
  dep_time_conv = (dep_time %/% 100) * 60 + (dep_time %% 100),
  sched_dep_time_conv = (sched_dep_time %/% 100) * 60 + (sched_dep_time %% 100),
  dep_delay_calc = dep_time_conv - sched_dep_time_conv,
  dep_delay_error = dep_delay_calc - dep_delay
) %>% select(dep_time_conv, sched_dep_time_conv, dep_delay, dep_delay_calc, dep_delay_error)
# visualize error
ggplot(flights_dep) + geom_histogram(aes(dep_delay_error))
# peek at error values != 0
flights_dep %>% filter(dep_delay_error != 0)
# NOTE: only 1197 out of 336776 (0.36%) observations have incorrect calculation of dep_delay

# 4. Find the 10 most delayed flights using a ranking function. How do you want to handle ties? Carefully read the documentation for min_rank().
# ANSWER:
# mutate dep_delay from clock-format to minutes-from-midnight format
flights %>% glimpse()
flights_10_most_delayed <- flights %>% mutate(
  dep_time_conv = (dep_time %/% 100) * 60 + (dep_time %% 100),
  sched_dep_time_conv = (sched_dep_time %/% 100) * 60 + (sched_dep_time %% 100),
  dep_delay_calc = dep_time_conv - sched_dep_time_conv
)
# There aren't any ties in the top 10 most delayed flights for departure and arrival, but if there was a tie for 10th place, then min_rank could produce more than 10 results
flights_10_most_delayed %>% filter(min_rank(desc(dep_delay_calc)) <= 10)
flights_10_most_delayed %>% top_n(n = 10, wt = dep_delay_calc) %>% select(dep_delay_calc, everything())

# 5. What does 1:3 + 1:10 return? Why?
# ANSWER:
1:2 + 1:10
# NOTE: It prints a vector of length 10. Also, we get a warning because 10 is not divisible by 3.

# 6. What trigonometric functions does R provide?
# ANSWER:
?Trig
# NOTE: R provides the following trig functions
# cos(x)
# sin(x)
# tan(x)
# acos(x)
# asin(x)
# atan(x)
# atan2(y, x)
# cospi(x)
# sinpi(x)
# tanpi(x)

# *****************************************************

# [5.6] Grouped summaries with summarize()

# summarize() collapses a data frame to a single row:
summarize(flights, delay = mean(dep_delay, na.rm = TRUE))

# summarize() is much more useful when we pair it with group_by()
# i.e. if we applied the same code to a data frame grouped by date, we get the average delay per date:
by_day <- group_by(flights, year, month, day)
summarize(by_day, delay = mean(dep_delay, na.rm = TRUE))
# NOTE: Together group_by() and summarize() provide 'grouped summaries'

# [5.6.1] Combining multiple operations with the pipes

# i.e. Exploring the relationship between the distance and average delay for each location:
by_dest <- group_by(flights, dest)
delay <- summarize(by_dest,
  count = n(),
  dist = mean(distance, na.rm = TRUE),
  delay = mean(arr_delay, na.rm = TRUE)
)
delay <- filter(delay, count > 20, dest != "HNL")
# visualize relationship
ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)
# NOTE: It looks like delays increase with distance up to ~750 miles 
# and then decrease. Maybe as flights get longer there's more 
# ability to make up delays in the air?

# NOTE: It took 3 steps to prepare this data:
# 1. Group flights by destination.
# 2. Summarise to compute distance, average delay, and number of flights.
# 3. Filter to remove noisy points and Honolulu airport, which is almost twice as far away as the next closest airport.
# This can be tedious! SOLUTION = PIPES! (%>%)

# Here is the same problem using pipes:
delay <- flights %>%
  group_by(dest) %>%
  summarize(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>% 
  filter(count > 20, dest != 'HNL')
# NOTE: Focuses on transformations, rather than what’s being transformed.
# NOTE: A good way to pronounce %>% when reading code is “then”.
# NOTE: Working with the pipe is one of the key criteria for belonging to the tidyverse. 
# NOTE: Exception is ggplot2 (it was written before the pipe was discovered.)

# [5.6.2] Missing values

# Not setting na.rm = TRUE gives us a lot of missing values (NAs)
flights %>% 
  group_by(year, month, day) %>% 
  summarize(mean = mean(dep_delay))
# NOTE: This is b/c aggregation functions obey the usual rule of missing values: if there’s any missing value in the input, the output will be a missing value.

# Luckily, all aggregation functions have na.rm option
flights %>% 
  group_by(year, month, day) %>% 
  summarize(mean = mean(dep_delay, na.rm = TRUE))

# In this case, we could remove the cancelled flights, which are the missing values
not_cancelled <- flights %>%
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>% 
  group_by(year, month, day) %>%
  summarize(mean = mean(dep_delay))

# [5.6.3] Counts

# NOTE: Whenever you do any aggregation, it’s always a good idea to include either a count (n()), or a count of non-missing values (sum(!is.na(x))). That way you can check that you’re not drawing conclusions based on very small amounts of data.
# i.e. examine planes (identified by tail number) that have the highest average delays:
delays <- not_cancelled %>%
  group_by(tailnum) %>%
  summarize(
    delay = mean(arr_delay)
  )

ggplot(data = delays, mapping = aes(x = delay)) + 
  geom_freqpoly(binwidth = 10)
# Based on this, there are some planes that have an average delay of 5 hours! (300 minutes)

# We can get more insight if we draw a scatterplot of number of flights vs. average delay:
delays <- not_cancelled %>%
  group_by(tailnum) %>%
  summarize(
    delay = mean(arr_delay),
    n = n()
  )

ggplot(data = delays, mapping = aes(x = n, y = delay)) + 
  geom_point(alpha = 1/10)
# There is much greater variation in average delay when there are few flights!
# NOTE: Whenever you plot a mean (or other summary) vs. group size, yo'ull see that the variation decreases as the sample size increases.
# NOTE: When looking at this sort of plot, it helps to filter out the groups with smallest number of observations, so you can see more of the pattern and less of the extreme variation in the smallest groups.
delays %>%
  filter(n > 25) %>%
  ggplot(mapping = aes(x = n, y = delay)) + 
    geom_point(alpha = 1/10)
# TIP: CMD + SHIFT + P to run previous chunk of code

# Now, let's look at how the average performance of batters in baseball is related to the number of times they're at bat.
# We can use the 'Lahman' package to compute the batting average (number of hits / number of attempts) of every major league baseball player.
# When you plot the skill of the batter (ba) against the number of opportunities to hit the ball (ab), you see 2 patterns:
# 1. Just like with flight delays, the variation in our aggregate decreases as we get more data points
# 2. There's a positive correlation between skill (ba) and opportunities to hit the ball (ab). This is because teams control who gets to play, and they'll obviouslypick their best players.
require(Lahman)
batting <- as_tibble(Lahman::Batting)

batters <- batting %>% 
  group_by(playerID) %>%
  summarize(
    ba = sum(H, na.rm = TRUE) / sum(AB, na.rum = TRUE),
    ab = sum(AB, na.rm = TRUE)
  )

batters %>% 
  filter(ab > 100) %>%
  ggplot(mapping = aes(x = ab, y = ba)) +
    geom_point() +
    geom_smooth(se = FALSE)

# This also has important implications for ranking. If you naively sort on desc(ba), the people with the best batting averages are clearly lucky, not skilled:
batters %>%
  arrange(desc(ba))

# You can find a good explanation of this problem at http://varianceexplained.org/r/empirical_bayes_baseball/ and http://www.evanmiller.org/how-not-to-sort-by-average-rating.html.

# [5.6.4] Useful summary functions

# Measures of location:
# > means(x): sum divided by the length
# > median(x): where 50% of x is above it, and 50% is below it

# Its sometimes useful to combine aggregation with local subsetting.
not_cancelled %>% 
  group_by(year, month, day) %>%
  summarize(
    avg_delay1 = mean(arr_delay), # the average delay
    avg_delay2 = mean(arr_delay[arr_delay > 0]) # the average positive delay
  )

# Measures of spread:
# > sd(x): mean squared deviation, or standard deviation, is the standard measure of spread
# > IQR(x): interquartile range (more useful if you have outliers)
# > mad(x): median absolute deviation (more useful if you have outliers)

# i.e. Why is distance to some destinations more variable than to others?
not_cancelled %>%
  group_by(dest) %>%
  summarize(distance_sd = sd(distance)) %>%
  arrange(desc(distance_sd))

# Measures of rank:
# > min(x): minimum value
# > quantile(x, 0.25): generalization of the median
# > max(x): maximum value

# i.e. When do the first and last flights leave each day?
not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(
    first = min(dep_time),
    last = max(dep_time)
  )

# Measures of position:
# > first(x): element at first position
# > nth(x, 2): element at nth position
# > last(x): element at last position
# NOTE: These work similar to x[1], x[2], and x[length(x)], but also let you set a default value if that position does not exist

# i.e. Find the first and last flight departure for each day:
not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(
    first_dep = first(dep_time),
    last_dep = last(dep_time)
  )

# These functions are complementary to filtering on ranks. Filtering gives you all variables, with each observation in a separate row:
not_cancelled %>%
  group_by(year, month, day) %>%
  mutate(r = min_rank(desc(dep_time))) %>%
  filter(r %in% range(r))

# Counts: 
# > n(): takes no arguments and returns the size of the current group
# > sum(!is.na(x)): count the number of non-missing values
# > n_distinct(x): count the number of distinct (unique) values
# > count(x): count the nubmer of values (optionally also takes weight variable, wt)

# i.e. Which destinations have the most carriers?
not_cancelled %>%
  group_by(dest) %>%
  summarize(carriers = n_distinct(carrier)) %>%
  arrange(desc(carriers))

# i.e. How many flights belong to each destination?
not_cancelled %>%
  count(dest)

# i.e. What is the total number of miles a plane flew?
not_cancelled %>%
  count(tailnum, wt = distance)

# Counts and proportions of logical values (i.e. sum(x > 10), mean(y == 0)).
# When used with numeric functions, TRUE is converted 1 and FALSE to 0.
# NOTE: This makes sum() and mean() very useful:
# > sum(x): gives the number of TRUEs in x
# > mean(x): gives the proportion

# i.e. How many flights left before 5AM? (these are usually delayed flights from the previous day)
not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(n_early = sum(dep_time < 500))

# i.e. What proportion of flights are delayed by more than an hour?
not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(hour_perc = mean(arr_delay > 60))

# [5.6.5] Grouping by multiple variables

# When you group by multiple variables, each summary peels off one level of the grouping, making it progressively easier to roll up a dataset:
daily <- group_by(flights, year, month, day)
(per_day <- summarize(daily, flights = n()))
(per_month <- summarize(per_day, flights = sum(flights)))
(per_year <- summarize(per_month, flights = sum(flights)))
# NOTE: Be careful when progressively rolling up summaries: it’s OK for sums and counts, but you need to think about weighting means and variances, and it’s not possible to do it exactly for rank-based statistics like the median. In other words, the sum of groupwise sums is the overall sum, but the median of groupwise medians is not the overall median.

# [5.6.6] Ungrouping

# If you need to remove grouping, and return to operations on ungrouped data, use ungroup():
daily %>%
  ungroup() %>% # no longer grouped by date
  summarize(flights = n()) # all flights

# *****************************************************

# EXERCISES

# 1. Brainstorm at least 5 different ways to assess the typical delay characteristics of a group of flights. Consider the following scenarios:
# > A flight is 15 minutes early 50% of the time, and 15 minutes late 50% of the time.
# > A flight is always 10 minutes late.
# > A flight is 30 minutes early 50% of the time, and 30 minutes late 50% of the time.
# > 99% of the time a flight is on time. 1% of the time it’s 2 hours late.
# Which is more important: arrival delay or departure delay?

# TODO ANSWER: This question is a bit vague. Give it a shot and come back to this in the future.
not_cancelled %>%
  group_by(tailnum) %>%
  summarize(
    dep_delays = median(dep_delay),
    arr_delays = median(arr_delay)
  ) %>% filter(dep_delays == 15, arr_delays == 15)

not_cancelled %>%
  group_by(tailnum) %>%
  filter(dep_delay == 10, arr_delay == 10)

not_cancelled %>%
  group_by(tailnum) %>%
  summarize(
    dep_delays = median(dep_delay),
    arr_delays = median(arr_delay)
  ) %>% filter(dep_delays == 30, arr_delays == 30)

# 2. Come up with another approach that will give you the same output as not_cancelled %>% count(dest) and not_cancelled %>% count(tailnum, wt = distance) (without using count()).
not_cancelled %>% 
  count(dest)
not_cancelled %>% 
  count(tailnum, wt = distance)

# ANSWER:
not_cancelled %>% 
  group_by(dest) %>% 
  summarize(n = n())
not_cancelled %>% 
  group_by(tailnum) %>% 
  summarize(n = sum(distance))

# 3. Our definition of cancelled flights (is.na(dep_delay) | is.na(arr_delay) ) is slightly suboptimal. Why? Which is the most important column?

# ANSWER: This is slightly suboptimal because we only need to indicate is.na(dep_delay), since a flight that did not depart, obviously did not arrive. As a side-note, just to make sure these aren't data entry errors, its important to look over all temporal variables (i.e. dep_time, sched_dep_time, arr_time, sched_arr_time, arr_delay, air_time) to make sure this is the right approach for classifying cancelled flights.

# 4. Look at the number of cancelled flights per day. Is there a pattern? Is the proportion of cancelled flights related to the average delay?

# ANSWER: 
# Summarize cancelled, n, avg_dep_delay, and avg_arr_delay, grouped by date
prop_cancelled_vs_avg_delay <- flights %>%
  group_by(year, month, day) %>%
  summarize(
    cancelled = sum(is.na(dep_delay)),
    n = n(),
    avg_dep_delay = mean(dep_delay, na.rm = TRUE),
    avg_arr_delay = mean(arr_delay, na.rm = TRUE)
  )
# Visualize relationship between proportion of cancelled to average delay
prop_cancelled_vs_avg_delay %>% 
  ggplot(., aes(x = cancelled / n)) + 
  geom_point(aes(y = avg_dep_delay), color = 'red', alpha = 1/5) + 
  geom_point(aes(y = avg_arr_delay), color = 'blue', alpha = 1/5) + 
  xlab('proportion of cancelled flights') + 
  ylab('average delay (in minutes)')
# The visualization reveals to us that there is not that strong of a relationship between proportion of cancelled flights and average delay. However, as the average delay increases, it slightly increases the chance of flight getting cancelled. This also implies that there is more to the story of cancelled flights than just delays

# SIDE NOTE ON OUTLIERS: Explanation for high cancelled flight count on Feb 8-9, 2013: http://www.nytimes.com/2013/02/09/nyregion/major-snowstorm-arriving-in-northeast.html?_r=1&

# 5. Which carrier has the worst delays? Challenge: can you disentangle the effects of bad airports vs. bad carriers? Why/why not? (Hint: think about flights %>% group_by(carrier, dest) %>% summarise(n()))

# ANSWER:
flights %>%
  group_by(carrier, dest) %>%
  summarize(
    n = n()
  ) %>% arrange(desc(n))

flights %>%
  group_by(carrier, dest) %>%
  summarize(
    n = n(),
    avg_dep_delay = mean(dep_delay, na.rm = TRUE)
  ) %>% filter(n > 100) %>%
  arrange(desc(avg_dep_delay)) %>%
  ggplot(.) + geom_bar(aes(x = as.factor(carrier)))

# 6. For each plane, count the number of flights before the first delay of greater than 1 hour.

# ANSWER:

# 7. What does the sort argument to count() do. When might you use it?

# ANSWER:


