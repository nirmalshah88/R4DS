#############################################################################
# R for Data Science (Garrett Grolemund, Hadley Wickham)
#############################################################################

browseURL("http://r4ds.had.co.nz/workflow-basics.html")

# [4] WORKFLOW: BASICS

# [4.1] Coding basics

# R is a calculator:
1 / 200 * 30
(59 + 73 + 2) / 3
sin(pi / 2)

# You can create objects using <-:
x <- 3 * 4 # read as "object name gets value" in your head
# RStudio keyboard shortcut: Alt + Minus

# [4.2] What's in a name? (Naming convention)
i_use_snake_case
otherPeopleUseCamelCase
some.people.use.periods
And_aFew.People_RENOUNCEconvention

# Inspect object by typing its name:
x

# Make another assignment:
this_is_a_really_long_name <- 2.5
# In RStduio, try typing "this" and press TAB for auto completion

# [4.3] Calling functions

# R has a large collection of built-in function that are called like so:
function_name(arg1 = val1, arg2 = val2, ...)

# Accessing help:
?seq
seq # Press F1 after typing in "q"

# Type this code and notice similar assistance help with the paired quotation marks
x <- "hello world"
# NOTE: Quotation marks and parentheses must always come in a pair. RStudio does its best to help you, but it’s still possible to mess up and end up with a mismatch. If this happens, R will show you the continuation character “+”

# The "+" character in console:
# The + tells you that R is waiting for more input; it doesn’t think you’re done yet. Usually that means you’ve forgotten either a " or a ).

# Shortcut for assigning and printing to screen: 
(y <- seq(1, 10, length.out = 5)) # add parentheses

# *****************************************************

# EXERCISES

# 1. Why does this code not work?
my_variable <- 10
my_varıable
# ANSWER: TYPO!

# 2. Tweak each of the following R commands so that they run correctly:
library(tidyverse)
ggplot(dota = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))
fliter(mpg, cyl = 8)
filter(diamond, carat > 3)

# ANSWER:
library(tidyverse)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))
filter(mpg, cyl == 8)
filter(diamonds, carat > 3)

# 3. Press Alt + Shift + K. What happens? How can you get to the same place using the menus?

# ANSWER: List of keyboard shortcuts. Can also be found under 'Tools'.
