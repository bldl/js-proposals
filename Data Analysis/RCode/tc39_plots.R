library(ggplot2)
library(dplyr)
library(reshape2)
library(tidyverse)
library(lubridate)
library(readr)
library(ggrepel)

#Look at single stage
#setwd in Data Analysis
data <- read.csv("CSVFiles/CSVStages/Stage 4.csv")

#setwd in CSVFiles/CSVChanges
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
  labs(title = "Stage 1 Proposals Timeline by Title",
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
  labs(title = "Inactive Proposals Date Distribution per Proposal",
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
      title = "Inactive Proposals Date Spread per Proposal",
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
       x = "Months",
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
  labs(title = "Stage 4 Timeline by Title for API Changes",
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
  labs(title = "Spread per Proposal for API Changes",
       x = "Months",
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
  labs(title = "Stage 4 Timeline by Title for Syntactic Changes",
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
  labs(title = "Stage 4 Date Spread per Proposal for Syntactic Changes",
       x = "Months",
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
       x = "Months",
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
  labs(title = "Stage 4 Semantic Changes",
       x = "Months",
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
  labs(title = "Stage 4 Syntactic Changes",
       x = "Months",
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
  theme_void() +
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
  labs(x = "Change Type Duration", y = "Time in Months", title = "Proposal Duration per Change Type") +
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
  count=c(nrow(api_Specific_Stage_2_7), nrow(api_sem_Specific_Stage_2_7), nrow(api_syn_Specific_Stage_2_7), nrow(api_syn_sem_Specific_Stage_2_7), nrow(sem_Specific_Stage_2_7), nrow(syn_Specific_Stage_2_7), nrow(syn_sem_Specific_Stage_2_7))
)

#Compute percentages
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

#Donut plot for specific classifications stage 2

# Create Data
data <- data.frame(
  category=c("API", "API+Sem", "API+Syn", "API+Syn+Sem", "Sem", "Syn", "Syn+Sem"),
  count=c(nrow(api_Specific_Stage_2), nrow(api_sem_Specific_Stage_2), nrow(api_syn_Specific_Stage_2), nrow(api_syn_sem_Specific_Stage_2), nrow(sem_Specific_Stage_2), nrow(syn_Specific_Stage_2), nrow(syn_sem_Specific_Stage_2))
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
  labs(title = ("Specific Classification Distribution at Stage 2"))

#Donut plot for specific classifications stage 1

# Create Data
data <- data.frame(
  category=c("API", "API+Sem", "API+Syn", "API+Syn+Sem", "Sem", "Syn", "Syn+Sem"),
  count=c(nrow(api_Specific_Stage_1), nrow(api_sem_Specific_Stage_1), nrow(api_syn_Specific_Stage_1), nrow(api_syn_sem_Specific_Stage_1), nrow(sem_Specific_Stage_1), nrow(syn_Specific_Stage_1), nrow(syn_sem_Specific_Stage_1))
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
  labs(title = ("Specific Classification Distribution at Stage 1"))

#Donut plot for specific classifications stage 3

# Create Data
data <- data.frame(
  category=c("API", "API+Sem", "API+Syn", "API+Syn+Sem", "Sem", "Syn", "Syn+Sem"),
  count=c(nrow(api_Specific_Stage_0), nrow(api_sem_Specific_Stage_0), nrow(api_syn_Specific_Stage_0), nrow(api_syn_sem_Specific_Stage_0), nrow(sem_Specific_Stage_0), nrow(syn_Specific_Stage_0), nrow(syn_sem_Specific_Stage_0))
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
  labs(title = ("Specific Classification Distribution at Stage 0"))

#Donut plot for specific classifications stage Inactive

# Create Data
data <- data.frame(
  category=c("API", "API+Sem", "API+Syn", "API+Syn+Sem", "Sem", "Syn", "Syn+Sem"),
  count=c(nrow(api_Specific_Stage_Inactive), nrow(api_sem_Specific_Stage_Inactive), nrow(api_syn_Specific_Stage_Inactive), nrow(api_syn_sem_Specific_Stage_Inactive), nrow(sem_Specific_Stage_Inactive), nrow(syn_Specific_Stage_Inactive), nrow(syn_sem_Specific_Stage_Inactive))
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
  labs(title = ("Specific Classification Distribution at Inactive"))















# specific changes api stage 4

#Look at single stage
data <- read.csv("CSVFiles/SpecificChanges/Stage 4/api Specific Stage 4.csv")

#setwd in CSVFiles
#file_list <- list.files()
#load_files <- lapply(file_list, read.csv)
#data <- do.call("rbind", load_files)

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
  labs(title = "Proposal Stage 4 Timeline by Title for API Specific Changes",
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
    StageDuration = interval(Date, lead(Date)) %/% months(1),
    MonthsSinceStart = interval(min(Date), Date) %/% months(1),
    Duration = interval(min(Date), max(Date))%/% months(1)) 

average_duration_specific_api_stage4 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(AverageDuration = mean(Duration, na.rm=TRUE))

sd_specific_api_stage4 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(SD_api = sd(Duration, na.rm=TRUE))

stage_duration_specific_api_stage4 <- title_durations %>%
  group_by(Stage) %>%
  summarize(AverageStageDuration = mean(StageDuration, na.rm=TRUE))

sd_specific_stage_duration_api_stage4 <- title_durations %>%
  group_by(Stage) %>%
  summarize(SD_AverageStageDuration = sd(StageDuration, na.rm=TRUE))

print(average_duration_specific_api_stage4)
print(sd_specific_api_stage4)
print(stage_duration_specific_api_stage4)
print(sd_specific_stage_duration_api_stage4)

# Plot
ggplot(title_durations, aes(x = MonthsSinceStart, y = reorder(Title, -Duration))) +
  geom_boxplot(outlier.shape = 8, outlier.size = 2.5, fill = "white") +
  geom_point(aes(color = Stage), size = 1) +
  labs(title = "Stage 4 Specific API Changes",
       x = "Months",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()

#Create bar plot for changes duration
data <- data.frame(
  name=c("Stage 1", "Stage 2", "Stage 2.7", "Stage 3", "Stage 4"),  
  value=as.numeric(unlist(stage_duration_specific_api_stage4)),
  sd=as.numeric(unlist(sd_specific_stage_duration_api_stage4))
)


data_no_stage4 <- data %>%
  filter(name != "Stage 4") %>%
  filter(value > 0)

# Barplot
ggplot(data_no_stage4, aes(x=name, y=value, fill = name)) + 
  geom_bar(stat = "identity", width=0.2) + 
  geom_errorbar(aes(x=name, ymin=value-sd, ymax= value+sd), width=0.4, colour="orange", alpha=0.9) +
  geom_text(aes(label = round(value, 1)), vjust = -0.5, size = 3.5) +
  scale_fill_brewer(palette = "Set1") + 
  labs(x = "Change Type", y = "Time in Months", title = "API Change Stage 4 durations with SD") +
  theme(legend.position="none")








# specific changes api+sem stage 4

#Look at single stage
data <- read.csv("CSVFiles/SpecificChanges/Stage 4/api_sem Specific Stage 4.csv")

#setwd in CSVFiles
#file_list <- list.files()
#load_files <- lapply(file_list, read.csv)
#data <- do.call("rbind", load_files)

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
  labs(title = "Proposal Stage 4 Timeline by Title for API+Sem Changes",
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
    StageDuration = interval(Date, lead(Date)) %/% months(1),
    MonthsSinceStart = interval(min(Date), Date) %/% months(1),
    Duration = interval(min(Date), max(Date))%/% months(1)) 

average_duration_specific_api_sem_stage4 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(AverageDuration = mean(Duration, na.rm=TRUE))

sd_specific_api_sem_stage4 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(SD_api_sem = sd(Duration, na.rm=TRUE))

stage_duration_specific_api_sem_stage4 <- title_durations %>%
  group_by(Stage) %>%
  summarize(AverageStageDuration = mean(StageDuration, na.rm=TRUE))

sd_specific_stage_duration_api_sem_stage4 <- title_durations %>%
  group_by(Stage) %>%
  summarize(SD_AverageStageDuration = sd(StageDuration, na.rm=TRUE))

print(average_duration_specific_api_sem_stage4)
print(sd_specific_api_sem_stage4)
print(stage_duration_specific_api_sem_stage4)
print(sd_specific_stage_duration_api_sem_stage4)


# Plot
ggplot(title_durations, aes(x = MonthsSinceStart, y = reorder(Title, -Duration))) +
  geom_boxplot(outlier.shape = 8, outlier.size = 2.5, fill = "white") +
  geom_point(aes(color = Stage), size = 1) +
  labs(title = "Stage 4 Specific API+Sem Changes",
       x = "Months",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()

#Create bar plot for changes duration
data <- data.frame(
  name=c("Stage 1", "Stage 2", "Stage 3", "Stage 4"),  
  value=as.numeric(unlist(stage_duration_specific_api_sem_stage4)),
  sd=as.numeric(unlist(sd_specific_stage_duration_api_sem_stage4))
)

data_no_stage4 <- data %>%
  filter(name != "Stage 4")

# Barplot
ggplot(data_no_stage4, aes(x=name, y=value, fill = name)) + 
  geom_bar(stat = "identity", width=0.2) + 
  geom_errorbar(aes(x=name, ymin=value-sd, ymax= value+sd), width=0.4, colour="orange", alpha=0.9) +
  geom_text(aes(label = round(value, 1)), vjust = -0.5, size = 3.5) +
  scale_fill_brewer(palette = "Set1") + 
  labs(x = "Change Type", y = "Time in Months", title = "API+Sem Change Stage 4 durations with SD") +
  theme(legend.position="none")









# specific changes api+syn stage 4

#Look at single stage
data <- read.csv("CSVFiles/SpecificChanges/Stage 4/api_syn Specific Stage 4.csv")

#setwd in CSVFiles
#file_list <- list.files()
#load_files <- lapply(file_list, read.csv)
#data <- do.call("rbind", load_files)

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
  labs(title = "Proposal Stage 4 Timeline by Title for API+Syn Changes",
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
    StageDuration = interval(Date, lead(Date)) %/% months(1),
    MonthsSinceStart = interval(min(Date), Date) %/% months(1),
    Duration = interval(min(Date), max(Date))%/% months(1)) 

average_duration_specific_api_syn_stage4 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(AverageDuration = mean(Duration, na.rm=TRUE))

sd_specific_api_syn_stage4 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(SD_api_syn = sd(Duration, na.rm=TRUE))

stage_duration_specific_api_syn_stage4 <- title_durations %>%
  group_by(Stage) %>%
  summarize(AverageStageDuration = mean(StageDuration, na.rm=TRUE))

sd_specific_stage_duration_api_syn_stage4 <- title_durations %>%
  group_by(Stage) %>%
  summarize(SD_AverageStageDuration = sd(StageDuration, na.rm=TRUE))

print(average_duration_specific_api_syn_stage4)
print(sd_specific_api_syn_stage4)
print(stage_duration_specific_api_syn_stage4)
print(sd_specific_stage_duration_api_syn_stage4)

# Plot
ggplot(title_durations, aes(x = MonthsSinceStart, y = reorder(Title, -Duration))) +
  geom_boxplot(outlier.shape = 8, outlier.size = 2.5, fill = "white") +
  geom_point(aes(color = Stage), size = 1) +
  labs(title = "Stage 4 Specific Api+Syn Changes",
       x = "Months",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()

#Create bar plot for changes duration
data <- data.frame(
  name=c("Stage 1", "Stage 2", "Stage 3", "Stage 4"),  
  value=as.numeric(unlist(stage_duration_specific_api_syn_stage4)),
  sd=as.numeric(unlist(sd_specific_stage_duration_api_syn_stage4))
)


data_no_stage4 <- data %>%
  filter(name != "Stage 4")

# Barplot
ggplot(data_no_stage4, aes(x=name, y=value, fill = name)) + 
  geom_bar(stat = "identity", width=0.2) + 
  geom_errorbar(aes(x=name, ymin=value-sd, ymax= value+sd), width=0.4, colour="orange", alpha=0.9) +
  geom_text(aes(label = round(value, 1)), vjust = -0.5, size = 3.5) +
  scale_fill_brewer(palette = "Set1") + 
  labs(x = "Change Type", y = "Time in Months", title = "API+Syn Change Stage 4 durations with SD") +
  theme(legend.position="none")









# specific changes api+sem stage 4

#Look at single stage
data <- read.csv("CSVFiles/SpecificChanges/Stage 4/syn_sem Specific Stage 4.csv")

#setwd in CSVFiles
#file_list <- list.files()
#load_files <- lapply(file_list, read.csv)
#data <- do.call("rbind", load_files)

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
  labs(title = "Proposal Stage 4 Timeline by Title for Syn+Sem Changes",
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
    StageDuration = interval(Date, lead(Date)) %/% months(1),
    MonthsSinceStart = interval(min(Date), Date) %/% months(1),
    Duration = interval(min(Date), max(Date))%/% months(1)) 

average_duration_specific_syn_sem_stage4 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(AverageDuration = mean(Duration, na.rm=TRUE))

sd_specific_syn_sem_stage4 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(SD_syn_sem = sd(Duration, na.rm=TRUE))

stage_duration_specific_syn_sem_stage4 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(AverageStageDuration = mean(StageDuration, na.rm=TRUE))

sd_specific_stage_duration_syn_sem_stage4 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(SD_AverageStageDuration = sd(StageDuration, na.rm=TRUE))


print(average_duration_specific_syn_sem_stage4)
print(sd_specific_syn_sem_stage4)
print(stage_duration_specific_syn_sem_stage4)
print(sd_specific_stage_duration_syn_sem_stage4)


# Plot
ggplot(title_durations, aes(x = MonthsSinceStart, y = reorder(Title, -Duration))) +
  geom_boxplot(outlier.shape = 8, outlier.size = 2.5, fill = "white") +
  geom_point(aes(color = Stage), size = 1) +
  labs(title = "Stage 4 Specific Syn+Sem Changes",
       x = "Months",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()

#Create bar plot for changes duration
data <- data.frame(
  name=c("Stage 1", "Stage 2", "Stage 3", "Stage 4"),  
  value=as.numeric(unlist(stage_duration_specific_syn_sem_stage4)),
  sd=as.numeric(unlist(sd_specific_stage_duration_syn_sem_stage4))
)


data_no_stage4 <- data %>%
  filter(name != "Stage 4")

# Barplot
ggplot(data_no_stage4, aes(x=name, y=value, fill = name)) + 
  geom_bar(stat = "identity", width=0.2) + 
  geom_errorbar(aes(x=name, ymin=value-sd, ymax= value+sd), width=0.4, colour="orange", alpha=0.9) +
  geom_text(aes(label = round(value, 1)), vjust = -0.5, size = 3.5) +
  scale_fill_brewer(palette = "Set1") + 
  labs(x = "Change Type", y = "Time in Months", title = "Syn+Sem Change Stage 4 durations with SD") +
  theme(legend.position="none")


# specific changes semantic stage 4

#Look at single stage
data <- read.csv("CSVFiles/SpecificChanges/Stage 4/sem Specific Stage 4.csv")

#setwd in CSVFiles
#file_list <- list.files()
#load_files <- lapply(file_list, read.csv)
#data <- do.call("rbind", load_files)

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
  labs(title = "Proposal Stage 4 Timeline by Title for Sem Changes",
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
    StageDuration = interval(Date, lead(Date)) %/% months(1),
    MonthsSinceStart = interval(min(Date), Date) %/% months(1),
    Duration = interval(min(Date), max(Date))%/% months(1)) 

average_duration_specific_sem_stage4 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(AverageDuration = mean(Duration, na.rm=TRUE))

sd_specific_sem_stage4 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(SD_sem = sd(Duration, na.rm=TRUE))

stage_duration_specific_sem_stage4 <- title_durations %>%
  group_by(Stage) %>%
  summarize(AverageStageDuration = mean(StageDuration, na.rm=TRUE))

sd_specific_stage_duration_sem_stage4 <- title_durations %>%
  group_by(Stage) %>%
  summarize(SD_AverageStageDuration = sd(StageDuration, na.rm=TRUE))

print(average_duration_specific_sem_stage4)
print(sd_specific_sem_stage4)
print(stage_duration_specific_sem_stage4)
print(sd_specific_stage_duration_sem_stage4)

# Plot
ggplot(title_durations, aes(x = MonthsSinceStart, y = reorder(Title, -Duration))) +
  geom_boxplot(outlier.shape = 8, outlier.size = 2.5, fill = "white") +
  geom_point(aes(color = Stage), size = 1) +
  labs(title = "Stage 4 Specific Sem Changes",
       x = "Date",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()

#Create bar plot for changes duration
data <- data.frame(
  name=c("Stage 1", "Stage 2", "Stage 3", "Stage 4"),  
  value=as.numeric(unlist(stage_duration_specific_sem_stage4)),
  sd=as.numeric(unlist(sd_specific_stage_duration_sem_stage4))
)


data_no_stage4 <- data %>%
  filter(name != "Stage 4")

# Barplot
ggplot(data_no_stage4, aes(x=name, y=value, fill = name)) + 
  geom_bar(stat = "identity", width=0.2) + 
  geom_errorbar(aes(x=name, ymin=value-sd, ymax= value+sd), width=0.4, colour="orange", alpha=0.9) +
  geom_text(aes(label = round(value, 1)), vjust = -0.5, size = 3.5) +
  scale_fill_brewer(palette = "Set1") + 
  labs(x = "Change Type", y = "Time in Months", title = "Sem Change Stage 4 durations with SD") +
  theme(legend.position="none")


# specific changes Syntactic stage 4

#Look at single stage
data <- read.csv("CSVFiles/SpecificChanges/Stage 4/syn Specific Stage 4.csv")

#setwd in CSVFiles
#file_list <- list.files()
#load_files <- lapply(file_list, read.csv)
#data <- do.call("rbind", load_files)

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
  labs(title = "Proposal Stage 4 Timeline by Title for Syn Changes",
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
    StageDuration = interval(Date, lead(Date)) %/% months(1),
    MonthsSinceStart = interval(min(Date), Date) %/% months(1),
    Duration = interval(min(Date), max(Date))%/% months(1)) 

average_duration_specific_syn_stage4 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(AverageDuration = mean(Duration, na.rm=TRUE))

sd_specific_syn_stage4 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(SD_syn = sd(Duration, na.rm=TRUE))

stage_duration_specific_syn_stage4 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(AverageStageDuration = mean(StageDuration, na.rm=TRUE))

sd_specific_stage_duration_syn_stage4 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(SD_AverageStageDuration = sd(StageDuration, na.rm=TRUE))

print(average_duration_specific_syn_stage4)
print(sd_specific_syn_stage4)
print(stage_duration_specific_syn_stage4)
print(sd_specific_stage_duration_syn_stage4)


# Plot
ggplot(title_durations, aes(x = MonthsSinceStart, y = reorder(Title, -Duration))) +
  geom_boxplot(outlier.shape = 8, outlier.size = 2.5, fill = "white") +
  geom_point(aes(color = Stage), size = 1) +
  labs(title = "Stage 4 Specific Syn Changes",
       x = "Months",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()

#Create bar plot for changes duration
data <- data.frame(
  name=c("Stage 1", "Stage 2", "Stage 3", "Stage 4"),  
  value=as.numeric(unlist(stage_duration_specific_syn_stage4)),
  sd=as.numeric(unlist(sd_specific_stage_duration_syn_stage4))
)


data_no_stage4 <- data %>%
  filter(name != "Stage 4")

# Barplot
ggplot(data_no_stage4, aes(x=name, y=value, fill = name)) + 
  geom_bar(stat = "identity", width=0.2) + 
  geom_errorbar(aes(x=name, ymin=value-sd, ymax= value+sd), width=0.4, colour="orange", alpha=0.9) +
  geom_text(aes(label = round(value, 1)), vjust = -0.5, size = 3.5) +
  scale_fill_brewer(palette = "Set1") + 
  labs(x = "Change Type", y = "Time in Months", title = "Syn Change Stage 4 durations with SD") +
  theme(legend.position="none")


# specific changes Syntactic stage 4

#Look at single stage
data <- read.csv("CSVFiles/SpecificChanges/Stage 4/api_syn_sem Specific Stage 4.csv")

#setwd in CSVFiles
#file_list <- list.files()
#load_files <- lapply(file_list, read.csv)
#data <- do.call("rbind", load_files)

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
  labs(title = "Proposal Stage Timeline by Title for API Syn Sem Changes",
       x = "Months",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()

#Plot4
# ordered boxplots with months in x axis

# Recompute duration in months
title_durations <- data_long %>%
  group_by(Title) %>%
  mutate(
    StageDuration = interval(Date, lead(Date)) %/% months(1),
    MonthsSinceStart = interval(min(Date), Date) %/% months(1),
    Duration = interval(min(Date), max(Date))%/% months(1)) 

average_duration_specific_api_syn_sem_stage4 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(AverageDuration = mean(Duration, na.rm=TRUE))

sd_specific_api_syn_sem_stage4 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(SD_api_syn_sem = sd(Duration, na.rm=TRUE))

stage_duration_specific_api_syn_sem_stage4 <- title_durations %>%
  group_by(Stage) %>%
  summarize(AverageStageDuration = mean(StageDuration, na.rm=TRUE))

sd_specific_stage_duration_api_syn_sem_stage4 <- title_durations %>%
  group_by(Stage) %>%
  summarize(SD_AverageStageDuration = sd(StageDuration, na.rm=TRUE))

print(average_duration_specific_api_syn_sem_stage4)
print(sd_specific_api_syn_sem_stage4)
print(stage_duration_specific_api_syn_sem_stage4)
print(sd_specific_stage_duration_api_syn_sem_stage4)

# Plot
ggplot(title_durations, aes(x = MonthsSinceStart, y = reorder(Title, -Duration))) +
  geom_boxplot(outlier.shape = 8, outlier.size = 2.5, fill = "white") +
  geom_point(aes(color = Stage), size = 1) +
  labs(title = "Stage 4 Specific API Sem Syn Changes",
       x = "Date",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()


#Create bar plot for changes duration
data <- data.frame(
  name=c("API", "Syn", "Sem", "API and Sem", "API and Syn", "Sem and Syn", "API, Sem and Syn") ,  
  value=as.numeric(c(average_duration_specific_api_stage4, average_duration_specific_syn_stage4, average_duration_specific_sem_stage4, average_duration_specific_api_sem_stage4, average_duration_specific_api_syn_stage4, average_duration_specific_syn_sem_stage4, average_duration_specific_api_syn_sem_stage4)),
  sd=as.numeric(c(sd_specific_api_stage4, sd_specific_syn_stage4, sd_specific_sem_stage4, sd_specific_api_sem_stage4, sd_specific_api_syn_stage4, sd_specific_syn_sem_stage4, sd_specific_api_syn_sem_stage4)
  ))

# Barplot
ggplot(data, aes(x=name, y=value, fill = name)) + 
  geom_bar(stat = "identity", width=0.2) + 
  geom_errorbar(aes(x=name, ymin=value-sd, ymax= value+sd), width=0.4, colour="orange", alpha=0.9) +
  geom_text(aes(label = round(value, 1)), vjust = -0.5, size = 3.5) +
  scale_fill_brewer(palette = "Set1") + 
  labs(x = "Change Type", y = "Time in Months", title = "Stage 4: Time from Stage 1 to Stage 4") +
  theme(legend.position="none")









# specific changes api stage 3

#Look at single stage
data <- read.csv("CSVFiles/SpecificChanges/Stage 3/api Specific Stage 3.csv")

#setwd in CSVFiles
#file_list <- list.files()
#load_files <- lapply(file_list, read.csv)
#data <- do.call("rbind", load_files)

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
  labs(title = "Proposal Stage 3 Timeline by Title for API Specific Changes",
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
    StageDuration = interval(Date, lead(Date)) %/% months(1),
    MonthsSinceStart = interval(min(Date), Date) %/% months(1),
    Duration = interval(min(Date), max(Date))%/% months(1)) 

average_duration_specific_api_stage3 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(AverageDuration = mean(Duration, na.rm=TRUE))

sd_specific_api_stage3 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(SD_api = sd(Duration, na.rm=TRUE))

stage_duration_specific_api_stage3 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(AverageStageDuration = mean(StageDuration, na.rm=TRUE))

sd_specific_stage_duration_api_stage3 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(SD_AverageStageDuration = sd(StageDuration, na.rm=TRUE))

print(average_duration_specific_api_stage3)
print(sd_specific_api_stage3)
print(stage_duration_specific_api_stage3)
print(sd_specific_stage_duration_api_stage3)


# Plot
ggplot(title_durations, aes(x = MonthsSinceStart, y = reorder(Title, -Duration))) +
  geom_boxplot(outlier.shape = 8, outlier.size = 2.5, fill = "white") +
  geom_point(aes(color = Stage), size = 1) +
  labs(title = "Stage 3 Specific API Changes",
       x = "Months",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()

# specific changes api+sem stage 3

#Look at single stage
data <- read.csv("CSVFiles/SpecificChanges/Stage 3/api_sem Specific Stage 3.csv")

#setwd in CSVFiles
#file_list <- list.files()
#load_files <- lapply(file_list, read.csv)
#data <- do.call("rbind", load_files)

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
  labs(title = "Proposal Stage 3 Timeline by Title for API+Sem Changes",
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
    StageDuration = interval(Date, lead(Date)) %/% months(1),
    MonthsSinceStart = interval(min(Date), Date) %/% months(1),
    Duration = interval(min(Date), max(Date))%/% months(1)) 

average_duration_specific_api_sem_stage3 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(AverageDuration = mean(Duration, na.rm=TRUE))

sd_specific_api_sem_stage3 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(SD_api_sem = sd(Duration, na.rm=TRUE))

stage_duration_specific_api_sem_stage3 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(AverageStageDuration = mean(StageDuration, na.rm=TRUE))

sd_specific_stage_duration_api_sem_stage3 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(SD_AverageStageDuration = sd(StageDuration, na.rm=TRUE))

print(average_duration_specific_api_sem_stage3)
print(sd_specific_api_sem_stage3)
print(stage_duration_specific_api_sem_stage3)
print(sd_specific_stage_duration_api_sem_stage3)


# Plot
ggplot(title_durations, aes(x = MonthsSinceStart, y = reorder(Title, -Duration))) +
  geom_boxplot(outlier.shape = 8, outlier.size = 2.5, fill = "white") +
  geom_point(aes(color = Stage), size = 1) +
  labs(title = "Stage 3 Specific API+Sem Changes",
       x = "Months",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()


# specific changes api+syn stage 3

#Look at single stage
data <- read.csv("CSVFiles/SpecificChanges/Stage 3/api_syn Specific Stage 3.csv")

#setwd in CSVFiles
#file_list <- list.files()
#load_files <- lapply(file_list, read.csv)
#data <- do.call("rbind", load_files)

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
  labs(title = "Proposal Stage 3 Timeline by Title for API+Syn Changes",
       x = "Months",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()

#Plot4
# ordered boxplots with months in x axis

# Recompute duration in months
title_durations <- data_long %>%
  group_by(Title) %>%
  mutate(
    StageDuration = interval(Date, lead(Date)) %/% months(1),
    MonthsSinceStart = interval(min(Date), Date) %/% months(1),
    Duration = interval(min(Date), max(Date))%/% months(1)) 

average_duration_specific_api_syn_stage3 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(AverageDuration = mean(Duration, na.rm=TRUE))

sd_specific_api_syn_stage3 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(SD_api_syn = sd(Duration, na.rm=TRUE))

stage_duration_specific_api_syn_stage3 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(AverageStageDuration = mean(StageDuration, na.rm=TRUE))

sd_specific_stage_duration_api_syn_stage3 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(SD_AverageStageDuration = sd(StageDuration, na.rm=TRUE))

print(average_duration_specific_api_syn_stage3)
print(sd_specific_api_syn_stage3)
print(stage_duration_specific_api_syn_stage3)
print(sd_specific_stage_duration_api_syn_stage3)


# Plot
ggplot(title_durations, aes(x = MonthsSinceStart, y = reorder(Title, -Duration))) +
  geom_boxplot(outlier.shape = 8, outlier.size = 2.5, fill = "white") +
  geom_point(aes(color = Stage), size = 1) +
  labs(title = "Stage 3 Specific Api+Syn Changes",
       x = "Date",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()


# specific changes api+sem stage 3

#Look at single stage
data <- read.csv("CSVFiles/SpecificChanges/Stage 3/syn_sem Specific Stage 3.csv")

#setwd in CSVFiles
#file_list <- list.files()
#load_files <- lapply(file_list, read.csv)
#data <- do.call("rbind", load_files)

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
  labs(title = "Proposal Stage 3 Timeline by Title for Syn+Sem Changes",
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
    StageDuration = interval(Date, lead(Date)) %/% months(1),
    MonthsSinceStart = interval(min(Date), Date) %/% months(1),
    Duration = interval(min(Date), max(Date))%/% months(1)) 

average_duration_specific_syn_sem_stage3 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(AverageDuration = mean(Duration, na.rm=TRUE))

sd_specific_syn_sem_stage3 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(SD_syn_sem = sd(Duration, na.rm=TRUE))

stage_duration_specific_syn_sem_stage3 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(AverageStageDuration = mean(StageDuration, na.rm=TRUE))

sd_specific_stage_duration_syn_sem_stage3 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(SD_AverageStageDuration = sd(StageDuration, na.rm=TRUE))

print(average_duration_specific_syn_sem_stage3)
print(sd_specific_syn_sem_stage3)
print(stage_duration_specific_syn_sem_stage3)
print(sd_specific_stage_duration_syn_sem_stage3)


# Plot
ggplot(title_durations, aes(x = MonthsSinceStart, y = reorder(Title, -Duration))) +
  geom_boxplot(outlier.shape = 8, outlier.size = 2.5, fill = "white") +
  geom_point(aes(color = Stage), size = 1) +
  labs(title = "Stage 3 Specific Syn+Sem Changes",
       x = "Months",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()



# specific changes semantic stage 3

#Look at single stage
data <- read.csv("CSVFiles/SpecificChanges/Stage 3/sem Specific Stage 3.csv")

#setwd in CSVFiles
#file_list <- list.files()
#load_files <- lapply(file_list, read.csv)
#data <- do.call("rbind", load_files)

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
  labs(title = "Proposal Stage 3 Timeline by Title for Sem Changes",
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
    StageDuration = interval(Date, lead(Date)) %/% months(1),
    MonthsSinceStart = interval(min(Date), Date) %/% months(1),
    Duration = interval(min(Date), max(Date))%/% months(1)) 

average_duration_specific_sem_stage3 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(AverageDuration = mean(Duration, na.rm=TRUE))

sd_specific_sem_stage3 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(SD_sem = sd(Duration, na.rm=TRUE))

stage_duration_specific_sem_stage3 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(AverageStageDuration = mean(StageDuration, na.rm=TRUE))

sd_specific_stage_duration_sem_stage3 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(SD_AverageStageDuration = sd(StageDuration, na.rm=TRUE))

print(average_duration_specific_sem_stage3)
print(sd_specific_sem_stage3)
print(stage_duration_specific_sem_stage3)
print(sd_specific_stage_duration_sem_stage3)

# Plot
ggplot(title_durations, aes(x = MonthsSinceStart, y = reorder(Title, -Duration))) +
  geom_boxplot(outlier.shape = 8, outlier.size = 2.5, fill = "white") +
  geom_point(aes(color = Stage), size = 1) +
  labs(title = "Stage 3 Specific Sem Changes",
       x = "Months",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()


# specific changes Syntactic stage 3

#Look at single stage
data <- read.csv("CSVFiles/SpecificChanges/Stage 3/syn Specific Stage 3.csv")

#setwd in CSVFiles
#file_list <- list.files()
#load_files <- lapply(file_list, read.csv)
#data <- do.call("rbind", load_files)

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
  labs(title = "Proposal Stage Timeline by Title for Syn Changes",
       x = "Months",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()

#Plot4
# ordered boxplots with months in x axis

# Recompute duration in months
title_durations <- data_long %>%
  group_by(Title) %>%
  mutate(
    StageDuration = interval(Date, lead(Date)) %/% months(1),
    MonthsSinceStart = interval(min(Date), Date) %/% months(1),
    Duration = interval(min(Date), max(Date))%/% months(1)) 

average_duration_specific_syn_stage3 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(AverageDuration = mean(Duration, na.rm=TRUE))

sd_specific_syn_stage3 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(SD_syn = sd(Duration, na.rm=TRUE))

stage_duration_specific_syn_stage3 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(AverageStageDuration = mean(StageDuration, na.rm=TRUE))

sd_specific_stage_duration_syn_stage3 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(SD_AverageStageDuration = sd(StageDuration, na.rm=TRUE))

print(average_duration_specific_syn_stage3)
print(sd_specific_syn_stage3)
print(stage_duration_specific_syn_stage3)
print(sd_specific_stage_duration_syn_stage3)


# Plot
ggplot(title_durations, aes(x = MonthsSinceStart, y = reorder(Title, -Duration))) +
  geom_boxplot(outlier.shape = 8, outlier.size = 2.5, fill = "white") +
  geom_point(aes(color = Stage), size = 1) +
  labs(title = "Stage 3 Specific syn Changes",
       x = "Date",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()


# specific changes Syntactic stage 3

#Look at single stage
data <- read.csv("CSVFiles/SpecificChanges/Stage 3/api_syn_sem Specific Stage 3.csv")

#setwd in CSVFiles
#file_list <- list.files()
#load_files <- lapply(file_list, read.csv)
#data <- do.call("rbind", load_files)

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
  labs(title = "Proposal Stage 3 Timeline by Title for API Syn Sem Changes",
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
    StageDuration = interval(Date, lead(Date)) %/% months(1),
    MonthsSinceStart = interval(min(Date), Date) %/% months(1),
    Duration = interval(min(Date), max(Date))%/% months(1)) 

average_duration_specific_api_syn_sem_stage3 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(AverageDuration = mean(Duration, na.rm=TRUE))

sd_specific_api_syn_sem_stage3 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(SD_api_syn_sem = sd(Duration, na.rm=TRUE))

stage_duration_specific_api_syn_sem_stage3 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(AverageStageDuration = mean(StageDuration, na.rm=TRUE))

sd_specific_stage_duration_api_syn_sem_stage3 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(SD_AverageStageDuration = sd(StageDuration, na.rm=TRUE))

print(average_duration_specific_api_syn_sem_stage3)
print(sd_specific_api_syn_sem_stage3)
print(stage_duration_specific_api_syn_sem_stage3)
print(sd_specific_stage_duration_api_syn_sem_stage3)

# Plot
ggplot(title_durations, aes(x = MonthsSinceStart, y = reorder(Title, -Duration))) +
  geom_boxplot(outlier.shape = 8, outlier.size = 2.5, fill = "white") +
  geom_point(aes(color = Stage), size = 1) +
  labs(title = "Stage 3 Specific API Sem Syn Changes",
       x = "Months",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()

#Create bar plot for changes duration
data <- data.frame(
  name=c("API", "Syn", "Sem", "API and Sem", "API and Syn", "Sem and Syn", "API, Sem and Syn") ,  
  value=as.numeric(c(average_duration_specific_api_stage3, average_duration_specific_syn_stage3, average_duration_specific_sem_stage3, average_duration_specific_api_sem_stage3, average_duration_specific_api_syn_stage3, average_duration_specific_syn_sem_stage3, average_duration_specific_api_syn_sem_stage3)),
  sd=as.numeric(c(sd_specific_api_stage3, sd_specific_syn_stage3, sd_specific_sem_stage3, sd_specific_api_sem_stage3, sd_specific_api_syn_stage3, sd_specific_syn_sem_stage3, sd_specific_api_syn_sem_stage3)
  ))

# Barplot
ggplot(data, aes(x=name, y=value, fill = name)) + 
  geom_bar(stat = "identity", width=0.2) + 
  geom_errorbar(aes(x=name, ymin=value-sd, ymax= value+sd), width=0.4, colour="orange", alpha=0.9) +
  geom_text(aes(label = round(value, 1)), vjust = -0.5, size = 3.5) +
  scale_fill_brewer(palette = "Set1") + 
  labs(x = "Change Type", y = "Time in Months", title = "Stage 3: Time from Stage 1 to Stage 3") +
  theme(legend.position="none")


















# specific changes api stage 2.7

#Look at single stage
data <- read.csv("CSVFiles/SpecificChanges/Stage 2.7/api Specific Stage 2.7.csv")

#setwd in CSVFiles
#file_list <- list.files()
#load_files <- lapply(file_list, read.csv)
#data <- do.call("rbind", load_files)

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
  labs(title = "Proposal Stage 2.7 Timeline by Title for API Specific Changes",
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
    StageDuration = interval(Date, lead(Date)) %/% months(1),
    MonthsSinceStart = interval(min(Date), Date) %/% months(1),
    Duration = interval(min(Date), max(Date))%/% months(1)) 

average_duration_specific_api_stage2_7 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(AverageDuration = mean(Duration, na.rm=TRUE))

sd_specific_api_stage2_7 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(SD_api = sd(Duration, na.rm=TRUE))

stage_duration_specific_api_stage2_7 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(AverageStageDuration = mean(StageDuration, na.rm=TRUE))

sd_specific_stage_duration_api_stage2_7 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(SD_AverageStageDuration = sd(StageDuration, na.rm=TRUE))

print(average_duration_specific_api_stage2_7)
print(sd_specific_api_stage2_7)
print(stage_duration_specific_api_stage2_7)
print(sd_specific_stage_duration_api_stage2_7)


# Plot
ggplot(title_durations, aes(x = MonthsSinceStart, y = reorder(Title, -Duration))) +
  geom_boxplot(outlier.shape = 8, outlier.size = 2.5, fill = "white") +
  geom_point(aes(color = Stage), size = 1) +
  labs(title = "Stage 2.7 Specific API Changes",
       x = "Months",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()

# specific changes api+sem stage 2.7

#Look at single stage
data <- read.csv("CSVFiles/SpecificChanges/Stage 2.7/api_sem Specific Stage 2.7.csv")

#setwd in CSVFiles
#file_list <- list.files()
#load_files <- lapply(file_list, read.csv)
#data <- do.call("rbind", load_files)

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
  labs(title = "Proposal Stage 2.7 Timeline by Title for API+Sem Changes",
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
    StageDuration = interval(Date, lead(Date)) %/% months(1),
    MonthsSinceStart = interval(min(Date), Date) %/% months(1),
    Duration = interval(min(Date), max(Date))%/% months(1)) 

average_duration_specific_api_sem_stage2_7 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(AverageDuration = mean(Duration, na.rm=TRUE))

sd_specific_api_sem_stage2_7 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(SD_api_sem = sd(Duration, na.rm=TRUE))

stage_duration_specific_api_sem_stage2_7 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(AverageStageDuration = mean(StageDuration, na.rm=TRUE))

sd_specific_stage_duration_api_sem_stage2_7 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(SD_AverageStageDuration = sd(StageDuration, na.rm=TRUE))

print(average_duration_specific_api_sem_stage2_7)
print(sd_specific_api_sem_stage2_7)
print(stage_duration_specific_api_sem_stage2_7)
print(sd_specific_stage_duration_api_sem_stage2_7)


# Plot
ggplot(title_durations, aes(x = MonthsSinceStart, y = reorder(Title, -Duration))) +
  geom_boxplot(outlier.shape = 8, outlier.size = 2.5, fill = "white") +
  geom_point(aes(color = Stage), size = 1) +
  labs(title = "Stage 2.7 Specific API+Sem Changes",
       x = "Months",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()


# specific changes api+syn stage 

#Look at single stage
data <- read.csv("CSVFiles/SpecificChanges/Stage 2.7/api_syn Specific Stage 2.7.csv")

#setwd in CSVFiles
#file_list <- list.files()
#load_files <- lapply(file_list, read.csv)
#data <- do.call("rbind", load_files)

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
  labs(title = "Proposal Stage 2,7 Timeline by Title for API+Syn Changes",
       x = "Months",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()

#Plot4
# ordered boxplots with months in x axis

# Recompute duration in months
title_durations <- data_long %>%
  group_by(Title) %>%
  mutate(
    StageDuration = interval(Date, lead(Date)) %/% months(1),
    MonthsSinceStart = interval(min(Date), Date) %/% months(1),
    Duration = interval(min(Date), max(Date))%/% months(1)) 

average_duration_specific_api_syn_stage2_7 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(AverageDuration = mean(Duration, na.rm=TRUE))

sd_specific_api_syn_stage2_7 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(SD_api_syn = sd(Duration, na.rm=TRUE))

stage_duration_specific_api_syn_stage2_7 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(AverageStageDuration = mean(StageDuration, na.rm=TRUE))

sd_specific_stage_duration_api_syn_stage2_7 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(SD_AverageStageDuration = sd(StageDuration, na.rm=TRUE))

print(average_duration_specific_api_syn_stage2_7)
print(sd_specific_api_syn_stage2_7)
print(stage_duration_specific_api_syn_stage2_7)
print(sd_specific_stage_duration_api_syn_stage2_7)


# Plot
ggplot(title_durations, aes(x = MonthsSinceStart, y = reorder(Title, -Duration))) +
  geom_boxplot(outlier.shape = 8, outlier.size = 2.5, fill = "white") +
  geom_point(aes(color = Stage), size = 1) +
  labs(title = "Stage 2.7 Specific Api+Syn Changes",
       x = "Date",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()


# specific changes api+sem stage 2.7

#Look at single stage
data <- read.csv("CSVFiles/SpecificChanges/Stage 2.7/syn_sem Specific Stage 2.7.csv")

#setwd in CSVFiles
#file_list <- list.files()
#load_files <- lapply(file_list, read.csv)
#data <- do.call("rbind", load_files)

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
  labs(title = "Proposal 2.7 Stage Timeline by Title for Syn+Sem Changes",
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
    StageDuration = interval(Date, lead(Date)) %/% months(1),
    MonthsSinceStart = interval(min(Date), Date) %/% months(1),
    Duration = interval(min(Date), max(Date))%/% months(1)) 

average_duration_specific_syn_sem_stage2_7 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(AverageDuration = mean(Duration, na.rm=TRUE))

sd_specific_syn_sem_stage2_7 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(SD_syn_sem = sd(Duration, na.rm=TRUE))

stage_duration_specific_syn_sem_stage2_7 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(AverageStageDuration = mean(StageDuration, na.rm=TRUE))

sd_specific_stage_duration_syn_sem_stage2_7 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(SD_AverageStageDuration = sd(StageDuration, na.rm=TRUE))

print(average_duration_specific_syn_sem_stage2_7)
print(sd_specific_syn_sem_stage2_7)
print(stage_duration_specific_syn_sem_stage2_7)
print(sd_specific_stage_duration_syn_sem_stage2_7)

# Plot
ggplot(title_durations, aes(x = MonthsSinceStart, y = reorder(Title, -Duration))) +
  geom_boxplot(outlier.shape = 8, outlier.size = 2.5, fill = "white") +
  geom_point(aes(color = Stage), size = 1) +
  labs(title = "Stage 2.7 Specific Syn+Sem Changes",
       x = "Months",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()



# specific changes semantic stage 2.7

#Look at single stage
data <- read.csv("CSVFiles/SpecificChanges/Stage 2.7/sem Specific Stage 2.7.csv")

#setwd in CSVFiles
#file_list <- list.files()
#load_files <- lapply(file_list, read.csv)
#data <- do.call("rbind", load_files)

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
  labs(title = "Proposal Stage Timeline by Title for Sem Changes",
       x = "Months",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()

#Plot4
# ordered boxplots with months in x axis

# Recompute duration in months
title_durations <- data_long %>%
  group_by(Title) %>%
  mutate(
    StageDuration = interval(Date, lead(Date)) %/% months(1),
    MonthsSinceStart = interval(min(Date), Date) %/% months(1),
    Duration = interval(min(Date), max(Date))%/% months(1)) 

average_duration_specific_sem_stage2_7 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(AverageDuration = mean(Duration, na.rm=TRUE))

sd_specific_sem_stage2_7 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(SD_sem = sd(Duration, na.rm=TRUE))

stage_duration_specific_sem_stage2_7 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(AverageStageDuration = mean(StageDuration, na.rm=TRUE))

sd_specific_stage_duration_sem_stage2_7 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(SD_AverageStageDuration = sd(StageDuration, na.rm=TRUE))

print(average_duration_specific_sem_stage2_7)
print(sd_specific_sem_stage2_7)
print(stage_duration_specific_sem_stage2_7)
print(sd_specific_stage_duration_sem_stage2_7)


# Plot
ggplot(title_durations, aes(x = MonthsSinceStart, y = reorder(Title, -Duration))) +
  geom_boxplot(outlier.shape = 8, outlier.size = 2.5, fill = "white") +
  geom_point(aes(color = Stage), size = 1) +
  labs(title = "Stage 2.7 Specific Sem Changes",
       x = "Date",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()


# specific changes Syntactic stage 2.7

#Look at single stage

data <- read.csv("CSVFiles/SpecificChanges/Stage 2.7/syn Specific Stage 2.7.csv")

#setwd in CSVFiles
#file_list <- list.files()
#load_files <- lapply(file_list, read.csv)
#data <- do.call("rbind", load_files)

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
  labs(title = "Proposal Stage Timeline by Title for Syn Changes",
       x = "Months",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()

#Plot4
# ordered boxplots with months in x axis

# Recompute duration in months
title_durations <- data_long %>%
  group_by(Title) %>%
  mutate(
    StageDuration = interval(Date, lead(Date)) %/% months(1),
    MonthsSinceStart = interval(min(Date), Date) %/% months(1),
    Duration = interval(min(Date), max(Date))%/% months(1)) 

average_duration_specific_syn_stage2_7 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(AverageDuration = mean(Duration, na.rm=TRUE))

sd_specific_syn_stage2_7 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(SD_syn = sd(Duration, na.rm=TRUE))

stage_duration_specific_syn_stage2_7 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(AverageStageDuration = mean(StageDuration, na.rm=TRUE))

sd_specific_stage_duration_syn_stage2_7 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(SD_AverageStageDuration = sd(StageDuration, na.rm=TRUE))

print(average_duration_specific_syn_stage2_7)
print(sd_specific_syn_stage2_7)
print(stage_duration_specific_syn_stage2_7)
print(sd_specific_stage_duration_syn_stage2_7)


# Plot
ggplot(title_durations, aes(x = MonthsSinceStart, y = reorder(Title, -Duration))) +
  geom_boxplot(outlier.shape = 8, outlier.size = 2.5, fill = "white") +
  geom_point(aes(color = Stage), size = 1) +
  labs(title = "Stage 2.7 Specific syn Changes",
       x = "Date",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()


# specific changes Syntactic stage 3

#Look at single stage
data <- read.csv("CSVFiles/SpecificChanges/Stage 2.7/api_syn_sem Specific Stage 2.7.csv")

#setwd in CSVFiles
#file_list <- list.files()
#load_files <- lapply(file_list, read.csv)
#data <- do.call("rbind", load_files)

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
  labs(title = "Proposal Stage Timeline by Title for API Syn Sem Changes",
       x = "Months",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()

#Plot4
# ordered boxplots with months in x axis

# Recompute duration in months
title_durations <- data_long %>%
  group_by(Title) %>%
  mutate(
    StageDuration = interval(Date, lead(Date)) %/% months(1),
    MonthsSinceStart = interval(min(Date), Date) %/% months(1),
    Duration = interval(min(Date), max(Date))%/% months(1)) 

average_duration_specific_api_syn_sem_stage2_7 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(AverageDuration = mean(Duration, na.rm=TRUE))

sd_specific_api_syn_sem_stage2_7 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(SD_api_syn_sem = sd(Duration, na.rm=TRUE))

stage_duration_specific_api_syn_sem_stage2_7 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(AverageStageDuration = mean(StageDuration, na.rm=TRUE))

sd_specific_stage_duration_api_syn_sem_stage2_7 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(SD_AverageStageDuration = sd(StageDuration, na.rm=TRUE))

print(average_duration_specific_api_syn_sem_stage2_7)
print(sd_specific_api_syn_sem_stage2_7)
print(stage_duration_specific_api_syn_sem_stage2_7)
print(sd_specific_stage_duration_api_syn_sem_stage2_7)

# Plot
ggplot(title_durations, aes(x = MonthsSinceStart, y = reorder(Title, -Duration))) +
  geom_boxplot(outlier.shape = 8, outlier.size = 2.5, fill = "white") +
  geom_point(aes(color = Stage), size = 1) +
  labs(title = "Stage 2.7 Specific API Sem Syn Changes",
       x = "Date",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()

#Create bar plot for changes duration
data <- data.frame(
  name=c("API", "Syn", "Sem", "API and Sem", "API and Syn", "Sem and Syn", "API, Sem and Syn") ,  
  value=as.numeric(c(average_duration_specific_api_stage2_7, average_duration_specific_syn_stage2_7, average_duration_specific_sem_stage2_7, average_duration_specific_api_sem_stage2_7, average_duration_specific_api_syn_stage2_7, average_duration_specific_syn_sem_stage2_7, average_duration_specific_api_syn_sem_stage2_7)),
  sd=as.numeric(c(sd_specific_api_stage2_7, sd_specific_syn_stage2_7, sd_specific_sem_stage2_7, sd_specific_api_sem_stage2_7, sd_specific_api_syn_stage2_7, sd_specific_syn_sem_stage2_7, sd_specific_api_syn_sem_stage2_7)
  ))

# Barplot
ggplot(data, aes(x=name, y=value, fill = name)) + 
  geom_bar(stat = "identity", width=0.2) + 
  geom_errorbar(aes(x=name, ymin=value-sd, ymax= value+sd), width=0.4, colour="orange", alpha=0.9) +
  geom_text(aes(label = round(value, 1)), vjust = -0.5, size = 3.5) +
  scale_fill_brewer(palette = "Set1") + 
  labs(x = "Change Type", y = "Time in Months", title = "Stage 2.7: Time from Stage 1 to Stage 2.7") +
  theme(legend.position="none")























# specific changes api stage 2

#Look at single stage
data <- read.csv("CSVFiles/SpecificChanges/Stage 2/api Specific Stage 2.csv")

#setwd in CSVFiles
#file_list <- list.files()
#load_files <- lapply(file_list, read.csv)
#data <- do.call("rbind", load_files)

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
  labs(title = "Proposal Stage 2 Timeline by Title for API Specific Changes",
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
    StageDuration = interval(Date, lead(Date)) %/% months(1),
    MonthsSinceStart = interval(min(Date), Date) %/% months(1),
    Duration = interval(min(Date), max(Date))%/% months(1)) 

average_duration_specific_api_stage2 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(AverageDuration = mean(Duration, na.rm=TRUE))

sd_specific_api_stage2 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(SD_api = sd(Duration, na.rm=TRUE))

stage_duration_specific_api_stage2 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(AverageStageDuration = mean(StageDuration, na.rm=TRUE))

sd_specific_stage_duration_api_stage2 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(SD_AverageStageDuration = sd(StageDuration, na.rm=TRUE))

print(average_duration_specific_api_stage2)
print(sd_specific_api_stage2)
print(stage_duration_specific_api_stage2)
print(sd_specific_stage_duration_api_stage2)


# Plot
ggplot(title_durations, aes(x = MonthsSinceStart, y = reorder(Title, -Duration))) +
  geom_boxplot(outlier.shape = 8, outlier.size = 2.5, fill = "white") +
  geom_point(aes(color = Stage), size = 1) +
  labs(title = "Stage 2 Specific API Changes",
       x = "Months",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()

# specific changes api+sem stage 2

#Look at single stage
data <- read.csv("CSVFiles/SpecificChanges/Stage 2/api_sem Specific Stage 2.csv")

#setwd in CSVFiles
#file_list <- list.files()
#load_files <- lapply(file_list, read.csv)
#data <- do.call("rbind", load_files)

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
  labs(title = "Proposal Stage 2 Timeline by Title for API+Sem Changes",
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
    StageDuration = interval(Date, lead(Date)) %/% months(1),
    MonthsSinceStart = interval(min(Date), Date) %/% months(1),
    Duration = interval(min(Date), max(Date))%/% months(1)) 

average_duration_specific_api_sem_stage2 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(AverageDuration = mean(Duration, na.rm=TRUE))

sd_specific_api_sem_stage2 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(SD_api_sem = sd(Duration, na.rm=TRUE))

stage_duration_specific_api_sem_stage2 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(AverageStageDuration = mean(StageDuration, na.rm=TRUE))

sd_specific_stage_duration_api_sem_stage2 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(SD_AverageStageDuration = sd(StageDuration, na.rm=TRUE))

print(average_duration_specific_api_sem_stage2)
print(sd_specific_api_sem_stage2)
print(stage_duration_specific_api_sem_stage2)
print(sd_specific_stage_duration_api_sem_stage2)


# Plot
ggplot(title_durations, aes(x = MonthsSinceStart, y = reorder(Title, -Duration))) +
  geom_boxplot(outlier.shape = 8, outlier.size = 2.5, fill = "white") +
  geom_point(aes(color = Stage), size = 1) +
  labs(title = "Stage 2 Specific API+Sem Changes",
       x = "Months",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()


# specific changes api+syn stage 

#Look at single stage
data <- read.csv("CSVFiles/SpecificChanges/Stage 2/api_syn Specific Stage 2.csv")

#setwd in CSVFiles
#file_list <- list.files()
#load_files <- lapply(file_list, read.csv)
#data <- do.call("rbind", load_files)

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
  labs(title = "Proposal Stage 2 Timeline by Title for API+Syn Changes",
       x = "Months",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()

#Plot4
# ordered boxplots with months in x axis

# Recompute duration in months
title_durations <- data_long %>%
  group_by(Title) %>%
  mutate(
    StageDuration = interval(Date, lead(Date)) %/% months(1),
    MonthsSinceStart = interval(min(Date), Date) %/% months(1),
    Duration = interval(min(Date), max(Date))%/% months(1)) 

average_duration_specific_api_syn_stage2 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(AverageDuration = mean(Duration, na.rm=TRUE))

sd_specific_api_syn_stage2 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(SD_api_syn = sd(Duration, na.rm=TRUE))

stage_duration_specific_api_syn_stage2 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(AverageStageDuration = mean(StageDuration, na.rm=TRUE))

sd_specific_stage_duration_api_syn_stage2 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(SD_AverageStageDuration = sd(StageDuration, na.rm=TRUE))

print(average_duration_specific_api_syn_stage2)
print(sd_specific_api_syn_stage2)
print(stage_duration_specific_api_syn_stage2)
print(sd_specific_stage_duration_api_syn_stage2)


# Plot
ggplot(title_durations, aes(x = MonthsSinceStart, y = reorder(Title, -Duration))) +
  geom_boxplot(outlier.shape = 8, outlier.size = 2.5, fill = "white") +
  geom_point(aes(color = Stage), size = 1) +
  labs(title = "Stage 2 Specific Api+Syn Changes",
       x = "Date",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()


# specific changes api+sem stage 2

#Look at single stage
data <- read.csv("CSVFiles/SpecificChanges/Stage 2/syn_sem Specific Stage 2.csv")

#setwd in CSVFiles
#file_list <- list.files()
#load_files <- lapply(file_list, read.csv)
#data <- do.call("rbind", load_files)

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
  labs(title = "Proposal Stage 2 Timeline by Title for Syn+Sem Changes",
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
    StageDuration = interval(Date, lead(Date)) %/% months(1),
    MonthsSinceStart = interval(min(Date), Date) %/% months(1),
    Duration = interval(min(Date), max(Date))%/% months(1)) 

average_duration_specific_syn_sem_stage2 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(AverageDuration = mean(Duration, na.rm=TRUE))

sd_specific_syn_sem_stage2 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(SD_syn_sem = sd(Duration, na.rm=TRUE))

stage_duration_specific_syn_sem_stage2 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(AverageStageDuration = mean(StageDuration, na.rm=TRUE))

sd_specific_stage_duration_syn_sem_stage2 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(SD_AverageStageDuration = sd(StageDuration, na.rm=TRUE))


print(average_duration_specific_syn_sem_stage2)
print(sd_specific_syn_sem_stage2)
print(stage_duration_specific_syn_sem_stage2)
print(sd_specific_stage_duration_syn_sem_stage2)


# Plot
ggplot(title_durations, aes(x = MonthsSinceStart, y = reorder(Title, -Duration))) +
  geom_boxplot(outlier.shape = 8, outlier.size = 2.5, fill = "white") +
  geom_point(aes(color = Stage), size = 1) +
  labs(title = "Stage 2 Specific Syn+Sem Changes",
       x = "Months",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()



# specific changes semantic stage 2

#Look at single stage
data <- read.csv("CSVFiles/SpecificChanges/Stage 2/sem Specific Stage 2.csv")

#setwd in CSVFiles
#file_list <- list.files()
#load_files <- lapply(file_list, read.csv)
#data <- do.call("rbind", load_files)

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
  labs(title = "Proposal Stage 2 Timeline by Title for Sem Changes",
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
    StageDuration = interval(Date, lead(Date)) %/% months(1),
    MonthsSinceStart = interval(min(Date), Date) %/% months(1),
    Duration = interval(min(Date), max(Date))%/% months(1)) 

average_duration_specific_sem_stage2 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(AverageDuration = mean(Duration, na.rm=TRUE))

sd_specific_sem_stage2 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(SD_sem = sd(Duration, na.rm=TRUE))

stage_duration_specific_sem_stage2 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(AverageStageDuration = mean(StageDuration, na.rm=TRUE))

sd_specific_stage_duration_sem_stage2 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(SD_AverageStageDuration = sd(StageDuration, na.rm=TRUE))

print(average_duration_specific_sem_stage2)
print(sd_specific_sem_stage2)
print(stage_duration_specific_sem_stage2)
print(sd_specific_stage_duration_sem_stage2)


# Plot
ggplot(title_durations, aes(x = MonthsSinceStart, y = reorder(Title, -Duration))) +
  geom_boxplot(outlier.shape = 8, outlier.size = 2.5, fill = "white") +
  geom_point(aes(color = Stage), size = 1) +
  labs(title = "Stage 2 Specific Sem Changes",
       x = "Months",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()


# specific changes Syntactic stage 2

#Look at single stage

data <- read.csv("CSVFiles/SpecificChanges/Stage 2/syn Specific Stage 2.csv")

#setwd in CSVFiles
#file_list <- list.files()
#load_files <- lapply(file_list, read.csv)
#data <- do.call("rbind", load_files)

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
  labs(title = "Proposal Stage 2 Timeline by Title for Syn Changes",
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
    StageDuration = interval(Date, lead(Date)) %/% months(1),
    MonthsSinceStart = interval(min(Date), Date) %/% months(1),
    Duration = interval(min(Date), max(Date))%/% months(1)) 

average_duration_specific_syn_stage2 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(AverageDuration = mean(Duration, na.rm=TRUE))

sd_specific_syn_stage2 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(SD_syn = sd(Duration, na.rm=TRUE))

stage_duration_specific_syn_stage2 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(AverageStageDuration = mean(StageDuration, na.rm=TRUE))

sd_specific_stage_duration_syn_stage2 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(SD_AverageStageDuration = sd(StageDuration, na.rm=TRUE))

print(average_duration_specific_syn_stage2)
print(sd_specific_syn_stage2)
print(stage_duration_specific_syn_stage2)
print(sd_specific_stage_duration_syn_stage2)


# Plot
ggplot(title_durations, aes(x = MonthsSinceStart, y = reorder(Title, -Duration))) +
  geom_boxplot(outlier.shape = 8, outlier.size = 2.5, fill = "white") +
  geom_point(aes(color = Stage), size = 1) +
  labs(title = "Stage 2 Specific Syn Changes",
       x = "Months",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()


# specific changes Syntactic stage 2

#Look at single stage
data <- read.csv("CSVFiles/SpecificChanges/Stage 2/api_syn_sem Specific Stage 2.csv")

#setwd in CSVFiles
#file_list <- list.files()
#load_files <- lapply(file_list, read.csv)
#data <- do.call("rbind", load_files)

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
  labs(title = "Proposal Stage 2 Timeline by Title for API Syn Sem Changes",
       x = "Months",
       y = "Date Title",
       color = "Stage") +
  theme_minimal()

#Plot4
# ordered boxplots with months in x axis

# Recompute duration in months
title_durations <- data_long %>%
  group_by(Title) %>%
  mutate(
    StageDuration = interval(Date, lead(Date)) %/% months(1),
    MonthsSinceStart = interval(min(Date), Date) %/% months(1),
    Duration = interval(min(Date), max(Date))%/% months(1)) 

average_duration_specific_api_syn_sem_stage2 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(AverageDuration = mean(Duration, na.rm=TRUE))

sd_specific_api_syn_sem_stage2 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(SD_api_syn_sem = sd(Duration, na.rm=TRUE))

stage_duration_specific_api_syn_sem_stage2 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(AverageStageDuration = mean(StageDuration, na.rm=TRUE))

sd_specific_stage_duration_api_syn_sem_stage2 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(SD_AverageStageDuration = sd(StageDuration, na.rm=TRUE))

print(average_duration_specific_api_syn_sem_stage2)
print(sd_specific_api_syn_sem_stage2)
print(stage_duration_specific_api_syn_sem_stage2)
print(sd_specific_stage_duration_api_syn_sem_stage2)

# Plot
ggplot(title_durations, aes(x = MonthsSinceStart, y = reorder(Title, -Duration))) +
  geom_boxplot(outlier.shape = 8, outlier.size = 2.5, fill = "white") +
  geom_point(aes(color = Stage), size = 1) +
  labs(title = "Stage 2 Specific API Syn Sem Changes",
       x = "Months",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()

#Create bar plot for changes duration
data <- data.frame(
  name=c("API", "Syn", "Sem", "API and Sem", "API and Syn", "Sem and Syn", "API, Sem and Syn") ,  
  value=as.numeric(c(average_duration_specific_api_stage2, average_duration_specific_syn_stage2, average_duration_specific_sem_stage2, average_duration_specific_api_sem_stage2, average_duration_specific_api_syn_stage2, average_duration_specific_syn_sem_stage2, average_duration_specific_api_syn_sem_stage2)),
  sd=as.numeric(c(sd_specific_api_stage2, sd_specific_syn_stage2, sd_specific_sem_stage2, sd_specific_api_sem_stage2, sd_specific_api_syn_stage2, sd_specific_syn_sem_stage2, sd_specific_api_syn_sem_stage2)
  ))

# Barplot
ggplot(data, aes(x=name, y=value, fill = name)) + 
  geom_bar(stat = "identity", width=0.2) + 
  geom_errorbar(aes(x=name, ymin=value-sd, ymax= value+sd), width=0.4, colour="orange", alpha=0.9) +
  geom_text(aes(label = round(value, 1)), vjust = -0.5, size = 3.5) +
  scale_fill_brewer(palette = "Set1") + 
  labs(x = "Change Type", y = "Time in Months", title = "Stage 2: Time from Stage 1 to Stage 2") +
  theme(legend.position="none")
























# specific changes api stage 1

#Look at single stage
data <- read.csv("CSVFiles/SpecificChanges/Stage 1/api Specific Stage 1.csv")

#setwd in CSVFiles
#file_list <- list.files()
#load_files <- lapply(file_list, read.csv)
#data <- do.call("rbind", load_files)

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
  labs(title = "Proposal Stage 1 Timeline by Title for API Specific Changes",
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
    StageDuration = interval(Date, lead(Date)) %/% months(1),
    MonthsSinceStart = interval(min(Date), Date) %/% months(1),
    Duration = interval(min(Date), max(Date))%/% months(1)) 

average_duration_specific_api_stage1 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(AverageDuration = mean(Duration, na.rm=TRUE))

sd_specific_api_stage1 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(SD_api = sd(Duration, na.rm=TRUE))

stage_duration_specific_api_stage1 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(AverageStageDuration = mean(StageDuration, na.rm=TRUE))

sd_specific_stage_duration_api_stage1 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(SD_AverageStageDuration = sd(StageDuration, na.rm=TRUE))

print(average_duration_specific_api_stage1)
print(sd_specific_api_stage1)
print(stage_duration_specific_api_stage1)
print(sd_specific_stage_duration_api_stage1)


# Plot
ggplot(title_durations, aes(x = MonthsSinceStart, y = reorder(Title, -Duration))) +
  geom_boxplot(outlier.shape = 8, outlier.size = 2.5, fill = "white") +
  geom_point(aes(color = Stage), size = 1) +
  labs(title = "Stage 1 Specific API Changes",
       x = "Months",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()

# specific changes api+sem stage 2

#Look at single stage
data <- read.csv("CSVFiles/SpecificChanges/Stage 1/api_sem Specific Stage 1.csv")

#setwd in CSVFiles
#file_list <- list.files()
#load_files <- lapply(file_list, read.csv)
#data <- do.call("rbind", load_files)

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
  labs(title = "Proposal Stage 1 Timeline by Title for API+Sem Changes",
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
    StageDuration = interval(Date, lead(Date)) %/% months(1),
    MonthsSinceStart = interval(min(Date), Date) %/% months(1),
    Duration = interval(min(Date), max(Date))%/% months(1)) 

average_duration_specific_api_sem_stage1 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(AverageDuration = mean(Duration, na.rm=TRUE))

sd_specific_api_sem_stage1 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(SD_api_sem = sd(Duration, na.rm=TRUE))

stage_duration_specific_api_sem_stage1 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(AverageStageDuration = mean(StageDuration, na.rm=TRUE))

sd_specific_stage_duration_api_sem_stage1 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(SD_AverageStageDuration = sd(StageDuration, na.rm=TRUE))


print(average_duration_specific_api_sem_stage1)
print(sd_specific_api_sem_stage1)
print(stage_duration_specific_api_sem_stage1)
print(sd_specific_stage_duration_api_sem_stage1)


# Plot
ggplot(title_durations, aes(x = MonthsSinceStart, y = reorder(Title, -Duration))) +
  geom_boxplot(outlier.shape = 8, outlier.size = 2.5, fill = "white") +
  geom_point(aes(color = Stage), size = 1) +
  labs(title = "Stage 1 Specific API+Sem Changes",
       x = "Date",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()


# specific changes api+syn stage 

#Look at single stage
data <- read.csv("CSVFiles/SpecificChanges/Stage 1/api_syn Specific Stage 1.csv")

#setwd in CSVFiles
#file_list <- list.files()
#load_files <- lapply(file_list, read.csv)
#data <- do.call("rbind", load_files)

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
  labs(title = "Proposal Stage 1 Timeline by Title for API+Syn Changes",
       x = "Months",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()

#Plot4
# ordered boxplots with months in x axis

# Recompute duration in months
title_durations <- data_long %>%
  group_by(Title) %>%
  mutate(
    StageDuration = interval(Date, lead(Date)) %/% months(1),
    MonthsSinceStart = interval(min(Date), Date) %/% months(1),
    Duration = interval(min(Date), max(Date))%/% months(1)) 

average_duration_specific_api_syn_stage1 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(AverageDuration = mean(Duration, na.rm=TRUE))

sd_specific_api_syn_stage1 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(SD_api_syn = sd(Duration, na.rm=TRUE))

stage_duration_specific_api_syn_stage1 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(AverageStageDuration = mean(StageDuration, na.rm=TRUE))

sd_specific_stage_duration_api_syn_stage1 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(SD_AverageStageDuration = sd(StageDuration, na.rm=TRUE))

print(average_duration_specific_api_syn_stage1)
print(sd_specific_api_syn_stage1)
print(stage_duration_specific_api_syn_stage1)
print(sd_specific_stage_duration_api_syn_stage1)


# Plot
ggplot(title_durations, aes(x = MonthsSinceStart, y = reorder(Title, -Duration))) +
  geom_boxplot(outlier.shape = 8, outlier.size = 2.5, fill = "white") +
  geom_point(aes(color = Stage), size = 1) +
  labs(title = "Stage 1 Specific Api+Syn Changes",
       x = "Date",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()


# specific changes api+sem stage 2.7

#Look at single stage
data <- read.csv("CSVFiles/SpecificChanges/Stage 1/syn_sem Specific Stage 1.csv")

#setwd in CSVFiles
#file_list <- list.files()
#load_files <- lapply(file_list, read.csv)
#data <- do.call("rbind", load_files)

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
  labs(title = "Proposal Stage 1 Timeline by Title for Syn+Sem Changes",
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
    StageDuration = interval(Date, lead(Date)) %/% months(1),
    MonthsSinceStart = interval(min(Date), Date) %/% months(1),
    Duration = interval(min(Date), max(Date))%/% months(1)) 

average_duration_specific_syn_sem_stage1 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(AverageDuration = mean(Duration, na.rm=TRUE))

sd_specific_syn_sem_stage1 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(SD_syn_sem = sd(Duration, na.rm=TRUE))

stage_duration_specific_syn_sem_stage1 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(AverageStageDuration = mean(StageDuration, na.rm=TRUE))

sd_specific_stage_duration_syn_sem_stage1 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(SD_AverageStageDuration = sd(StageDuration, na.rm=TRUE))

print(average_duration_specific_syn_sem_stage1)
print(sd_specific_syn_sem_stage1)
print(stage_duration_specific_syn_sem_stage1)
print(sd_specific_stage_duration_syn_sem_stage1)


# Plot
ggplot(title_durations, aes(x = MonthsSinceStart, y = reorder(Title, -Duration))) +
  geom_boxplot(outlier.shape = 8, outlier.size = 2.5, fill = "white") +
  geom_point(aes(color = Stage), size = 1) +
  labs(title = "Stage 1 Specific Syn+Sem Changes",
       x = "Date",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()



# specific changes semantic stage 2.7

#Look at single stage
data <- read.csv("CSVFiles/SpecificChanges/Stage 1/sem Specific Stage 1.csv")

#setwd in CSVFiles
#file_list <- list.files()
#load_files <- lapply(file_list, read.csv)
#data <- do.call("rbind", load_files)

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
  labs(title = "Proposal Stage 1 Timeline by Title for Sem Changes",
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
    StageDuration = interval(Date, lead(Date)) %/% months(1),
    MonthsSinceStart = interval(min(Date), Date) %/% months(1),
    Duration = interval(min(Date), max(Date))%/% months(1)) 

average_duration_specific_sem_stage1 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(AverageDuration = mean(Duration, na.rm=TRUE))

sd_specific_sem_stage1 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(SD_sem = sd(Duration, na.rm=TRUE))

stage_duration_specific_sem_stage1 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(AverageStageDuration = mean(StageDuration, na.rm=TRUE))

sd_specific_stage_duration_sem_stage1 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(SD_AverageStageDuration = sd(StageDuration, na.rm=TRUE))

print(average_duration_specific_sem_stage1)
print(sd_specific_sem_stage1)
print(stage_duration_specific_sem_stage1)
print(sd_specific_stage_duration_sem_stage1)


# Plot
ggplot(title_durations, aes(x = MonthsSinceStart, y = reorder(Title, -Duration))) +
  geom_boxplot(outlier.shape = 8, outlier.size = 2.5, fill = "white") +
  geom_point(aes(color = Stage), size = 1) +
  labs(title = "Stage 1 Specific Sem Changes",
       x = "Month",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()


# specific changes Syntactic stage 1

#Look at single stage

data <- read.csv("CSVFiles/SpecificChanges/Stage 1/syn Specific Stage 1.csv")

#setwd in CSVFiles
#file_list <- list.files()
#load_files <- lapply(file_list, read.csv)
#data <- do.call("rbind", load_files)

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
  labs(title = "Proposal Stage 1 Timeline by Title for Syn Changes",
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
    StageDuration = interval(Date, lead(Date)) %/% months(1),
    MonthsSinceStart = interval(min(Date), Date) %/% months(1),
    Duration = interval(min(Date), max(Date))%/% months(1)) 

average_duration_specific_syn_stage1 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(AverageDuration = mean(Duration, na.rm=TRUE))

sd_specific_syn_stage1 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(SD_syn = sd(Duration, na.rm=TRUE))

stage_duration_specific_syn_stage1 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(AverageStageDuration = mean(StageDuration, na.rm=TRUE))

sd_specific_stage_duration_syn_stage1 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(SD_AverageStageDuration = sd(StageDuration, na.rm=TRUE))

print(average_duration_specific_syn_stage1)
print(sd_specific_syn_stage1)
print(stage_duration_specific_syn_stage1)
print(sd_specific_stage_duration_syn_stage1)

# Plot
ggplot(title_durations, aes(x = MonthsSinceStart, y = reorder(Title, -Duration))) +
  geom_boxplot(outlier.shape = 8, outlier.size = 2.5, fill = "white") +
  geom_point(aes(color = Stage), size = 1) +
  labs(title = "Stage 1 Specific Syn Changes",
       x = "Months",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()


# specific changes Syntactic stage 1

#Look at single stage
data <- read.csv("CSVFiles/SpecificChanges/Stage 1/api_syn_sem Specific Stage 1.csv")

#setwd in CSVFiles
#file_list <- list.files()
#load_files <- lapply(file_list, read.csv)
#data <- do.call("rbind", load_files)

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
  labs(title = "Proposal Stage 1 Timeline by Title for API Syn Sem Changes",
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
    StageDuration = interval(Date, lead(Date)) %/% months(1),
    MonthsSinceStart = interval(min(Date), Date) %/% months(1),
    Duration = interval(min(Date), max(Date))%/% months(1)) 

average_duration_specific_api_syn_sem_stage1 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(AverageDuration = mean(Duration, na.rm=TRUE))

sd_specific_api_syn_sem_stage1 <- data_long %>%
  group_by(Title) %>%
  summarize(Duration = interval(min(Date), max(Date))%/% months(1)) %>%
  summarize(SD_api_syn_sem = sd(Duration, na.rm=TRUE))

stage_duration_specific_api_syn_sem_stage1 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(AverageStageDuration = mean(StageDuration, na.rm=TRUE))

sd_specific_stage_duration_api_syn_sem_stage1 <- title_durations %>%
  group_by(Stage) %>%
  summarize(StageDuration) %>%
  summarize(SD_AverageStageDuration = sd(StageDuration, na.rm=TRUE))

print(average_duration_specific_api_syn_sem_stage1)
print(sd_specific_api_syn_sem_stage1)
print(stage_duration_specific_api_syn_sem_stage1)
print(sd_specific_stage_duration_api_syn_sem_stage1)

# Plot
ggplot(title_durations, aes(x = MonthsSinceStart, y = reorder(Title, -Duration))) +
  geom_boxplot(outlier.shape = 8, outlier.size = 2.5, fill = "white") +
  geom_point(aes(color = Stage), size = 1) +
  labs(title = "Stage 1 Specific API, Syn, Sem Changes",
       x = "Months",
       y = "Proposal Title",
       color = "Stage") +
  theme_minimal()

#Create bar plot for changes duration
data <- data.frame(
  name=c("API", "Syn", "Sem", "API and Sem", "API and Syn", "Sem and Syn", "API, Sem and Syn") ,  
  value=as.numeric(c(average_duration_specific_api_stage1, average_duration_specific_syn_stage1, average_duration_specific_sem_stage1, average_duration_specific_api_sem_stage1, average_duration_specific_api_syn_stage1, average_duration_specific_syn_sem_stage1, average_duration_specific_api_syn_sem_stage1)),
  sd=as.numeric(c(sd_specific_api_stage1, sd_specific_syn_stage1, sd_specific_sem_stage1, sd_specific_api_sem_stage1, sd_specific_api_syn_stage1, sd_specific_syn_sem_stage1, sd_specific_api_syn_sem_stage1)
  ))

# Barplot
ggplot(data, aes(x=name, y=value, fill = name)) + 
  geom_bar(stat = "identity", width=0.2) + 
  geom_errorbar(aes(x=name, ymin=value-sd, ymax= value+sd), width=0.4, colour="orange", alpha=0.9) +
  geom_text(aes(label = round(value, 1)), vjust = -0.5, size = 3.5) +
  scale_fill_brewer(palette = "Set1") + 
  labs(x = "Change Type", y = "Time in Months", title = "Stage 1 duration with SD") +
  theme(legend.position="none")

#Create bar plot for from data from spreadsheet
data <- data.frame(
  name=c("Stage 1", "Stage 2", "Stage 3") ,  
  value=as.numeric(c(10.0740740740741, 7.86075949367089, 15.031746031746)),
  sd=as.numeric(c(14.1684312626502, 11.9322168692902, 14.2850793509694)
  ))

# Barplot
ggplot(data, aes(x=name, y=value, fill = name)) + 
  geom_bar(stat = "identity", width=0.2) + 
  geom_errorbar(aes(x=name, ymin=value-sd, ymax= value+sd), width=0.4, colour="orange", alpha=0.9) +
  geom_text(aes(label = round(value, 1)), vjust = -0.5, size = 3.5) +
  scale_fill_brewer(palette = "Set1") + 
  labs(x = "Stage", y = "Time in Months", title = "Duration per stage for all active Proposals") +
  theme(legend.position="none")

#Create CSV files of specific stage for speadsheet analysis

data <- read.csv("CSVFiles/SpecificChanges/Stage 2/sem Specific Stage 2.csv")

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

# Recompute duration in months
title_durations <- data_long %>%
  group_by(Title) %>%
  mutate(
    Classification = "Sem",
    StageDuration = interval(Date, lead(Date)) %/% months(1),
    MonthsSinceStart = interval(min(Date), Date) %/% months(1),
    Duration = interval(min(Date), max(Date))%/% months(1)) 

write.csv(title_durations, file = "CSVFiles/SpecificChanges/All Data/sem stage 2 duration.csv", append=TRUE)















#plots for stage specific stage 4 bumps with classifications on vertical axis
#Look at single stage
#setwd in Data Analysis
data <- read.csv("CSVFiles/SpecificChanges/Stage4SpecificDates&SinceStart.csv")

#setwd in CSVFiles/CSVChanges
#file_list <- list.files()
#load_files <- lapply(file_list, read.csv)
#data <- do.call("rbind", load_files)

data_long <- data %>%
  
  # Mutates the date into ymd format for R to understand and process
  mutate(Date = ymd(Date))

# Create the grouped scatter plot
ggplot(data_long, aes(x = Date, y = Classification)) +
  geom_point(size = 1) +
  labs(title = "Stage 4 Bump Timeline Per Classification",
       x = "Date",
       y = "Classification",
       color = "Stage") +
  theme_minimal() 

# Create the grouped scatter plot
ggplot(data_long, aes(x = MonthsSinceStart, y = Classification)) +
  geom_point(size = 1) +
  labs(title = "Stage 4 Proposals Months Since Start Per Classification",
       x = "Date",
       y = "Classification",
       color = "Stage") +
  theme_minimal() 





















#tag plots
#Look at single stage
#setwd in Data Analysis
data <- read.csv("Tags/TagsStage1Stage4.csv")

#setwd in CSVFiles/CSVChanges
#file_list <- list.files()
#load_files <- lapply(file_list, read.csv)
#data <- do.call("rbind", load_files)

data_long <- data %>%
  # Mutates the date into ymd format for R to understand and process
  mutate(
    Stage.1 = ymd(Stage.1),
    Stage.4 = ymd(Stage.4),
    MonthsSinceStart = interval(Stage.1, Stage.4) %/% months(1))


# Create the grouped scatter plot
ggplot(data_long, aes(x = MonthsSinceStart, y = Tag)) +
  geom_point(size = 1) +
  labs(title = "Stage 4: Tags vs Months Since Stage 1",
       x = "Date",
       y = "Classification",
       color = "Stage") +
  theme_minimal() 


#tag plots
#Look at single stage
#setwd in Data Analysis
data <- read.csv("Tags/TagsStage4.csv")

#setwd in CSVFiles/CSVChanges
#file_list <- list.files()
#load_files <- lapply(file_list, read.csv)
#data <- do.call("rbind", load_files)

data_long <- data %>%
  # Mutates the date into ymd format for R to understand and process
  mutate(
    Stage.4 = ymd(Stage.4))


# Create the grouped scatter plot
ggplot(data_long, aes(x = Stage.4, y = Tag)) +
  geom_point(size = 1) +
  labs(title = "Stage 4: Tags vs Adoption Date",
       x = "Date",
       y = "Classification",
       color = "Stage") +
  theme_minimal() 

data <- read.csv("Tags/TagDates.csv")

#tagCount <- data %>% count(Tag, sort=TRUE)
#write.csv(tagCount, file = "Tags/TagCount.csv")

# make a sum of all topics
topicCount <- read.csv("Tags/TagCount.csv", header = FALSE)
count <- aggregate(V2 ~ V3, data = topicCount, sum)
write.csv(count, file = "Tags/TopicCount.csv")
