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
# 5. summarise() = Collapse many values down to a single summary
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

glimpse(flights)

# 2. Compare air_time with arr_time - dep_time. What do you expect to see? What do you see? What do you need to do to fix it?

# 3. Compare dep_time, sched_dep_time, and dep_delay. How would you expect those three numbers to be related?

# 4. Find the 10 most delayed flights using a ranking function. How do you want to handle ties? Carefully read the documentation for min_rank().

# 5. What does 1:3 + 1:10 return? Why?

# 6. What trigonometric functions does R provide?

# *****************************************************

# [5.6] Grouped summaries with summarise()






