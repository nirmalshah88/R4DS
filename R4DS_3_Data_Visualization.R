#############################################################################
# R for Data Science (Garrett Grolemund, Hadley Wickham)
#############################################################################

browseURL("http://r4ds.had.co.nz/data-visualization.html")

# [3] DATA VISUALIZATION

library(tidyverse)

mpg

# Creating a ggplot
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))

# Graphing template
# ggplot(data = <DATA>) +
#  <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))

# *****************************************************

# EXERCISES 

# 1. Run ggplot(data = mpg) what do you see?
ggplot(data = mpg)
# ANSWER: blank gray canvas

# 2. How many rows are in mtcars? How many columns?
nrow(mtcars)
ncol(mtcars)
# ANSWER: mtcars contains 32 rows and 11 columns

# 3. What does the drv variable describe? Read the help for ?mpg to find out.
?mpg
# ANSWER: drv is a categorical variable which represents either front-wheel, rear-wheel, or 4-wheel drive

# 4. Make a scatterplot of hwy vs cyl.
# ANSWER:
ggplot(data = mpg) +
  geom_point(mapping = aes(x = hwy, y = cyl))

# 5. What happens if you make a scatterplot of class vs drv. Why is the plot not useful?
ggplot(data = mpg) +
  geom_point(mapping = aes(x = class, y = drv))
# ANSWER: plotting a categorical variable against another categorical variable will result in a scatter plot that shows only a single point for each combination of those variables. Hence, it does not show you the distribution of observations for each combination, but instead just shows you the possible combinations.

# *****************************************************

# [3.3] Aesthetic mappings

# Creating a ggplot with color mapping
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class))

# Creating a ggplot with size mapping (NOTE: not recommended for discrete variables)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, size = class))
#> Warning message: Using size for a discrete variable is not advised.

# Creating a ggplot with alpha mapping
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))

# Creating a ggplot with shape mapping (NOTE: Not recommended for 6+ discrete levels)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))
#> Warning messages:
#   1: The shape palette can deal with a maximum of 6 discrete values because more than 6
# becomes difficult to discriminate; you have 7. Consider specifying shapes manually
# if you must have them. 
# 2: Removed 62 rows containing missing values (geom_point). 
# 3: The shape palette can deal with a maximum of 6 discrete values because more than 6
# becomes difficult to discriminate; you have 7. Consider specifying shapes manually
# if you must have them.

# Creating a ggplot by setting aesthetics to geom manually (Note: Here, the color doesn’t convey information about a variable, but only changes the appearance of the plot.)
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), color = 'blue')

# *****************************************************

# EXERCISES

# 1. What’s gone wrong with this code? Why are the points not blue?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = "blue"))
# ANSWER: Here you are setting color within aesthetic function, which is meant for mapping aesthetics at variable level, not at the geom level.

# 2. Which variables in mpg are categorical? Which variables are continuous? (Hint: type ?mpg to read the documentation for the dataset). How can you see this information when you run mpg?
?mpg
# ANSWER: Categorical variables in R data frames are refered to as factors. In this case, however, when running mpg, the data frame does not identify which variables are factors (it would show <fct> under the variable name). Instead, basic statistics and observation is required to make the distinction between categorical and non-cateogrical. In this case, the categorical variables are: manufacturer, trans, drv, fl, class.

# 3. Map a continuous variable to color, size, and shape. How do these aesthetics behave differently for categorical vs. continuous variables?
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = cty))
# ANSWER: For continuous variable color aesthetics, the observations are mapped to a  gradient of colors.
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, size = cty))
# ANSWER: For continuous variable size aesthetics, the observations are mapped to auto-generated bins with intervals of 5.
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, shape = cty))
#> Error: A continuous variable can not be mapped to shape
# ANSWER: Cannot map continuous variable to shape

# 4. What happens if you map the same variable to multiple aesthetics?
# 4.1 Mapping Multiple Aesthetics
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = cty, size = cty, alpha = cty))
# 4.2 Mapping Same Continous Variables
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = displ, color = displ))
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = displ, shape = displ))
#> Error: A continuous variable can not be mapped to shape
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = displ, size = displ))
# 4.3 Mapping Same Categorical Variables
ggplot(data = mpg) +
  geom_point(mapping = aes(x = drv, y = drv, color = drv))
ggplot(data = mpg) +
  geom_point(mapping = aes(x = drv, y = drv, shape = drv))
ggplot(data = mpg) +
  geom_point(mapping = aes(x = drv, y = drv, size = drv)) 
#> Warning message: Using size for a discrete variable is not advised.
# ANSWER: Mapping the same variable to multiple aesthetics will use a combination of those aesthetics in the visualization.

# 5. What does the stroke aesthetic do? What shapes does it work with? (Hint: use ?geom_point)
?geom_point
ggplot(data = mtcars, aes(x = wt, y = mpg)) +
  geom_point(shape = 21, colour = "black", fill = "white", size = 5, stroke = 5)
# ANSWER: For shapes that have a border (like 21), you can colour the inside and outside separately. Use the stroke aesthetic to modify the width of the border.

# 6. What happens if you map an aesthetic to something other than a variable name, like aes(colour = displ < 5)?
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = displ < 5))
# ANSWER: When using conditional statements within variable aesthetics, ggplot uses 2 generic colors to split the data between the TRUE and FALSE values based on the condition.

# *****************************************************

# [3.5] Facets

# To facet your plot by a single variable, use facet_wrap()
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)

# To facet your plot on the combination of two variables, use facet_grid()
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl)

# *****************************************************

# EXERCISES

# 1. What happens if you facet on a continuous variable?
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ cty)
# ANSWER: Facetting on a continuous variable results in way too many subplots to make sense of. It becomes cluttered, making it increasingly difficult to interpret the visualization.

# 2. What do the empty cells in plot with facet_grid(drv ~ cyl) mean? How do they relate to this plot?
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl)
# ANSWER: The empty cells represent that there are no observations with that combination of drive-train and cylinder size. For instance, it is rare to find 5 cylinder cars (i.e. Volkswagen Jetta and Beetle are exceptions). Moreover, There are only 6-cylinder and 8-cylinder engines for cars with rear-wheel drive since these are generally larger vehicles.

# 3. What plots does the following code make? What does . do?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)
# ANSWER: Both plots show the relationship between highway miles/gallon (hwy) and engine displacement in liters (displ), however the main difference is that the first one subsets the plot into 3 subplots (columns)  for 4-, rear-, and front-wheel drive, while the second one subsets the plot into 4 subplots (rows) for 4, 5, 6, and 8 cylinder vehicles. The '.' operator allows you to facet either the columns (left ~ .) or rows (. ~ right), but you must specify at least one.

# 4. Take the first faceted plot in this section (below). What are the advantages to using faceting instead of the colour aesthetic? What are the disadvantages? How might the balance change if you had a larger dataset?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)
# ANSWER: There are times when we wish to look at all of the various types of vehicles in one plot to compare their relationship against one another - accomplished by using the color aesthetic; however, at other times we wish to look at the various types of vehicles separately - accomplished by using facet_wrap. The advantage of fact_wrap is that you can quickly isolate 2seaters by focusing on the first faceted plot, while in the colored plot, you have to check the legend and try to spot the right colored dots, which in some cases can be very tedious or even error-prone.

# 5. Read ?facet_wrap. What does nrow do? What does ncol do? What other options control the layout of the individual panels? Why doesn’t facet_grid() have nrow and ncol variables?
?facet_wrap
?facet_grid
# NOTE: You can facet by multiple variables using '+':
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  facet_wrap(~ cyl + drv)
# NOTE: Or use a character vector:
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  facet_wrap(c("cyl", "drv"))
# NOTE: Use the `labeller` option to control how labels are printed:
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  facet_wrap(c("cyl", "drv"), labeller = "label_both")
# NOTE: To change the order in which the panels appear, change the levels
# of the underlying factor.
mpg$class2 <- reorder(mpg$class, mpg$displ)
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  facet_wrap(~class2)
mpg$class2 <- NULL
# NOTE: By default, the same scales are used for all panels. You can allow
# scales to vary across the panels with the `scales` argument.
# Free scales make it easier to see patterns within each panel, but
# harder to compare across panels.
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  facet_wrap(~class, scales = "free")
# ANSWER: nrow and ncol refer to the number of rows and columns, respectively. facet_grid() does not allow for nrow and ncol input because it is a fixed grid based on the levels of 2 variables; however, for facet_wrap(), we can specify nrow and ncol because plot is only facetted on single dimension.

# 6. When using facet_grid() you should usually put the variable with more unique levels in the columns. Why?
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl) # recommended
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(cyl ~ drv) # not recommended
# ANSWER: Putting the categorical variable with more unique levels in the column helps in terms of readability since most tabular data consists of fewer columns than rows.

# *****************************************************

# [3.6] Geometric Objects

# A geom is the geometrical object that a plot uses to represent data.
# To change the geom in your plot, change the geom function that you add to ggplot(). For instance, to make the plots above, you can use this code:
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy))

# Every geom function in ggplot2 takes a mapping argument. However, not every aesthetic works with every geom. You could set the shape of a point, but you couldn’t set the “shape” of a line. On the other hand, you could set the linetype of a line. geom_smooth() will draw a different line, with a different linetype, for each unique value of the variable that you map to linetype.
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))
# NOTE: ggplot2 provides over 30 geoms, and extension packages provide even more (see https://www.ggplot2-exts.org for a sampling). The best way to get a comprehensive overview is the ggplot2 cheatsheet, which you can find at http://rstudio.com/cheatsheets.

# LIST OF GEOMS
# > Graphical Primitives
browseURL('http://r4ds.had.co.nz/images/visualization-geoms-1.png')
?geom_blank
?geom_curve
?geom_path
?geom_polygon
?geom_rect
?geom_ribbon
?geom_segment
?geom_spoke
?geom_tile
# > One Variable
browseURL('http://r4ds.had.co.nz/images/visualization-geoms-2.png')
# >> Continuous
?geom_area
?geom_density
?geom_dotplot
?geom_freqpoly
?geom_histogram
# >> Discrete
?geom_bar
# > Two Variables
browseURL('http://r4ds.had.co.nz/images/visualization-geoms-3.png')
# >> Continuous X, Continuous Y
?geom_label
?geom_jitter
?geom_point
?geom_quantile
?geom_rug
?geom_smooth
?geom_text
# >> Discrete X, Continuous Y
?geom_bar
?geom_boxplot
?geom_dotplot
?geom_violin
# >> Discrete X, Discrete Y
?geom_count
# >> Continuous Bivariate Distribution
?geom_bin2d
?geom_density2d
?geom_hex
# >> Continuous Function
?geom_area
?geom_line
?geom_step
# >> Visualizing Error
?geom_crossbar
?geom_errorbar
?geom_linerange
?geom_pointrange
# >> Maps
?geom_map
# > Three Variables
browseURL('http://r4ds.had.co.nz/images/visualization-geoms-4.png')
?geom_contour
?geom_raster

# Many geoms, like geom_smooth(), use a single geometric object to display multiple rows of data. For these geoms, you can set the group aesthetic to a categorical variable to draw multiple objects.
ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, group = drv))
# NOTE: no legend included

# To display multiple geoms in the same plot, add multiple geom functions to ggplot():
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(x = displ, y = hwy))
# NOTE: This, however, introduces some duplication in our code. Imagine if you wanted to change the y-axis to display cty instead of hwy. You’d need to change the variable in two places, and you might forget to update one. 

# You can avoid this type of repetition by passing a set of mappings to ggplot(). ggplot2 will treat these mappings as global mappings that apply to each geom in the graph.
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()

# If you place mappings in a geom function, ggplot2 will treat them as local mappings for the layer. It will use these mappings to extend or overwrite the global mappings for that layer only. This makes it possible to display different aesthetics in different layers.
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth()

# You can use the same idea to specify different data for each layer. Here, our smooth line displays just a subset of the mpg dataset, the subcompact cars.
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth(data = filter(mpg, class == 'subcompact'), se = FALSE)

# *****************************************************

# EXERCISES

# 1. What geom would you use to draw a line chart? A boxplot? A histogram? An area chart?
# ANSWER: The geoms used for line chart, boxplot, histogram, and area chart are: geom_line()/geom_smooth(), geom_boxplot(), geom_histogram()/geom_bar(), and geom_area(), respectively.

# 2. Run this code in your head and predict what the output will look like. Then, run the code in R and check your predictions.
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  geom_smooth(se = FALSE)
# ANSWER: I predict the code above will create 2 plots which shows the influence of displ on hwy, with the points for the scatterplot and the lines for the line plot displayed using 3 colors representing 4wd, rwd, and fwd. Also, since standard error is set to false, the line plot will not include the default error range. I WAS RIGHT!

# 3. What does show.legend = FALSE do? What happens if you remove it? Why do you think I used it in the example above.
ggplot(data = mpg) +
  geom_smooth(
    mapping = aes(x = displ, y = hwy, colour = drv),
    show.legend = FALSE
  )
# ANSWER: 'show.legend' toggles the visibility of the legend when using aesthetics. If you remove it the legend shows up by default. It isn't always necessary to include the legend if the visualization is simple enough for the analyst to make sense of.

# 4. What does the se argument to geom_smooth do?
?geom_smooth()
# ANSWER: 'se' stands for standard error. By default, it is set to TRUE, so whenever you use geom_smooth, it will include the gray area around the line to indicate the range of error.

# 5. Will these graphs look different? Why/why not?
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()
ggplot() + 
  geom_point(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_smooth(data = mpg, mapping = aes(x = displ, y = hwy))
# ANSWER: No they will appear to be the same. This is because the global mapping used for ggplot() in the first example is identical to all of the local mappings used by the geoms in the second example. Programmatically however, the first one is better since it is more concise and allows for efficient manipulation.

# 6. Recreate the R code necessary to generate the following graphs.
# Plot 1
browseURL('http://r4ds.had.co.nz/visualize_files/figure-html/unnamed-chunk-29-1.png')
# Plot 2
browseURL('http://r4ds.had.co.nz/visualize_files/figure-html/unnamed-chunk-29-2.png')
# Plot 3
browseURL('http://r4ds.had.co.nz/visualize_files/figure-html/unnamed-chunk-29-3.png')
# Plot 4
browseURL('http://r4ds.had.co.nz/visualize_files/figure-html/unnamed-chunk-29-4.png')
# Plot 5
browseURL('http://r4ds.had.co.nz/visualize_files/figure-html/unnamed-chunk-29-5.png')
# Plot 6
browseURL('http://r4ds.had.co.nz/visualize_files/figure-html/unnamed-chunk-29-6.png')
# ANSWER: 
# Plot 1
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(size = 3) +
  geom_smooth(se = FALSE)
# Plot 2
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(size = 3) + 
  geom_smooth(mapping = aes(shape = drv), se = FALSE)
# Plot 3
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) +
  geom_point(size = 3) +
  geom_smooth(mapping = aes(shape = drv), se = FALSE)
# Plot 4
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = drv), size = 3) +
  geom_smooth(se = FALSE)
# Plot 5
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = drv), size = 3) +
  geom_smooth(mapping = aes(linetype = drv), se = FALSE)
# Plot 6
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(fill = drv), color = 'white', shape = 21, size = 3, stroke = 3)

# *****************************************************

# [3.7] Statistical transformation

# The diamonds dataset comes in ggplot2 and contains information about ~54,000 diamonds, including the price, carat, color, clarity, and cut of each diamond.
?diamonds
diamonds %>% glimpse()

# The chart shows that more diamonds are available with high quality cuts than with low quality cuts.
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut))
# NOTE: count is a 'stat', since it is computed by ggplot automatically
# NOTE: Bar charts, histograms, and frequency polygons bin your data and then plot bin counts, the number of points that fall in each bin. Smoothers fit a model to your data and then plot predictions from the model. Boxplots compute a robust summary of the distribution and then display a specially formatted box.

# You can generally use geoms and stats interchangeably. For example, you can recreate the previous plot using stat_count() instead of geom_bar():
ggplot(data = diamonds) + 
  stat_count(mapping = aes(x = cut))
# NOTE: This works because every geom has a default stat; and every stat has a default geom.

?geom_bar # read about stat_count()
# There are three reasons you might need to use a stat explicitly:
# 1. You might want to override the default stat.
demo <- tribble(
  ~a,      ~b,
  "bar_1", 20,
  "bar_2", 30,
  "bar_3", 40
)
ggplot(data = demo) +
  geom_bar(mapping = aes(x = a, y = b), stat = "identity")
# 2. You might want to override the default mapping from transformed variables to aesthetics.
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1))
?geom_bar
# 3. You might want to draw greater attention to the statistical transformation in your code. For example, you might use stat_summary()
ggplot(data = diamonds) + 
  stat_summary(
    mapping = aes(x = cut, y = depth),
    fun.ymin = min,
    fun.ymax = max,
    fun.y = median
  )
# NOTE: ggplot2 provides over 20 stats for you to use.

# *****************************************************

# EXERCISES

# TODO 1. What is the default geom associated with stat_summary()? How could you rewrite the previous plot to use that geom function instead of the stat function?
?stat_summary
?geom_pointrange
ggplot(data = diamonds, mapping = aes(x = cut, y = depth)) +
  geom_pointrange(mapping = aes(ymin = min(depth), ymax = max(depth)))
# ANSWER: The default geom associated with stat_summary() is geom_pointrange(). The previous code can be re-written as shown above.

# 2. What does geom_col() do? How is it different to geom_bar()?
?geom_bar()
# ANSWER: This is an alternate version of geom_bar that maps the height of bars to an existing variable in your data. If you want the height of the bar to represent a count of cases, use geom_bar.

# 3. Most geoms and stats come in pairs that are almost always used in concert. Read through the documentation and make a list of all the pairs. What do they have in common?
browseURL('http://r4ds.had.co.nz/images/visualization-stats.png')
# ANSWER:
# GEOM-STAT Pairs
?geom_abline()
?geom_area() # stat_identity
?geom_bar() # stat_count
?geom_bin2d() # stat_bin2d
?geom_blank() # stat_identity
?geom_boxplot() # stat_boxplot
?geom_contour() # stat_contour
?geom_count() # stat_sum
?geom_crossbar() # stat_identity
?geom_curve() # stat_identity
?geom_density() # stat_density
?geom_density_2d() # stat_density
?geom_density2d() # stat_density
?geom_dotplot()
?geom_errorbar() # stat_identity
?geom_errorbarh() # stat_identity
?geom_freqpoly() # stat_bin
?geom_hex() # stat_binhex
?geom_histogram() # stat_bin
?geom_hline()
?geom_jitter() # stat_identity
?geom_label() # stat_identity
?geom_line() # stat_identity
?geom_linerange() # stat_identity
?geom_map() # stat_identity
?geom_path() # stat_identity
?geom_point() # stat_identity
?geom_pointrange() # stat_identity
?geom_polygon() # stat_identity
?geom_qq() # stat_point
?geom_quantile # stat_quantile
?geom_raster() # stat_identity
?geom_rect() # stat_identity
?geom_ribbon() # stat_identity
?geom_rug() # stat_identity
?geom_segment() # stat_identity
?geom_smooth() # stat_smooth
?geom_spoke() # stat_identity
?geom_step() # stat_identity
?geom_text() # stat_identity
?geom_tile() # stat_identity
?geom_violin() # stat_ydensity
geom_vline()

# STAT-GEOM Pairs
?stat_bin() # geom_bar()
stat_bin_2d() # geom_tile()
stat_bin_hex() # geom_hex()
stat_bin2d() # geom_tile()
stat_binhex() # geom_hex()
stat_boxplot() # geom_boxplot()
stat_contour() # geom_contour()
stat_count() # geom_bar()
stat_density() # geom_area()
stat_density2d() # geom_density_2d()
stat_density_2d() # geom_density_2d()
stat_ecdf() # geom_step()
stat_ellipse() # geom_path()
stat_function() # geom_path()
stat_identity() # geom_point()
stat_qq() # geom_point()
stat_quantile() # geom_quantile()
stat_smooth() # geom_smooth()
stat_spoke()
stat_sum() # geom_point()
stat_summary() # geom_pointrange()
stat_summary_2d() # geom_tile()
stat_summary_bin() # geom_pointrange()
stat_summary2d() # geom_tile()
stat_unique() # geom_point()
stat_ydensity() # geom_violin()

# TODO 4. What variables does stat_smooth() compute? What parameters control its behaviour?
?stat_smooth()
# ANSWER: stat_smooth() computes y (predicted value), ymin (lower CI), ymax (upper CI), se (std. error). 

# TODO 5. In our proportion bar chart, we need to set group = 1. Why? In other words what is the problem with these two graphs?
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = ..prop..))
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = color, y = ..prop..))
# ANSWER: We must specify group = 1 since ggplot needs to know what the proportions are out of. In this case, they are all set to equal proportions because we haven't specified the total group.

# *****************************************************

# [3.8] Position adjustments

# There’s one more piece of magic associated with bar charts. You can colour a bar chart using either the colour aesthetic, or more usefully, fill:
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, colour = cut))
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = cut))

# Note what happens if you map the fill aesthetic to another variable, like clarity: the bars are automatically stacked. Each colored rectangle represents a combination of cut and clarity.
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity))
# NOTE: The stacking is performed automatically by the position adjustment specified by the position argument. 

# If you don’t want a stacked bar chart, you can use one of three other options: "identity", "dodge" or "fill".
# 1. Using position = 'identity' will place each object exactly where it falls in the context of the graph. Not that useful for bars due to overlapping.
ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) + 
  geom_bar(alpha = 1/5, position = "identity")
ggplot(data = diamonds, mapping = aes(x = cut, colour = clarity)) + 
  geom_bar(fill = NA, position = "identity")
# 2. Using position = 'fill' works like stacking, but makes each set of stacked bars the same height. This makes it easier to compare proportions across groups.
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "fill")
# 3. Using position = 'dodge' places overlapping objects directly beside one another. This makes it easier to compare individual values.
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge")

# There’s one other type of adjustment that’s not useful for bar charts, but it can be very useful for scatterplots. To avoid 'overplotting', you can set the position adjustment to 'jitter'. This adds a small amount of random noise to each point. This spreads the points out because no 2 points are likely to recieve the same amount of random noise.
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), position = 'jitter')
# NOTE: Adding randomness seems like a strange way to improve your plot, but while it makes your graph less accurate at small scales, it makes your graph more revealing at large scales.

# Because this is such a useful operation, ggplot2 comes with a shorthand for geom_point(position = "jitter"): geom_jitter().
ggplot(data = mpg) +
  geom_jitter(mapping = aes(x = displ, y = hwy))

# To learn more about a position adjustment, look up the help page associated with each adjustment:
?position_dodge
?position_fill
?position_identity
?position_jitter
?position_stack

# *****************************************************

# EXERCISES

# 1. What is the problem with this plot? How could you improve it?
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_point()
# ANSWER: The problem is overplotting (i.e. overlapping points). We can avoid this by adding a bit of randomness to the plot by adding position = 'jitter' or appending geom_jitter() to ggplot call.

# 2. What parameters to geom_jitter() control the amount of jittering?
?geom_jitter()
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_point() + 
  geom_jitter(width = 2, height = 2)
# ANSWER: The parameters 'width' and 'height' control the amount of horizontal or vertical jittering, respectively.

# 3. Compare and contrast geom_jitter() with geom_count().
?geom_jitter()
?geom_count()
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_point() +
  geom_count()
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_point() +
  geom_jitter()
# ANSWER: geom_jitter() and geom_count() both offer different ways of dealing with 'overplotting'. While geom_jitter() will add some random noise to each data point, geom_count() will modify the size of the points based on the number of observations in that data point. Geom_count() also includes a legend describing how many observations belong to each differently sized points.

# 4. What's the default position adjustment for geom_boxplot()? Create a visualization of mpg dataset that demonstrates it.
ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = class, y = cty))
# geom_boxplot uses the 'dodge' position as default which places overlapping objects directly beside one another.

# *****************************************************

# [3.9] Coordinate systems

# Coordinate systems are probably the most complicated part of ggplot2.
# The default coordinate system is the Cartesian coordinate system where the x and y position act independently to find the location of each point.

# 1. coord_flip() switches the x and y axes.
?coord_flip()
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot()
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot() +
  coord_flip()
# NOTE: useful for horizontal boxplots or long x-axis labels

# 2. coord_quickmap() sets the aspect ratio correctly for maps. 
?coord_quickmap()
usa <- map_data('usa')
ggplot(data = usa, 
       mapping = aes(long, lat, group = group)) +
  geom_polygon(fill = 'white', color = 'black')
ggplot(data = usa, 
       mapping = aes(long, lat, group = group)) +
  geom_polygon(fill = 'white', color = 'black') + 
  coord_quickmap()
# NOTE: useful for spatial analysis

# 3. coord_polar() uses polar coordinates.
bar <- ggplot(data = diamonds) + 
  geom_bar(
    mapping = aes(x = cut, fill = cut),
    show.legend = FALSE,
    width = 1
  ) +
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)

bar + coord_flip()
bar + coord_polar()
# NOTE: polar coordinates reveal an interesting connection between bar charts and Coxcomb charts

# *****************************************************

# EXERCISES

# 1. Turn a stacked bar chart into a pie chart using coord_polar().
# ANSWER:
mpg %>% glimpse()
ggplot(data = mpg) + 
  geom_bar(mapping = aes(x = drv, fill = class), position = 'fill') + 
  coord_polar()

# 2. What does labs() do? Read the documentation.
?labs()
# ANSWER: labs() allows you to change axis labels and legend titles

# 3. What's the difference between coord_quickmap() and coord_map()?
?coord_quickmap()
?coord_map()
nz <- map_data('nz')
nzmap <- ggplot(nz, aes(x = long, y = lat, group = group)) +
  geom_polygon(fill = 'white', color = 'black')
nzmap
# With correct mercator projection
nzmap + coord_map()
# With the aspect ratio approximation
nzmap + coord_quickmap()
# ANSWER: coord_map() uses the mercator projection by default but also allows for many other projections, while coord_quickplot() uses aspect ratio approximation and has fewer parameters.

# 4. What does the plot below tell you about the relationship between city and highway mpg? Why is coord_fixed() important? What does geom_abline() do?
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() + 
  geom_abline() + 
  coord_fixed()
?geom_abline()
?coord_fixed()
# ANSWER: The plot tells us that city and highway mpg have a positive relationship, meaning that the higher the city mpg, the higher the highway mpg. In this case, since both cty and hwy have the same units, we can use coord_fixed() to make sure that the axes have the same scale. Moreover, geom_abline() is usually for adding straight lines to a plot (i.e. y = x, horizontal, vertical, or based on linear function) for the purposes of annotating plots. In this case, it is useful as a reference line to show us that the highway miles per gallon values are generally higher than city miles per gallon values since, relatively speaking, cars have more efficient fuel consumption on highways.

# *****************************************************

# [3.10] The layered grammer of graphics

# Layered graphing template
# ggplot(data = <DATA>) + 
#   <GEOM_FUNCTION>(
#     mapping = aes(<MAPPINGS>),
#     stat = <STAT>, 
#     position = <POSITION>
#   ) +
#   <COORDINATE_FUNCTION> +
#   <FACET_FUNCTION>

# NOTE: The seven parameters in the template compose the grammar of graphics, a formal system for building plots. The grammar of graphics is based on the insight that you can uniquely describe any plot as a combination of a dataset, a geom, a set of mappings, a stat, a position adjustment, a coordinate system, and a faceting scheme.

# You could use this method to build any plot that you imagine. In other words, you can use the code template that you’ve learned in this chapter to build hundreds of thousands of unique plots.

