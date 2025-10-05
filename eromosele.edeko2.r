library(readr) 
library(dplyr) 
library(haven) 
lapland <- read_csv("new_lapland.csv") 

#1. One researcher is interested in comparing BMI between individuals with COPD and healthy #individuals. She claims that the BMI differs between these two groups.
# --- Step 1: Define hypotheses ---
# H0: There is no difference in BMI between individuals with COPD and healthy individuals.
# H1: There is a difference in BMI between individuals with COPD and healthy individuals.


#BMI is not directly in the dataset, so I need to calculate it first.
#I recall that BMI = weight (kg) / (height (m))^2
# --- Step 2: Calculate BMI ---
lapland$BMI <- lapland$Weight / (lapland$Height/100)^2
lapland$BMI

# --- Step 3: Check assumptions ---
# I view my data to see if there are any obvious outliers or issues
summary(lapland$BMI)
#Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
#17.63   20.41   21.26   22.62   22.45   38.43
#From the summary, there are some obvious outliers.

# Graphically
library(ggplot2) 
ggplot(lapland, aes(x = BMI, fill = as.factor(COPD))) + 
  geom_histogram(position = "dodge", bins = 30) + 
  labs(title = "Histogram of BMI by COPD Status", x = "BMI", fill = "COPD Status") + 
  theme_minimal()

#The histogram shows that the BMI distribution is not perfectly bell-shaped, supporting the need for the Shapiro-Wilk test.

# (a) Normality (Shapiro-Wilk test)
shapiro.test(lapland$BMI[lapland$COPD == 1])  # COPD group
shapiro.test(lapland$BMI[lapland$COPD == 0])  # Healthy group

#data:  lapland$BMI[lapland$COPD == 1]
#W = 0.64034, p-value = 2.629e-05



#data:  lapland$BMI[lapland$COPD == 0]
#W = 0.60082, p-value = 9.226e-11

# => Both groups are NOT normally distributed. Assumption of t-test is violated.

#Optionally, I can also check normality with QQ plots
ggplot(lapland, aes(sample = BMI, color = as.factor(COPD))) + 
  stat_qq() + 
  stat_qq_line() + 
  facet_wrap(~ COPD) + 
  labs(title = "QQ Plots of BMI by COPD Status", x = "Theoretical Quantiles", y = "Sample Quantiles") + 
  theme_minimal()
#The QQ plots show deviations from the diagonal line, especially in the tails, indicating non-normality.

# I could confirm non-normality with the leveneTest from the car package

# (b) Equality of variances (Levene’s test – more robust than var.test)
car::leveneTest(BMI ~ as.factor(COPD), data = lapland)

# Test did not run at first, so I must install.packages("car") and then library(car)
# I had to convert COPD to a factor for the test to run properly.

#Results
#Levene's Test for Homogeneity of Variance (center = median)
      #Df F value  Pr(>F)  
#group  1  4.0335 0.04858 *
      #68                  
---
#Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1  

# I find it very annoying that R does not have a multiline comment function like Python.
# So I use # for each line.


# Result:
# p ≈ 0.049 < 0.05 → variances differ slightly between groups.
# => Another violation of t-test assumptions.


# Now I have established that both normality and equal variance assumptions are violated.
# Therefore, I cannot trust the results of a two-sample t-test.
# However, I will run the t.test anyway to show how misleading it can be.

# --- Step 4: Run the WRONG test (two-sample t-test) ---
t.test(BMI ~ COPD, data = lapland, var.equal = TRUE)

# Result:
# t = 2.68, p = 0.009265
# If we trusted this, we would conclude BMI differs significantly.
# BUT since normality + variance assumptions fail, this is unreliable.

# --- Step 5: Run the CORRECT test (wilcox.test) ---
wilcox.test(BMI ~ COPD, data = lapland, exact = FALSE)

# Result:
# W = 280, p = 0.01989
# Interpretation: There is a significant difference in BMI distributions
# between COPD and healthy individuals.
# This test is valid because it does not assume normality.

# --- Step 6: Interpretation ---
# The t-test suggested significance (p = 0.009265), but its assumptions were violated.
# The Wilcox test, which is robust to non-normal data,
# also shows significance (p = 0.01989), confirming that BMI differs
# between COPD and healthy groups. This is the test we should report.



#2. A survey was conducted of 175 young adults, classifying their highest level of schooling as 
#graduated from university, graduated from high school, or neither, and classifying their parents as 
#wealthy, middle class, or poor. The results of the survey are summarized in table 1 (Observed 
#Values). Based on the data collected can we conclude that a person’s level of schooling is 
#independent of their parents’ wealth? 
#a) Perform a Chi-Square Test manually. 
#b) Check the result of (a) with the result of chisq.test() function.

#Step 0 > Define hypotheses
#H0: A person’s level of schooling is independent of their parents’ wealth.
#H1: A person’s level of schooling is not independent of their parents’ wealth.

#Step 1 > Create a  matrix of observed values
observed <- matrix(c(20, 15, 10, 40, 25, 20, 8, 14, 23), nrow = 3, byrow = TRUE)
observed

# Here I add row and column names for clarity
colnames(observed) <- c("Wealthy", "Middle class", "Poor")
rownames(observed) <- c("Graduated from university", "Graduated from high school", "Neither")

observed

#Step 2 > Calculate the row totals, column totals, and grand total
row_totals <- rowSums(observed)
col_totals <- colSums(observed)
grand_total <- sum(observed)

print(observed, row_totals, col_totals, grand_total)


#Step 3 > Calculate the expected values
#Here I use a double for loop to calculate the expected values
# I loop over each cell in the observed matrix and apply the formula
# To loop over each cell the i index goes from 1 to number of rows
# and the j index goes from 1 to number of columns
# Expected value = (row total * column total) / grand total
expected <- matrix(0, nrow = nrow(observed), ncol = ncol(observed))
for (i in 1:nrow(observed)) {
  for (j in 1:ncol(observed)) {
    expected[i, j] <- row_totals[i] * col_totals[j] / grand_total
  }
}

print(expected)

#Step 4 > Calculate the degree of freedom
df <- (nrow(observed) - 1) * (ncol(observed) - 1)
print(df)

#Step 5 > Calculate the Chi-Square statistic
chi_square_statistic <- sum(((observed - expected)^2 / expected), na.rm = TRUE)
print(chi_square_statistic)

#Step 6 > Determine the p-value
# p-value manually
p_val_manual <- 1 - pchisq(chi_square_statistic, df)
p_val_manual

# p-value using chisq.test() function
chisq_test_result <- chisq.test(observed)
chisq_test_result$p.value

chisq_test_result
#Conclusion
#Since the p-value (0.0036) is less than the significance level (0.05), we reject the null hypothesis.
#There is enough evidence to suggest that a person's level of schooling is not independent of their parents' wealth.
#There is an association between a person's level of schooling and their parents' wealth.


# Check the working directory, to determine where my files saved to so I can easily find them and submit
getwd()