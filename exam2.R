getwd()
library("haven")
library("readr")


skin_healing <- read_csv("skin_healing.csv")
skin_healing

#Question 1: 
#For each variable in the dataset, determine the measurements [Binary, Categorical (Ordinal, 
#Nominal), Continuous], number of outliers and missing values

colnames(skin_healing)

#"patient_id"  == nominal
#"treatment"  == categorical
#"age"        == continuous
#"biopsyScore"  == continuous

cat("Missing Values:\n")
print(colSums(is.na(skin_healing)))

# patient_id   treatment         age biopsyScore 
#0           0           0          13 
 
#What is the average and standard deviationof  healing outcome (histological score) for each 
#treatment group after 14 days?
library(dplyr)
skin_healing_grouped <- group_by(skin_healing, treatment)
statistics <- summarise(skin_healing_grouped,
                        mean = mean(biopsyScore, na.rm = TRUE),
                        sd = sd(biopsyScore, na.rm = TRUE))

statistics

#  treatment  mean    sd
#<chr>     <dbl> <dbl>
 # 1 Control    55.9  2.93
#2 DeviceC    43.7  3.16
#3 DrugA      47.6  3.80
#4 DrugB      45.6  3.54



#Question 3: 
 # Which treatment shows the best improvement in skin healing compared to the control condition? 
#The question says that "Lower biopsy scores indicate better healing and less inflammation."
#So the treatment with the lowest average biopsy score performs best.


#Is there a statistically significant difference in the healing outcome between the three new 
#treatment conditions (DrugA, DrugB, DeviceC)? Which treatment shows the best healing 
#performance?

#Check normality of each group
# For each treatment separately
shapiro.test(skin_healing$biopsyScore[skin_healing$treatment == "Control"])
#Shapiro-Wilk normality test

#data:  skin_healing$biopsyScore[skin_healing$treatment == "Control"]
#W = 0.98749, p-value = 0.740

shapiro.test(skin_healing$biopsyScore[skin_healing$treatment == "DrugA"])
#Shapiro-Wilk normality test

#data:  skin_healing$biopsyScore[skin_healing$treatment == "DrugA"]
#W = 0.9765, p-value = 0.2431


shapiro.test(skin_healing$biopsyScore[skin_healing$treatment == "DrugB"])

#	Shapiro-Wilk normality test

#data:  skin_healing$biopsyScore[skin_healing$treatment == "DrugB"]
#W = 0.98337, p-value = 0.4896

shapiro.test(skin_healing$biopsyScore[skin_healing$treatment == "DeviceC"])
#
#Shapiro-Wilk normality test

#data:  skin_healing$biopsyScore[skin_healing$treatment == "DeviceC"]
#W = 0.97467, p-value = 0.173

#Since  p > 0.05, the data is not normally distributed i choose kruskak-wallis test
# Run the Kruskal-Wallis test
kruskal.test(biopsyScore ~ treatment, data = skin_healing)

#	Kruskal-Wallis rank sum test

#data:  biopsyScore by treatment
#Kruskal-Wallis chi-squared = 161.93, df = 3, p-value < 2.2e-16

#Kruskal-Wallis rank sum test

#data:  biopsyScore by treatment
#Kruskal-Wallis chi-squared = 161.93, df = 3, p-value < 2.2e-16

#H₀ (null hypothesis): The median healing scores are the same across all treatment groups.

#H₁ (alternative hypothesis): At least one treatment group differs significantly.

#Since p < 0.05, I reject the null hypothesis → there’s a significant difference in healing outcomes between the treatments.

#or fail to reject the alternate hypothesis

#lets do a post-hoc and find which is different

install.packages("FSA")
library(FSA)

# Dunn's post-hoc test with Bonferroni correction
dunnTest(biopsyScore ~ treatment, data = skin_healing, method = "bonferroni")


#Comparison         Z      P.unadj        P.adj
#1 Control - DeviceC 11.950390 6.462119e-33 3.877271e-32
#2   Control - DrugA  7.388860 1.480928e-13 8.885570e-13
#3   DeviceC - DrugA -4.462141 8.114493e-06 4.868696e-05
#4   Control - DrugB  9.828116 8.519732e-23 5.111839e-22
#5   DeviceC - DrugB -2.138053 3.251245e-02 1.950747e-01
#6     DrugA - DrugB  2.347977 1.887567e-02 1.132540e-01

#All three new treatments (DrugA, DrugB, DeviceC) are significantly different from the Control, meaning they all improved healing compared with usual care.

#Among the new treatments: DeviceC vs DrugA also differs significantly (DeviceC likely healed better).

#DrugB vs DeviceC and DrugB vs DrugA are not significantly different, so DrugB performs somewhat in between.



#Question 5: 
#Among patients older than 45 years, is there a statistically significant difference in healing 
#outcomes between the three treatment conditions (DrugA, DrugB, and DeviceC)? Which 
#treatment shows the best healing performance in this age group? 


#first i create a new subset 
older_patients <- subset(skin_healing, age > 45 & treatment %in% c("DrugA", "DrugB", "DeviceC"))
older_patients


#next i check for normality

by(older_patients$biopsyScore, older_patients$treatment, shapiro.test)


#older_patients$treatment: DeviceC

#Shapiro-Wilk normality test

#data:  dd[x, ]
#W = 0.95207, p-value = 0.07098

#--------------------------------------------------------------------------------------------------------- 
 # older_patients$treatment: DrugA

#Shapiro-Wilk normality test

#data:  dd[x, ]
#W = 0.97622, p-value = 0.5517

#--------------------------------------------------------------------------------------------------------- 
 # older_patients$treatment: DrugB

#Shapiro-Wilk normality test

#data:  dd[x, ]
#W = 0.96431, p-value = 0.199


#again i have 3 groups that are not normally distributed i am sticking with kruskal-wallis
kruskal.test(biopsyScore ~ treatment, data = older_patients)

#	Kruskal-Wallis rank sum test

#data:  biopsyScore by treatment
#Kruskal-Wallis chi-squared = 36.649, df = 2, p-value = 1.101e-08

#there’s a significant difference between at least one pair of treatments.


#i will run another post-hoc

library(FSA)
dunnTest(biopsyScore ~ treatment, data = older_patients, method = "bonferroni")

#Comparison         Z      P.unadj        P.adj
#1 DeviceC - DrugA -5.461727 4.715258e-08 1.414577e-07
#2 DeviceC - DrugB -0.406032 6.847191e-01 1.000000e+00
#3   DrugA - DrugB  5.063100 4.124931e-07 1.237479e-06

#Interpretation (in plain words)

#DeviceC vs DrugA:
 # DeviceC shows significantly better healing (lower biopsy scores) than DrugA.

#DeviceC vs DrugB:
  #No statistically significant difference — both performed similarly.

#DrugA vs DrugB:
  #DrugA has significantly worse healing (higher biopsy scores) than DrugB.

#DeviceC is the best


#Question 6: 
#Is there a correlation between patient age and the histological healing score in the DrugB 
#treatment condition?

#Again i will subset my dat
my_drugB_data <- subset(skin_healing, treatment == "DrugB")
my_drugB_data

#next ill peform shappiro again to determine wether to use pearsson or spearman correlation

#𝐻_0  : There is no linear correlation between x and y  (𝜌= 0)
#𝐻_𝑎: There is a linear correlation between x and y (𝜌 ≠ 0)
shapiro.test(my_drugB_data$age)

#
#Shapiro-Wilk normality test

#data:  my_drugB_data$age
#W = 0.25302, p-value < 2.2e-16

shapiro.test(my_drugB_data$biopsyScore)

#	Shapiro-Wilk normality test

#data:  my_drugB_data$biopsyScore
#W = 0.98337, p-value = 0.4896

#I cannot use pearson as the first is not normally distributed
cor.test(my_drugB_data$age, my_drugB_data$biopsyScore, method = "spearman")


#Spearman's rank correlation rho

#data:  my_drugB_data$age and my_drugB_data$biopsyScore
#S = 79137, p-value = 0.0001241
#alternative hypothesis: true rho is not equal to 0
#sample estimates:
#  rho 
#-0.4456917 

#The Spearman correlation test shows a statistically significant relationship between age and biopsy (healing) score among patients treated 
#This suggests that age significantly affect healing outcomes for patients in the DrugB treatment group.



# Base R scatter plot
plot(
  my_drugB_data$age,
  my_drugB_data$biopsyScore,
  main = "Age vs. Biopsy Score (DrugB Treatment)",
  xlab = "Age",
  ylab = "Biopsy Score",
  pch = 19,
  col = "blue"
)

# Add a linear trend line
abline(lm(biopsyScore ~ age, data = my_drugB_data), col = "red", lty = 2)












