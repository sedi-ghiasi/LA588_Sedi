#Sedi Ghiasi
#Assignment2
#LA 588 spring 2023
# ----Dataset one------------------------------
install.packages("installr")
install.packages("sf")
install.packages("tidyverse")
install.packages("dplyr")
install.packages("readxl")
library(ggplot2)
library(dplyr)
library(sf)
library(readxl)
library(jsonlite)
library(writexl)


#Importing excel file####
datasets <- read.csv("sample.csv")
?count.fields()

                     
#here i am counting the cells has two conditions: greening_category == "cover" & Point_Count==0####

number_of_trees_79 <- datasets%>% 

  count(greening_category == "cover" & Point_Count==0)
print(number_of_trees_79)

number_of_trees_80 <- datasets%>% 
  
  count(greening_category == "no tree" & Point_Count==0)
print(number_of_trees_80)

    
#here i did a filter to separate cell =79####
result_cell79 <- datasets %>%
  filter(greening_category
 == "no tree" & cell == "79")
print(result_cell79)
result_cell80 <- datasets %>%
  filter(greening_category
         == "no tree" & cell == "80")
print(result_cell80)

result_cell81 <- datasets %>%
  filter(greening_category
         == "no tree" & cell == "81")
print(result_cell81)


# Combining the data frames
result_all <- bind_rows(
  result_cell79 %>% mutate(cell = "79"),
  result_cell80 %>% mutate(cell = "80"),
  result_cell81 %>% mutate(cell = "81"))

# counting the number of rows in each data frame
count_cell79 <- nrow(result_cell79)
count_cell80 <- nrow(result_cell80)
count_cell81 <- nrow(result_cell81)

# creating a data frame with the counts
count_data <- data.frame(cell = c("79", "80", "81"), count = c(count_cell79, count_cell80, count_cell81))

# creating a bar chart
ggplot(count_data, aes(x = cell, y = count)) +
  geom_bar(stat = "identity", fill = "blue") +
  labs(x = "Cell", y = "Count", title = "Number of Observations by Cell") +
  theme(plot.title = element_text(hjust = 0.5))

# ----Dataset two------------------------------
#Importing excel file####
dataset2 <- read.csv("tree_2.csv")
# Grouping the data by height and count the number of buildings in each group
data_grouped <- dataset2 %>% group_by(height)%>% summarise(count = n())




# Creating a bar plot with height on x-axis and count on y-axise####
ggplot(data_grouped, aes(x = height, y = count)) +
  geom_bar(stat = "identity") +
  labs(title = "Number of Buildings by Height", x = "Height", y = "Number of Buildings")


# ----Dataset three------------------------------
#After spending some time learning about this package, I was able to apply it to visualize the data for my research project as dataset three ####
library(readr)
json_data <- fromJSON("shoebox-weights_c.json")
json_tibble <- as_tibble(json_data)
json_tibble <- as_tibble(json_data)
write_excel_csv(json_tibble, "output_file.csv")
df <- read.csv("output_file.csv")
df_grouped <- df %>%
  group_by(ParentBuildingId)%>%
  summarize (count = n())
print(df_grouped) 
write_csv(df_grouped, "output3_file.csv")
