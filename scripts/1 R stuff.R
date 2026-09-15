#
#
# Refresher to R
#
#
#
# Clean environment -------------------------------------------------------
rm(list = ls()) 
# This removes all objects from the environment. You shoudl do this at the top of every script---objects from other
# sessions or scripts can lead to code that only works once. 

# For example, watch the Environment pane and run:
df <- data.frame(group = LETTERS[1:10],
                  response = rnorm(n = 10, mean = 0, sd = 1))
df
# An object called "df" should be in the Environment pane.

# Now, clean the environment:
rm(list = ls()) 

# It should be gone :) 

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -------------------------------------------
# Load libraries -------------------------------------------------------------
#' [The `---` above add that to the outline (click button in top right of this panel to make outline visible)]

# Libraries contain *functions* and *data*
library("dplyr") # This is a very popular package for data manipulation
library("ggplot2") # This is a very popular package for making figures/plots

# Functions DO things. They are symbolized with parentheses at the end of their name and
# most of them take **arguments**, which are passed in within those parentheses.

# `rnorm` is a built in function that randomly draws from the normal distribution:
# It takes the arguments "n", "mean", and "sd" and returns a vector:
rnorm(n = 10, mean = 0, sd = 1)

# All functions have associated documentation that be accessed with:
help(rnorm)

# Or, more compactly:
?rnorm

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -------------------------------------------
# Data structures ----------------------------------------------------------------
# There are several types of data in R:

# >>> 1. Vectors ----------------------------------------------------------
vec <- rnorm(n = 10, mean = 0, sd = 1) 
vec

# Vectors are linear sequences of numbers, characters, or even logicals (TRUE, FALSE).
# All elements must be of the same type. You cannot mix numbers, characters, or logicals.
# If you do, R will try to coerce it into a universal type (generally character)

# The elements inside a vector can be accessed with square brackets.
vec[1]

# The 1 returns the first element in the object vec
vec[1:5]

# That returns the first 5 because:
1:5

# You can also select elements by logical conditions.
# All elements of vec that are < 0:
vec[vec < 0]

# This works because vec < 0 returns a vector of TRUE and FALSE. By putting vec < 0 inside of vec[], you get the TRUE values back:
vec < 0
vec[vec < 0]

# You can query the length of a vector with the builtin function "length":
length(vec)


# >>> 2. Data frames ---------------------------------------------------------
# data.frames are the most commonly used data structure in R. These are basically excel files.
# Important concerns:
# 1. Each column of a data.frame is a vector, and must be of the same type
# 2. Each column must be the same length (e.g., have the same number of rows)
# 3. Columns are named and can be accessed by names

# We'll load a dataset built into R:
data(iris)

head(iris) # head() is a funciton that prints only the top n rows (defaulting to 6)

# We can see that there are 5 columns. What type of data are these?
str(iris) # Most are numeric, and species is a factor.

# Indexing.
# data.frames have 2 dimensions: rows, and columns. This is reflected in how they are indexed:
# The first space, BEFORE the comma, selects ROWS. This is often referred to as the "i" slot
iris[1, ]
iris[1:5, ]


# The second space, AFTER the comma, selects COLUMNS
iris[, 1:2]
# This is often referred to as the "j" slot:


# You can also select columns by name, using a $
iris$Species

# And you can filter by conditions by posing logical tests in the "i" slot:
iris[iris$Sepal.Length < 4.4, ]

# Conditions are evaluated with several main symbols:
# < (less than)
# > (greater than)
# <= (less than OR equal)
# == (equal to)
# %in% (an object is in the other vector). This is == for multiple options.

# For example:
iris[iris$Sepal.Length == 6.7, ]

iris[iris$Sepal.Length %in% c(6.7, 7.9), ]


# You can add new columns, again using a '$':
iris$new_column <- rnorm(n = nrow(iris), mean = 0, sd = 1)

head(iris)

# Note that most of you will likely use dplyr (though I recommend data.table) for these
# types of operations. But understanding how this works in "base R" is important.

# >>> 3. Lists ---------------------------------------------------------------
# Lists are important and often confusing data structures.
# These are basically a vector where each element can be ANYTHING. Including another vector, a figure, a dataset, etc

# Let's add our object "vec" and the builtin dataset to my_list:
my_list <- list(element_1 = vec,
                element_2 = iris)

# Lists are accessed with 2 square brackets:
my_list[[1]] # The first element (vec)

# If you use only 1 bracket, you'll receive a list of length 1
my_list[1]

# Now the second element:
my_list[[2]]

# You can get the length of each list element with "lengths":
lengths(my_list)


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -------------------------------------------
# Changing the shape of data.frames ----------------------------------------------------
# Let's clean the environment:
rm(list = ls())

# Data can be organized in many ways.
data(iris)

# This dataset is LONG by species and WIDE by trait (Sepal.Length, Sepal.Width, etc)
head(iris)

# What if you actually want it to be LONG by both species and trait?

# The tidyverse provides a function for this in R package "tidyr":
library("tidyr")

# This function is called "pivot_longer":
# Let's read the documentation:
?pivot_longer

# Complicated but let's try:
iris_long <- pivot_longer(data = iris,
                          cols = c("Sepal.Length", "Sepal.Width", "Petal.Width", "Petal.Length"),
                          names_to = "Trait",
                          values_to = "Value")

iris_long

# Let's go back to wide:
iris_wide <- pivot_wider(data = iris_long,
                         id_cols = "Species",
                         names_from = "Trait",
                         values_from = "Value")
# Oh no, there was an error!

iris_wide

# This is because you can't always go straight from long to wide
# Why?
# Because there's no ID linking the associated rows. R doesn't know which Sepal.Width value matches which Sepal.Length value
# All combinations are possible, because the only ID we have is Species.

# So let's try again, but first we'll add a row ID to iris
iris$row_id <- paste("plant", 1:nrow(iris))

# Now let's make this long:
iris_long <- pivot_longer(data = iris,
                          cols = c("Sepal.Length", "Sepal.Width", "Petal.Width", "Petal.Length"),
                          names_to = "Trait",
                          values_to = "Value")

iris_long

# Let's go back to wide:
iris_wide <- pivot_wider(data = iris_long,
                         id_cols = c("Species", "row_id"),
                         names_from = "Trait",
                         values_from = "Value")


iris_wide
# Success! 

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -------------------------------------------
# Conditional statements --------------------------------------------------

# What if you want the code to only run if some condition is met?
# Meet the if statement
object <- "A"

if(object == "A"){
  print("Object is A")
}else{
  print("Object is NOT A")
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -------------------------------------------
# Writing your own function ---------------------------------------------------------------
# Functions are ways to ENCAPSULATE code.

# They can be very helpful. But they can also cause problems.
# Keep your functions small, tidy, and wwith clear inputs and outputs. Functions can be hard to debug and so it's often
# better to make your functions small and to the point.
# Let's write a function to melt and plot 
my_special_function <- function(my_name, 
                                message){
  paste0(my_name, ": ", message)
}
# This is a now function called "my_special_function", which accepts "my_name" and "message" 
# as arguments

#
my_special_function(my_name = "Erick",
                    message = "Not really sure what the hell I'm doing here")


# if you run the function above but miss an argument, this will cause an error:
my_special_function(my_name = "Erick")

# You can also write functions to have default values, allowing you to not specify a parameter:
my_special_function <- function(my_name = "Erick", 
                                message = "GAHHHH"){
  paste0(my_name, ": ", message)
}

my_special_function(my_name = "Santi")

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -------------------------------------------
# Loops ----------------------------------------------------
# This is something that confuses many people. 
# Loops are a way to do something multiple times. Loops can get very complex
# 

# Let's loop through each species in the iris dataset and make summaries.
# Note that there are MUCH more efficient ways to do this. We'll compare.


# Let's do this with the LONG version of iris:
iris_long
uniq_species <- unique(iris_long$Species)
uniq_species
# This is a vector of length = 3. 

# We'll iterate over this vector and summarize it per species.

# The proper way to do this would be with summarize() function.

# However, to try to understand loops (which are necessary for some operations),
# let's do this starting with the dangerous loop of all: the while loop



# >>> while loop ----------------------------------------------------------
# These do everything inside the while loop, until the break condition of the while loop is broken.
# Let's create a counter variable called "i", which will start at 1:

i <- 1
uniq_species # vector of length 3

# Let's also create some empty holder objects for the stuff we generate inside our loop:
sub_dat <- c()

# An empty list to hold our results:
res <- list()

while(i <= length(uniq_species)){
  cat(paste("Filtering dataset to", uniq_species[i]), "\n")
  sub_dat <- iris_long[iris_long$Species == uniq_species[i], ]
  
  # Now let's make a figure:
  res[[i]] <- ggplot(data = iris_long,
                     aes(x = Trait, y = Value))+
    geom_boxplot()+
    ggtitle(uniq_species[i])
  
  # Now, increase i to 2:
  i <- i + 1
}

# Now the list res should be length 3:
length(res)

# And each element is a ggplot:
res[[1]]
res[[2]]
res[[3]]

# The anatomy of the while loop:
#' * i <= length(uniq_species) * If this returns TRUE then the while loop executes what's inside the curly brackets
#' If this returns FALSE, it breaks the while loop.
#
#' * sub_dat <- iris_long[iris_long$Species == uniq_species[i], ] * This SUBSETTED iris_long by 'i'
# The mechanics of this are:
uniq_species # vector of length 3

# Which can be filtered with a numeric in the square brackets:
uniq_species[1]

uniq_species[2]

i <- 2

uniq_species[i]


#' [i <- i + 1] This increases i. Without this, the while loop would run for INFINITY.

# for loops ---------------------------------------------------------------
# DO NOT USE while loops unless you absolutely must. 

# For loops are modified while loops that explicitly require break conditions because you must specify how many iterations
# The i is created in situ, inside the for loop and will run until it no longer equals the sequence 1:length(uniq_species)
for(i in 1:length(uniq_species)){
  cat(paste("Filtering dataset to", uniq_species[i]), "\n")
  sub_dat <- iris_long[iris_long$Species == uniq_species[i], ]
  
  # Now let's make a figure:
  res[[i]] <- ggplot(data = iris_long,
                     aes(x = Trait, y = Value))+
    geom_boxplot()+
    ggtitle(uniq_species[i])
}
# Note that we no longer need the i <- i + 1

# Apply -------------------------------------------------------------------

# Instead of using loops, R also has base functions for iterating over objects.

# The operation above could be done as follows:

res <- lapply(uniq_species,
                 FUN = function(x){
                     sub_dat <- iris_long[iris_long$Species == x, ]
                     
                     # Now let's make a figure:
                     ggplot(data = iris_long,
                            aes(x = Trait, y = Value))+
                       geom_boxplot()+
                       ggtitle(uniq_species[i])
                   
                   })
res[[1]]
res[[2]]

# What's different about the lapply?

# Loops versus vector based operations ------------------------------------
# Loops are essential sometimes, especially when you have lots of logical conditions.
# Loops are also good, I think, for making you really understand data structures because you have to explicitly
# index across them.

# Imagine trying to fit thousands of models, evaluating whether they fit successfully, and saving the outcome.
# However, loops are generally slower and more difficult to read than vector based operations.

# For example, we can write a loop to plot each species in `iris`, as we did above. We can then take that list and convert
# to a single figure.
# We'll do this with the patchwork package:

library("patchwork")
res.combined <- wrap_plots(res, nrow = 3)
res.combined

# We could have done the same thing with facet_wrap with a lot less work:
ggplot(data = iris_long,
       aes(x = Trait, y = Value))+
  geom_boxplot()+
  facet_wrap(~Species, nrow = 3)


