vaccines <- read.csv("country_vaccinations_by_manufacturer.csv")

variants <- read.csv("covid-variants.csv")

#https://raw.githubusercontent.com/govex/COVID-19/master/data_tables/vaccine_data/global_data/time_series_covid19_vaccine_global.csv
hopkins <- time_series_covid19_vaccine_global


updated <- read.csv("Worldwide Vaccine Data (1).csv")

latlon <- country_capitals <- read_csv("CSVs/country-capitals.csv")

library(lubridate)
variants_date <- variants %>%
  mutate(year = year(as_date(date))) %>%
  mutate(month = month(as_date(date))) %>%
  mutate(day = day(as_date(date)))


variants_popular <- variants_date %>%
#  filter(location == "United States") %>%
  group_by(variant, year, month) %>%
  summarise(
    n = sum(num_sequences, na.rm = TRUE)
  ) %>%
  filter(n > 10000) %>%
  mutate(month = as.factor(month))

ggplot(variants_popular, aes(variant, n, fill = month)) +
  geom_bar(stat = "identity") +
  facet_wrap(~year) +
  coord_flip() +
  theme_classic()


ggplot(variants_popular, aes(month, n, fill = variant)) +
  geom_bar(stat = "identity") +
  facet_wrap(~year) +
  coord_flip() +
  theme_classic()
#adding a line
#and another

#USE THIS ONE
latlon_joined <- hopkins %>%
  left_join(country_capitals, by = c("Country_Region" = "CountryName")) %>%
  filter(Date == "2021-10-10") %>%
  filter(People_partially_vaccinated != "NA")
  
saveRDS(latlon_joined, file = "LatLon_Countries.RDS")
  