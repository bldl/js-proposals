library(ggplot2)
library(dplyr)
library(reshape2)
library(tidyverse)
library(lubridate)
library(readr)

#Look at single stage
#data <- read.csv("../CSVFiles/Stage 4.csv")

#setwd in CSVFiles
#file_list <- list.files()
#load_files <- lapply(file_list, read.csv)
#data <- do.call("rbind", load_files)

#Plot1
# Convert the data into longer format - each stage bump date has its own row
data_long <- data %>%
  pivot_longer(
    cols = matches("^Stage\\.|^Last\\."),
    names_to = "Stage",
    values_to = "Date"
  ) %>%
  
  # Mutates the date into ymd format for R to understand and process
  mutate(Date = ymd(Date)) %>%
  
  # Filter out NA dates 
  filter(!is.na(Date))

# Create the grouped scatter plot
ggplot(data_long, aes(x = Date, y = Title, color = Stage)) +
  geom_point(size = 1) +
  labs(title = "Proposal Stage Timeline by Title",
       x = "Date",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()



#Plot2
# boxplots

data_long <- data %>%
  pivot_longer(
    cols = starts_with("Stage."),
    names_to = "Stage",
    values_to = "Date"
  ) %>%
  mutate(Date = ymd(Date)) %>%
  filter(!is.na(Date))

# Create horizontal boxplots per Title
ggplot(data_long, aes(x = Date, y = Title)) +
  geom_boxplot(outlier.shape = 8, outlier.size = 2.5, fill = "white") +
  geom_point(aes(color = Stage), size = 1) +
  labs(title = "Stage Date Distribution per Proposal",
       x = "Date",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()


#Plot3
# ordered boxplots

# Reshape to long format

# Compute duration per Title
data_long <- data_long %>%
  group_by(Title) %>%
  mutate(Duration = as.numeric(max(Date) -min(Date))) %>%
  ungroup()

# Plot
ggplot(data_long, aes(x = Date, y = reorder(Title, -Duration))) +
  geom_boxplot(outlier.shape = 8, outlier.size = 2.5, fill = "white") +
  geom_point(aes(color = Stage), size = 1) +
  labs(
      title = "Stage Date Spread per Proposal",
      x = "Date",
      y = "Proposal Title",
      color = "Stage") +
  theme_minimal()


#Plot4
# ordered boxplots with months in x axis

# Recompute duration in months
title_durations <- data_long %>%
  group_by(Title) %>%
  mutate(
    MonthsSinceStart = interval(min(Date), Date) %/% months(1),
    Duration = interval(min(Date), max(Date))%/% months(1)) 

# Plot
ggplot(title_durations, aes(x = MonthsSinceStart, y = reorder(Title, -Duration))) +
  geom_boxplot(outlier.shape = 8, outlier.size = 2.5, fill = "white") +
  geom_point(aes(color = Stage), size = 1) +
  labs(title = "Stage Date Spread per Proposal",
       x = "Date",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()


#Plot5
# API changes

#Look at single stage
data <- read.csv("../CSVFiles/Changes/API Change.csv")

#Plot1
# Convert the data into longer format - each stage bump date has its own row
data_long <- data %>%
  pivot_longer(
    #with last commit 
    #cols = matches("^Stage\\.|^Last\\."),
    
    #without last commit 
    cols = matches("^Stage\\."),
    names_to = "Stage",
    values_to = "Date"
  ) %>%
  
  # Mutates the date into ymd format for R to understand and process
  mutate(Date = ymd(Date)) %>%
  
  # Filter out NA dates 
  filter(!is.na(Date))

# Create the grouped scatter plot
ggplot(data_long, aes(x = Date, y = Title, color = Stage)) +
  geom_point(size = 1) +
  labs(title = "Proposal Stage Timeline by Title for API Changes",
       x = "Date",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()

#Plot4
# ordered boxplots with months in x axis

# Recompute duration in months
title_durations <- data_long %>%
  group_by(Title) %>%
  mutate(
    MonthsSinceStart = interval(min(Date), Date) %/% months(1),
    Duration = interval(min(Date), max(Date))%/% months(1)) 

average_duration <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(AverageDuration = mean(Duration, na.rm=TRUE))

  print(average_duration)

# Plot
ggplot(title_durations, aes(x = MonthsSinceStart, y = reorder(Title, -Duration))) +
  geom_boxplot(outlier.shape = 8, outlier.size = 2.5, fill = "white") +
  geom_point(aes(color = Stage), size = 1) +
  labs(title = "Stage Date Spread per Proposal for API Changes",
       x = "Date",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()


#Plot5
# Syntactic changes

#Look at single stage
data <- read.csv("../CSVFiles/Changes/Syntactic Change.csv")

# Convert the data into longer format - each stage bump date has its own row
data_long <- data %>%
  pivot_longer(
    #with last commit 
    #cols = matches("^Stage\\.|^Last\\."),
    
    #without last commit 
    cols = matches("^Stage\\."),
    names_to = "Stage",
    values_to = "Date"
  ) %>%
  
  # Mutates the date into ymd format for R to understand and process
  mutate(Date = ymd(Date)) %>%
  
  # Filter out NA dates 
  filter(!is.na(Date))

# Create the grouped scatter plot
ggplot(data_long, aes(x = Date, y = Title, color = Stage)) +
  geom_point(size = 1) +
  labs(title = "Proposal Stage Timeline by Title for Syntactic Changes",
       x = "Date",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()

#Plot4
# ordered boxplots with months in x axis

# Recompute duration in months
title_durations <- data_long %>%
  group_by(Title) %>%
  mutate(
    MonthsSinceStart = interval(min(Date), Date) %/% months(1),
    Duration = interval(min(Date), max(Date))%/% months(1)) 

average_duration <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(AverageDuration = mean(Duration, na.rm=TRUE))

print(average_duration)

# Plot
ggplot(title_durations, aes(x = MonthsSinceStart, y = reorder(Title, -Duration))) +
  geom_boxplot(outlier.shape = 8, outlier.size = 2.5, fill = "white") +
  geom_point(aes(color = Stage), size = 1) +
  labs(title = "Stage Date Spread per Proposal for Syntactic Changes",
       x = "Date",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()


#Plot5
# Semantic changes

#Look at single stage
data <- read.csv("../CSVFiles/Changes/Semantic Change.csv")

#Plot1
# Convert the data into longer format - each stage bump date has its own row
data_long <- data %>%
  pivot_longer(
    #with last commit 
    #cols = matches("^Stage\\.|^Last\\."),
    
    #without last commit 
    cols = matches("^Stage\\."),
    names_to = "Stage",
    values_to = "Date"
  ) %>%
  
  # Mutates the date into ymd format for R to understand and process
  mutate(Date = ymd(Date)) %>%
  
  # Filter out NA dates 
  filter(!is.na(Date))

# Create the grouped scatter plot
ggplot(data_long, aes(x = Date, y = Title, color = Stage)) +
  geom_point(size = 1) +
  labs(title = "Proposal Stage Timeline by Title for Semantic Changes",
       x = "Date",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()

#Plot4
# ordered boxplots with months in x axis

# Recompute duration in months
title_durations <- data_long %>%
  group_by(Title) %>%
  mutate(
    MonthsSinceStart = interval(min(Date), Date) %/% months(1),
    Duration = interval(min(Date), max(Date))%/% months(1)) 

average_duration <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(AverageDuration = mean(Duration, na.rm=TRUE))

  print(average_duration)


# Plot
ggplot(title_durations, aes(x = MonthsSinceStart, y = reorder(Title, -Duration))) +
  geom_boxplot(outlier.shape = 8, outlier.size = 2.5, fill = "white") +
  geom_point(aes(color = Stage), size = 1) +
  labs(title = "Stage Date Spread per Proposal for Semantic Changes",
       x = "Date",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()

