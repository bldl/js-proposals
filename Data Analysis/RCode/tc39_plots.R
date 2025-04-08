library(ggplot2)
library(dplyr)
library(reshape2)
library(tidyverse)
library(lubridate)
library(readr)
library(ggrepel)

#Look at single stage
#data <- read.csv("../CSVFiles/Stage Inactive.csv")

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
  labs(title = "All Proposals Timeline by Title",
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
  labs(title = "All Proposals Date Distribution per Proposal",
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
      title = "All Proposals Date Spread per Proposal",
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
  labs(title = "All Proposals Date Spread per Proposal",
       x = "Date",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()


#Plot5
# API changes

#Look at single file
#set working directory to Data Analysis
data <- read.csv("CSVFiles/CSVChanges/API Change.csv")

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

#Look at single file
#setwd to Data Analysis
data <- read.csv("CSVFiles/CSVChanges/Syntactic Change.csv")

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
data <- read.csv("CSVFiles/CSVChanges/Semantic Change.csv")

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


# API Change in Stage 4

#Look at single stage
data <- read.csv("CSVFiles/CSVChanges/API Change Stage 4.csv")

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

average_duration_api_stage4 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(AverageDuration = mean(Duration, na.rm=TRUE))

sd_api_stage4 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(SD_api = sd(Duration, na.rm=TRUE))

print(average_duration_api_stage4)
print(sd_api_stage4)


# Plot
ggplot(title_durations, aes(x = MonthsSinceStart, y = reorder(Title, -Duration))) +
  geom_boxplot(outlier.shape = 8, outlier.size = 2.5, fill = "white") +
  geom_point(aes(color = Stage), size = 1) +
  labs(title = "Stage 4 API Changes",
       x = "Date",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()


# Semantic Change in Stage 4

#Look at single stage
data <- read.csv("CSVFiles/CSVChanges/Semantic Change Stage 4.csv")

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

average_duration_semantic_stage4 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(AverageDuration = mean(Duration, na.rm=TRUE))

sd_semantic_stage4 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(SD_Semantic = sd(Duration, na.rm=TRUE))

print(average_duration_semantic_stage4)
print(sd_semantic_stage4)


# Plot
ggplot(title_durations, aes(x = MonthsSinceStart, y = reorder(Title, -Duration))) +
  geom_boxplot(outlier.shape = 8, outlier.size = 2.5, fill = "white") +
  geom_point(aes(color = Stage), size = 1) +
  labs(title = "Stage Date Spread per Proposal for Semantic Changes",
       x = "Date",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()

# Semantic Change in Stage 4

#Look at single stage
data <- read.csv("CSVFiles/CSVChanges/Syntactic Change Stage 4.csv")

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

average_duration_syntactic_stage4 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(AverageDuration = mean(Duration, na.rm=TRUE))

sd_syntactic_stage4 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(SD_Syntactic = sd(Duration, na.rm=TRUE))

print(average_duration_syntactic_stage4)
print(sd_syntactic_stage4)


# Plot
ggplot(title_durations, aes(x = MonthsSinceStart, y = reorder(Title, -Duration))) +
  geom_boxplot(outlier.shape = 8, outlier.size = 2.5, fill = "white") +
  geom_point(aes(color = Stage), size = 1) +
  labs(title = "Stage Date Spread per Proposal for Syntactic Changes",
       x = "Date",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()


#Donut plot for stages

# Create Data
data <- data.frame(
  category=c("Inactive", "Stage 0", "Stage 1", "Stage 2", "Stage 2.7", "Stage 3", "Stage 4"),
  count=c(42, 14, 81, 23, 6, 16, 65)
)

# Compute percentages
data$fraction <- data$count / sum(data$count)

# Compute the cumulative percentages (top of each rectangle)
data$ymax <- cumsum(data$fraction)

# Compute the bottom of each rectangle
data$ymin <- c(0, head(data$ymax, n=-1))

# Compute label position
data$labelPosition <- (data$ymax + data$ymin) / 2

# Compute a good label
data$label <- paste0(data$category, "\n value: ", data$count)

# Make the plot
ggplot(data, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=category)) +
  geom_rect() +
  geom_label( x=3.5, aes(y=labelPosition, label=label), size=3) +
  scale_fill_brewer(palette=4) +
  coord_polar(theta="y") +
  xlim(c(1, 4)) +
  theme_void() +
  theme(legend.position = "none")

#Donut plot for change classifications

# Create Data
data <- data.frame(
  category=c("API Change", "Semantic Change", "Syntactic Change"),
  count=c(137, 117 ,110)
)

# Compute percentages
data$fraction <- data$count / sum(data$count)

# Compute the cumulative percentages (top of each rectangle)
data$ymax <- cumsum(data$fraction)

# Compute the bottom of each rectangle
data$ymin <- c(0, head(data$ymax, n=-1))

# Compute label position
data$labelPosition <- (data$ymax + data$ymin) / 2

# Compute a good label
data$label <- paste0(data$category, "\n value: ", data$count)

# Make the plot
ggplot(data, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=category)) +
  geom_rect() +
  geom_label( x=3.5, aes(y=labelPosition, label=label), size=3) +
  scale_fill_brewer(palette=4) +
  coord_polar(theta="y") +
  xlim(c(1, 4)) +
  theme_void() +s
  theme(legend.position = "none")

# change duration plot

# Create data
data <- data.frame(
  name=c("API Change", "Syntactic Change", "Semantic Change") ,  
  value=as.numeric(c(average_duration_api_stage4, average_duration_syntactic_stage4, average_duration_semantic_stage4)),
  sd=as.numeric(c(sd_api_stage4, sd_syntactic_stage4, sd_semantic_stage4)
))

# Barplot
ggplot(data, aes(x=name, y=value, fill = name)) + 
  geom_bar(stat = "identity", width=0.2) + 
  geom_errorbar(aes(x=name, ymin=value-sd, ymax= value+sd), width=0.4, colour="orange", alpha=0.9) +
  geom_text(aes(label = round(value, 1)), vjust = -0.5, size = 3.5) +
  scale_fill_brewer(palette = "Set1") + 
  labs(x = "Change Type Duration", y = "Time in Months", title = "Stage duration with SD") +
  theme(legend.position="none")

  
#Donut plot for specific classifications stage 4

# Create Data
data <- data.frame(
  category=c("API", "API+Sem", "API+Syn", "API+Syn+Sem", "Sem", "Syn", "Syn+Sem"),
  count=c(nrow(api_Specific_Stage_4), nrow(api_sem_Specific_Stage_4), nrow(api_syn_Specific_Stage_4), nrow(api_syn_sem_Specific_Stage_4), nrow(sem_Specific_Stage_4), nrow(syn_Specific_Stage_4), nrow(syn_sem_Specific_Stage_4))
)

# Compute percentages
data$fraction <- data$count / sum(data$count)

# Compute the cumulative percentages (top of each rectangle)
data$ymax <- cumsum(data$fraction)

# Place the count per category in the legend
data$category <- paste0(data$category, " (", data$count, ")")

# Compute the bottom of each rectangle
data$ymin <- c(0, head(data$ymax, n=-1))

# Compute label position
data$labelPosition <- (data$ymax + data$ymin) / 2

# Compute a good label
data$label <- paste0(data$category, "\n value: ", data$count)

# Make the plot
ggplot(data = data, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=category)) +
  geom_rect() +
  scale_fill_brewer(palette="Pastel1") +
  coord_polar(theta="y") +
  xlim(c(1, 4)) +
  theme_void() +
  theme(legend.position = "right") + 
  labs(title = ("Specific Classification Distribution at Stage 4"))

#Donut plot for specific classifications stage 3

# Create Data
data <- data.frame(
  category=c("API", "API+Sem", "API+Syn", "API+Syn+Sem", "Sem", "Syn", "Syn+Sem"),
  count=c(nrow(api_Specific_Stage_3), nrow(api_sem_Specific_Stage_3), nrow(api_syn_Specific_Stage_3), nrow(api_syn_sem_Specific_Stage_3), nrow(sem_Specific_Stage_3), nrow(syn_Specific_Stage_3), nrow(syn_sem_Specific_Stage_3))
)

# Compute percentages
data$fraction <- data$count / sum(data$count)

# Compute the cumulative percentages (top of each rectangle)
data$ymax <- cumsum(data$fraction)

# Place the count per category in the legend
data$category <- paste0(data$category, " (", data$count, ")")

# Compute the bottom of each rectangle
data$ymin <- c(0, head(data$ymax, n=-1))

# Compute label position
data$labelPosition <- (data$ymax + data$ymin) / 2

# Compute a good label
data$label <- paste0(data$category, "\n value: ", data$count)

# Make the plot
ggplot(data = data, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=category)) +
  geom_rect() +
  scale_fill_brewer(palette="Pastel1") +
  coord_polar(theta="y") +
  xlim(c(1, 4)) +
  theme_void() +
  theme(legend.position = "right") + 
  labs(title = ("Specific Classification Distribution at Stage 3"))

#Donut plot for specific classifications stage 2.7

# Create Data
data <- data.frame(
  category=c("API", "API+Sem", "API+Syn", "API+Syn+Sem", "Sem", "Syn", "Syn+Sem"),
  count=c(nrow(api_Specific_Stage_3), nrow(api_sem_Specific_Stage_3), nrow(api_syn_Specific_Stage_3), nrow(api_syn_sem_Specific_Stage_3), nrow(sem_Specific_Stage_3), nrow(syn_Specific_Stage_3), nrow(syn_sem_Specific_Stage_3))
)

# Compute percentages
data$fraction <- data$count / sum(data$count)

# Compute the cumulative percentages (top of each rectangle)
data$ymax <- cumsum(data$fraction)

# Place the count per category in the legend
data$category <- paste0(data$category, " (", data$count, ")")

# Compute the bottom of each rectangle
data$ymin <- c(0, head(data$ymax, n=-1))

# Compute label position
data$labelPosition <- (data$ymax + data$ymin) / 2

# Compute a good label
data$label <- paste0(data$category, "\n value: ", data$count)

# Make the plot
ggplot(data = data, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=category)) +
  geom_rect() +
  scale_fill_brewer(palette="Pastel1") +
  coord_polar(theta="y") +
  xlim(c(1, 4)) +
  theme_void() +
  theme(legend.position = "right") + 
  labs(title = ("Specific Classification Distribution at Stage 2.7"))
