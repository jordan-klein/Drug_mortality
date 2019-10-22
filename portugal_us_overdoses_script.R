# Load packages

library(tidyverse)
library(rvest)
library(readxl)

# Import European drug & pop data

euro_drugs <- read_xlsx("DRD-33.xlsx", skip = 3, n_max = 30)

euro_pop <- read.csv("DP_LIVE_22102019193722522.csv")

# Import US drug & pop data

us <- read.delim("Underlying Cause of Death, 1999-2017.txt")

## Calculate Portugal mortality rate

# Clean portugal drug data

filter(euro_drugs, Country == "Portugal *") %>%
  gather(., key = "Year", value = "Deaths") %>%
  .[-1, ] %>%
  add_column(., Country = c("Portugal"), .before = "Year") -> Portugal

Portugal$Year <- as.numeric(Portugal$Year)
Portugal$Deaths <- as.numeric(Portugal$Deaths)

# Clean portugal pop data




