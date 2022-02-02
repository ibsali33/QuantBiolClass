# =====================================================================
# Module 1.1 Supplement: Installing and loading packages
# =====================================================================

# Almost all R programming will require loading or installing specific 
# R packages in order to execute particular functions. This is especially
# true when you are writing code from scratch on your local machine. In order 
# to do that you must use the 'install.packages()' command. When you install
# a package, you must put the name of the package in quotations so R
# can properly search it from CRAN, the public repository of R packages.

# Some of the packages we will use in our course: 
# tidyr - for transforming data pivoting data frames and simplifying syntax
# dplyr - data frame trasnformation and manipulation
# reshape2 - pivoting tables and reshaping data
# ggplot2 - creating plots from data
# RColorBrewer - tuning and manipulating plot colors
# stringr - for editing strings
# readr - for downloading data sets

# Review: In order to run code from an Rsource file, go to the line or highlight
# the code that you want to run and hit Command/Control + Return. This 
# will execute the line(s) of code in the console. Install the the packages 
# listed above. Notice if you get any warning or error messages. 

install.packages("thepackage")

# Packages are bits of code that are built in order to perform specific tasks
# in R. For example: the tidyr, dplyr and reshape2 packages are built organize 
# and clean data that you are working with. The packages ggplot2 and RColorBrewer 
# are used for data visualization and color blending. The lubridate package is
# used for working with dates and times when plotting. Each of these will 
# will come in handy by the end of the workshop.

# Once packages are installed you can see them listed under the 'Packages' 
# tab in the bottom right hand panel. In order to use the installed 
# packages, they need to be loaded in the R session. To do this use the 
# 'library()' command. See examples below.

library(dplyr)

# Use the library() command for all the packages you just installed. 
# Are there other ways to load libraries in R?
# Notice any errors or warnings.

# Often R will give you a warning if commands from one package like 
# dplyr 'mask' commands from another package. In the case of dplyr
# loading that library will use the 'filter()' command from dplyr
# instead of the default library stats. Similarly it will use the
# intersect() command from dplyr instead of the base R commands.

# =====================================================================
# Module 1.1 Supplement: Finding Help
# =====================================================================

# There are a lot of options when it comes to finding help in R. 
# The quickest way is to go to the bottom right hand corner under 
# the 'Help' tab and use the search box to search the commands you 
# need help with. 

# You can also type the command in the console with a preceeding 
# question mark. This will also show you help for the command.
# For example, if I wanted to know what the syntax is for the
# 'data.frame()' command I would type the following code into the console
# or highlight the line of code below and run it with ctrl+return

?data.frame()

# Sadly, the documentation for some packages in R is absolutely 
# horrific and unintelligible. So our next best friend is the internet. 
# But before going into the abyss - a good place to start are the 
# RStudio cheat-sheets. These cheat sheets are made for some of the most 
# commonly used and useful packages in R and they outline the command 
# options and syntax for those packages. For this particular workshop 
# I recommend a few listed below:

# data import: 
# https://evoldyn.gitlab.io/evomics-2018/ref-sheets/R_data-import.pdf
# data transformation: 
# https://4.files.edl.io/b9e2/07/12/19/142839-a23788fb-1d3a-4665-9dc4-33bfd442c296.pdf
# data visualization with ggplot2: 
# https://rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf

# RStudio has created a bunch of these cheat sheets and they can all 
# be accessed using RStudio Cloud or by searching RStudio cheat sheets. 
# There is no need to look at these in detail during the workshop yet. 
# Relevant commands will be provided through instruction. However, I highly
# recommend reviewing these cheat sheets to see the breadth of capabilities
# of RStudio's selected packages at some point.

# Otherwise, a large majority of data wrangling and visualization questions
# have been asked or discussed on various forums. One strategy is to just 
# describe what you are trying to do in the google search bar and see if any 
# forums pop up. Common forums include 'StackOverflow', 'R-bloggers' and for
# the life sciences 'Biostars'.

# Some other tips that could be of use:

# the term 'syntax' describes the order of arguments in a command and the
# use and order of parenthesis and quotations in order to properly execute
# commands

# if you want to loop a command's syntax and you can't seem to find it in
# the rstudio help section you can search in a web browser the name of the
# library and command followed by the term usage. you might need to 
# specify the coding langage, in case similar command names are found in
# different coding languages like matlab, python or sql.

# searching "ggplot geom_bar usage" will help you find syntax for the  
# 'geom_bar()' command for creating bar charts in the ggplot package.
