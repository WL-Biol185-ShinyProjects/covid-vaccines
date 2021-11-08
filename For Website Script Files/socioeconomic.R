library(tidyverse)

time_series_covid19_vaccine_global <- read_csv("https://raw.githubusercontent.com/govex/COVID-19/master/data_tables/vaccine_data/global_data/time_series_covid19_vaccine_global.csv")
hopkins <- time_series_covid19_vaccine_global

hopkins <- hopkins %>%
  filter(Date == "2021-10-25") %>%
  filter(!is.na(People_fully_vaccinated)) %>%
  filter(Country_Region != "US (Aggregate)") %>%
  filter(Country_Region != "World")
  

GDP_per_capita <- read.csv("~/covid-vaccines/CSVs/GDP_per_capita.csv")



hopkins_GDP <- left_join(hopkins, GDP_per_capita, by = c("Country_Region" = "Country")) %>%
  mutate(GDP.nominal.per.capita = gsub("$", "", GDP.nominal.per.capita, fixed = TRUE)) %>%
  mutate(GDP.nominal.per.capita = gsub(",", "", GDP.nominal.per.capita, fixed = TRUE)) %>% 
  mutate(GDP.nominal.per.capita = as.numeric(GDP.nominal.per.capita))

hopkins_GDP$partial_fully <- hopkins_GDP$People_partially_vaccinated +
  hopkins_GDP$People_fully_vaccinated

library(ggplot2)
library(tidyr)
library(tibble)
library(hrbrthemes)
library(dipylr)


hopkins_GDP$GDP.nominal.per.capita <- as.numeric(hopkins_GDP$GDP.nominal.per.capita)            
hopkins_GDP$partial_fully <- as.numeric(hopkins_GDP$partial_fully)
hopkins_GDP$Country_Region <- as.factor(hopkins_GDP$Country_Region)
hopkins_GDP$People_fully_vaccinated <- as.factor(hopkins_GDP$People_fully_vaccinated)
hopkins_highlow <- hopkins_GDP %>%
  filter(GDP.nominal.per.capita >= 54000 | GDP.nominal.per.capita <= 850) %>%
  filter(!(Country_Region=="US"))
  

ggplot(data = hopkins_highlow, aes(People_fully_vaccinated, Country_Region, fill = GDP.nominal.per.capita)) +
  geom_tile()
  








