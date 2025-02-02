library(readr)
data=read.csv("C:/Users/admin/Desktop/R studio data set/15-4-24 Project/hr_dataset (1).csv")
data

#1.Analyse the data 

head(data)

str(data)

summary(data)

library(ggplot2)

ggplot(data, aes(x = factor(churn), y = average_montly_hours)) +
  geom_boxplot() + 
  labs(title = "Box Plot of Average Monthly Hours by Churn", x = "Churn", y = "Average Monthly Hours")

ggplot(data, aes(x = satisfaction)) + geom_histogram(binwidth = 0.1, fill = "skyblue", color = "black") +
  labs(title = "Histogram of Satisfaction Levels", x = "Satisfaction", y = "Frequency")

library(caTools)

data$department <- as.factor(data$department)
data$salary <- as.factor(data$salary)

set.seed(123) 
split <- sample.split(data$churn, SplitRatio = 0.8)
train_data <- subset(data, split == TRUE)
train_data
test_data <- subset(data, split == FALSE)
test_data

library(glmnet)

model <- glm(churn ~ ., data = train_data, family = "binomial")

predictions <- predict(model, newdata = test_data, type = "response")

binary_predictions <- ifelse(predictions > 0.5, 1, 0)

table(test_data$churn, binary_predictions)

accuracy <- mean(test_data$churn == binary_predictions)
print(paste("Accuracy:", accuracy))


#2.Do exploratory data analysis 

head(data)

str(data)

summary(data)

ggplot(data, aes(x = evaluation, y = satisfaction, color = factor(churn))) +
  geom_point() +
  labs(title = "Evaluation vs. Satisfaction", x = "Evaluation", y = "Satisfaction", color = "Churn")

ggplot(data, aes(x = department, fill = factor(churn))) +
  geom_bar(position = "fill") +
  labs(title = "Churn Rate by Department", x = "Department", y = "Proportion of Employees", fill = "Churn")

ggplot(data, aes(x = salary, fill = factor(churn))) +
  geom_bar(position = "fill") +
  labs(title = "Churn Rate by Salary Category", x = "Salary Category", y = "Proportion of Employees", fill = "Churn")


#3. Do data pre-processing 

missing_values <- colSums(is.na(data))
print(missing_values)

data$average_montly_hours <- as.factor(data$average_montly_hours)

class(data$average_monthly_hours)


data$average_monthly_hours <- as.numeric(data$average_monthly_hours)

data$average_monthly_hours[is.na(data$average_monthly_hours)] <- mean(data$average_monthly_hours, na.rm = TRUE)


num_vars <- c("satisfaction", "evaluation", "average_monthly_hours", "time_spend_company")

data[num_vars] <- scale(data[num_vars])

#4.Build models and evaluate the performance


logistic_model <- glm(churn ~ ., data = train_data, family = "binomial")

logistic_predictions <- predict(logistic_model, newdata = test_data, type = "response")


logistic_binary_predictions <- ifelse(logistic_predictions > 0.5, 1, 0)


logistic_conf_matrix <- table(test_data$churn, logistic_binary_predictions)
print("Confusion Matrix for Logistic Regression:")
print(logistic_conf_matrix)


logistic_accuracy <- mean(test_data$churn == logistic_binary_predictions)
print(paste("Accuracy for Logistic Regression:", logistic_accuracy))




# 5. Identify the accuracy 

library(dplyr)
library(caret)

data <- mutate(data, department = as.factor(department))

train_index <- createDataPartition(data$churn, p = 0.7, list = FALSE)
train_data <- data[train_index, ]
test_data <- data[-train_index, ]

log_model <- glm(churn ~ ., data = train_data, family = "binomial")

predictions <- predict(log_model, newdata = test_data, type = "response")

predicted_classes <- ifelse(predictions > 0.5, 1, 0)

accuracy <- mean(predicted_classes == test_data$churn)
print(paste("Accuracy of logistic regression model:", accuracy))

