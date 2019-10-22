# Load packages

library(tidyverse)
library(rvest)
library(readxl)

# Import European/Portugal drug & pop data

euro_drugs <- read_xlsx("DRD-33.xlsx", skip = 3, n_max = 30)

port_pop <- read_xlsx("TotalPopSex-20191022022956.xlsx", sheet = "Data")

# Import US drug & pop data

us <- read.delim("Underlying Cause of Death, 1999-2017.txt")

## Clean Portugal data

# Clean portugal drug data

filter(euro_drugs, Country == "Portugal *") %>%
  gather(., key = "Year", value = "Deaths") %>%
  .[-1, ] %>%
  add_column(., Country = c("Portugal"), .before = "Year") -> Portugal

Portugal$Year <- as.numeric(Portugal$Year)
Portugal$Deaths <- as.numeric(Portugal$Deaths)

# Clean portugal pop data

port_pop[c(1, 7), c(4:dim(port_pop)[2])] %>%
  t() %>%
  as.tibble() -> port_pop_clean

colnames(port_pop_clean) <- c("Year", "Population")
port_pop_clean$Population <- port_pop_clean$Population/1000

# Combine drug & pop data

Portugal <- full_join(Portugal, port_pop_clean, by = "Year")

## Clean US data

US <- us[c(1:19), c(2, 4, 5)]

US <- add_column(US, Country = c("United States"), .before = "Year")
US$Population <- US$Population/(10^6)

## Combine US & Portugal data

Full_drug_data <- rbind(US, Portugal)

# Calculate mortality rate per million

Full_drug_data <- mutate(Full_drug_data, Mortality_rate = Deaths/Population)

### Visualizations

filter(Full_drug_data, Country == "Portugal") %>%
  ggplot(data = ., aes(x = Year, y = Mortality_rate)) + geom_point()

filter(Full_drug_data, Country == "United States") %>%
  ggplot(data = ., aes(x = Year, y = Mortality_rate)) + geom_point()
