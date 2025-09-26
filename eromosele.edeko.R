#In Lapland data, report descriptive statistics of: 
#a) BMI based on sex. 
#b) Diabetes.

#Step 1 (I would import the needed libraries)
library(readr)  #read large files
library(dplyr)  # Data manipulation (grouping, summarising, filtering, joining etc.)
library(haven) # Simply put this library helps views excel or csv files or according to Bing The haven library in R is a part of the tidyverse and is used to import and export data from statistical software like SPSS, Stata, and SAS. It wraps the ReadStat C library to handle these formats efficiently.
library(ggplot2) #Simply put this library plots the graphs or according to  Bing The ggplot function in R is part of the ggplot2 package, which is a powerful and flexible tool for creating data visualizations. The ggplot function initializes a ggplot object and is used to declare the input data frame for a graphic and specify the set of plot aesthetics intended to be common throughout all subsequent layers unless specifically overridden.


#Step 2  (read the csv file I need to work with)

lapland <- read_csv("lapland.csv")
lapland #first 10 rolls displayed successfully 

#Step 3 Find the BMI
#traditional method (basic R)

colnames(lapland)

lapland$BMI <- lapland$Weight / ((lapland$Height/100)^2)
lapland$BMI

BMI <- lapland$BMI
BMI

#Step 4 (optional) Create a Histogram of the BMI variable to visualize it using ggplot

ggplot(lapland, aes(x = lapland$BMI)) +
  geom_histogram(binwith = 2, color = "black", fill = "darkblue", alpha = 1) +
  labs(title ="Histogram of BMI", x = "BMI", y = "Frequency") +
  theme_minimal()

#Step 5 Calculate the average BMI based on sex

#group by function takes 2 arguments (data_frame and group_by type)
#next the Average_BMI variable is assigned to mean of BMI, note mean is a function that also takes two  or more arguments
#finally we wrap these two functions in a summary function and assign it back to our data frame, thus overriding it
#d Calculate the average BMI for each sex

library(dplyr)
Mean_by_sex <- summarise(group_by(lapland, Sex),
                        Average_BMI <- mean(BMI, na.rm=TRUE))

Mean_by_sex

#So I had an issue here, it kept saying could not find the function summaries, the reason was because summaries function is part of the dplyr library
#and even though it has been initialize(d above Rstudio couldn't see it, so I had to re-initialize it.

#We could do something even more cleaver, we could use a pipe operator and achieve all in one code line and other descriptive parameters
lapland %>%
  group_by(Sex) %>%
  summarise(
    mean_BMI = mean(BMI, na.rm = TRUE),
    sd_BMI = sd(BMI, na.rm = TRUE),
    median_BMI = median(BMI, na.rm = TRUE),
    .groups = "drop"
  )


#Question B let us run a descriptive analysis of Diabetes
#In this part i would describe diabetes qualitatively and by graphs

#plot1 diabetes vs sex
#How prevalent is diabetes in the population for females and males

library(ggplot2)
lapland$Sex <- factor(lapland$Sex, labels = c("Male", "Female"))

ggplot(data = lapland, aes(x = Sex, fill = diabetes)) +
  geom_bar(position = "dodge", color = "black") +
  labs(title = "Diabetes Status by Sex",
       x = "Sex",
       y = "Count",
       fill = "Diabetes Status") +
  scale_fill_manual(values = c("healthy" = "#66c2a5", 
                               "Pre_diabetic" = "#fc8d62", 
                               "diabetic" = "#8da0cb")) +
  theme_minimal()


#How prevalent is diabetes in the population for the different age groups
ggplot(lapland, aes(x = diabetes, y = Age, fill = diabetes)) +
  geom_boxplot() +
  labs(title = "Age Distribution by Diabetes Status",
       x = "Diabetes Status", y = "Age") +
  theme_minimal()

#Diabetes Distribution by BMI
ggplot(lapland, aes(x = diabetes, y = BMI, fill = diabetes)) +
  geom_boxplot() +
  labs(title = "BMI Distribution by Diabetes Status",
       x = "Diabetes Status", y = "BMI") +
  theme_minimal()

#More descriptive statistics of Diabetes
Diabetes_stats <- lapland

Diabetes_stats %>%
  group_by(diabetes) %>%
  summarise(
    count = n(),
    Average_BMI = mean(BMI, na.rm = TRUE),
    sd_BMI  = sd(BMI, na.rm = TRUE),
    min_BMI = min(BMI, na.rm = TRUE),
    max_BMI = max(BMI, na.rm = TRUE),
    median_BMI = median(BMI, na.rm = TRUE),
    IQR_BMI = IQR(BMI, na.rm = TRUE)
  )





    


 




