#############################################################################
# R for Data Science (Garrett Grolemund, Hadley Wickham)
#############################################################################

# [10] TIBBLES

browseURL('http://r4ds.had.co.nz/tibbles.html')

# [10.1] Introduction

# Tibbles are a modern take on data frames

# Tibbles are data frames, but they tweak some older behaviours to make life a little easier. R is an old language, and some things that were useful 10 or 20 years ago now get in your way. It’s difficult to change base R without breaking existing code, so most innovation occurs in packages.

vignette("tibble")

# [10.1.1] Prerequisites

library(tidyverse)

# [10.2] Creating tibbles

# Tibbles are one of the unifying features of the tidyverse. Most other R packages use regular data frames, so you might want to coerce a data frame to a tibble.
as_tibble(iris)

# You can create a new tibble from individual vectors with tibble():
tibble(
  x = 1:100,
  y = 1,
  z = x ^ 2 + y
)
# NOTE: Unlike using data.frame(), tibble() never changes the type of the inputs (i.e. never converts strings to factors) or the names of variables and never creates row names.


# It’s possible for a tibble to have column names that are not valid R variable names, aka non-syntactic names.
# i.e. These column names might not start with a letter, or might contain unusual characters like a space. To refer to these variables, you need to surround them with backticks, `:
tb <- tibble(
  `:)` = "smile", 
  ` ` = "space",
  `2000` = "number"
)
tb

# [10.3] Tibbles vs. data.frame

# 2 main differences between tibbles and data.frames: printing and subsetting

# [10.3.1] Printing

# Tibbles have a refined print method that shows only the first 10 rows, and all the columns that fit on screen. This makes it much easier to work with large data. In addition to its name, each column reports its type, a nice feature borrowed from str():
tibble(
  a = lubridate::now() + runif(1e3) * 86400,
  b = lubridate::today() + runif(1e3) * 30,
  c = 1:1e3,
  d = runif(1e3),
  e = sample(letters, 1e3, replace = TRUE)
)
# NOTE: Tibbles are designed so that you don’t accidentally overwhelm your console when you print large data frames.

# But sometimes you need more output than the default display. There are a few options that can help.

# 1. First, you can explicitly print() the data frame and control the number of rows (n) and the width of the display. width = Inf will display all columns:
# i.e.
nycflights13::flights %>% 
  print(n = 10, width = Inf)

# 2. You can also control the default print behaviour by setting options:
# * options(tibble.print_max = n, tibble.print_min = m): if more than m rows, print only n rows. Use options(dplyr.print_min = Inf) to always show all rows.
# * Use options(tibble.width = Inf) to always print all columns, regardless of the width of the screen.

# 3. A final option is to use RStudio’s built-in data viewer to get a scrollable view of the complete dataset. This is also often useful at the end of a long chain of manipulations.
# i.e.
nycflights13::flights %>% 
  View()

# [10.3.2] Subsetting

# If you want to pull out a single variable, you need some new tools, $ and [[. [[ can extract by name or position; $ only extracts by name but is a little less typing.
# i.e.
df <- tibble(
  x = runif(5),
  y = rnorm(5)
)