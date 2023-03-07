#Sedi Ghiasi
#Assignment3
#LA588

install.packages("installr")
install.packages("sf")
install.packages("tidyverse")
install.packages("dplyr")
install.packages("readxl")
install.packages("tmap")
library(usmap)
library(tidyverse)
library(usmap)
library(ggplot2)
library(dplyr)
library(tidycensus)
library(tidyverse)
library(sf)
library(readxl)
library(idbr)
library(ggplot2)

#census_api_key("", install = TRUE)



# Loading data from the ACS 2019 5-year estimates
med_income <- get_acs(geography = "state", 
                      variables = "B19013_001", 
                      year = 2019, 
                      survey = "acs5")

# I Converted it to a tibble and calculated median income as a numeric value
med_income_tibble <- as_tibble(med_income) %>%
  mutate(median_income = as.numeric(estimate))
print(med_income)
# Converting it to a data frame, renameing columns
med_income_df <- as.data.frame(med_income_tibble) %>%
  rename(state = NAME) %>%
  mutate(state = as.factor(state))

# Create the plot
ggplot(med_income_df, aes(x = state, fill = median_income)) +
  geom_bar() +
  theme_minimal() +
  labs(title = "Median Income by State", y = "Median Income", x = "State") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, size = 8), 
        axis.text.y = element_text(size = 8),
        plot.title = element_text(size = 20))


##part2 


# Load diamonds data
data("diamonds")
# Creating box plot of diamond prices by cut
ggplot(diamonds, aes(x = cut, y = price)) +
  geom_boxplot() +
  labs(x = "Cut", y = "Price", title = "Diamond Prices by Cut") +
  theme_classic()+
  theme(plot.title = element_text(size = 16)) # Set title font size to 16


##part3 

# Reading Excel file
df<- read.csv("tree_2.csv")

# Count number of each value in column quality
A_count <- df %>% 
  filter(quality == "A") %>% 
  nrow()

B_count <- df %>% 
  filter(quality == "B") %>% 
  nrow()

C_count <- df %>% 
  filter(quality == "C") %>% 
  nrow()

D_count <- df %>% 
  filter(quality == "D") %>% 
  nrow()
E_count <- df %>% 
  filter(quality == "E") %>% 
  nrow()
#figure size
par(mar = c(5, 5, 5, 5)) 
# Setting the window size
windows(width = 8, height = 8) 

# Create pie chart of counts
pie(c(A_count, B_count, C_count, D_count, nrow(df)-(A_count+B_count+C_count+D_count+E_count)), 
    labels = c("A", "B", "C","Other"), 
    main = "Distribution of TREES")

#part5

plot_usmap(include = c("CT", "ME", "MA", "NH", "VT")) +
  labs(title = "New England Region") +
  theme(panel.background = element_rect(color = "blue"))
plot_usmap(data = countypov, values = "pct_pov_2014", include = c("CT", "ME", "MA", "NH", "VT"), color = "blue") + 
  scale_fill_continuous(low = "white", high = "blue", name = "Poverty Percentage Estimates", label = scales::comma) + 
  labs(title = "New England Region", subtitle = "Poverty Percentage Estimates for New England Counties in 2014") +
  theme(legend.position = "right")


