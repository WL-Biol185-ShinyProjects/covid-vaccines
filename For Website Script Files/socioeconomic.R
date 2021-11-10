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
  mutate(GDP.nominal.per.capita = as.numeric(GDP.nominal.per.capita)) %>%
  mutate(Population..2017 = gsub(","), "", Population..2017, fixed = TRUE) %>% 
  mutate(Population..2017 = as.numeric(Population..2017))

hopkins_GDP$partial_fully <- hopkins_GDP$People_partially_vaccinated +
  hopkins_GDP$People_fully_vaccinated

hopkins_GDP <- hopkins_GDP %>%
  filter(Date == "2021-10-25") %>%
  filter(!is.na(People_fully_vaccinated))

library(ggplot2)
library(tidyr)
library(tibble)
library(hrbrthemes)
library(dipylr)




country_pop <- read.csv("population_by_country_2020.csv") %>%
  mutate(Country..or.dependency. = as.character(Country..or.dependency.)) %>%
  mutate(pop = Population..2020.)

country_pop$Country..or.dependency.[3] <- "US"

pop_hopkins_fully <- left_join(hopkins_GDP, country_pop, by = c("Country_Region" = "Country..or.dependency.")) %>%
  mutate(fully_per_capita = People_fully_vaccinated / Population..2020.) %>%
  mutate(World.Share = gsub("%", "", World.Share, fixed = TRUE)) %>%
  mutate(World.Share = as.numeric(World.Share))

#pop_hopkins_fully$GDP.nominal.per.capita <- as.numeric(pop_hopkins_fully$GDP.nominal.per.capita)            
#pop_hopkins_fully$partial_fully <- as.numeric(pop_hopkins_fully$partial_fully)
#pop_hopkins_fully$Country_Region <- as.factor(pop_hopkins_fully$Country_Region)
#pop_hopkins_fully$People_fully_vaccinated <- as.factor(pop_hopkins_fully$People_fully_vaccinated)
pop_hopkins_fully <- pop_hopkins_fully %>%
    filter(GDP.nominal.per.capita >= 54000 | GDP.nominal.per.capita <= 850) %>%
    filter(!(Country_Region=="US"))
pop_hopkins_fully$fully_per_capita <- as.factor(pop_hopkins_fully$fully_per_capita)
options(digits = 5)
ggplot(data = pop_hopkins_fully, aes(fully_per_capita, Country_Region, fill = GDP.nominal.per.capita)) +
  geom_tile()+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))
  





hopkins_GDP$vaccination_per_capita <- hopkins_GDP$People_fully_vaccinated / hopkins_GDP$Population..2017



