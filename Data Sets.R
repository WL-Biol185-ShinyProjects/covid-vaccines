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
  filter(location == "United States") %>%
  group_by(variant, year, month) %>%
  summarise(
    n = sum(num_sequences, na.rm = TRUE)
  ) %>%
  filter(n > 10000) %>%
  mutate(month = as.factor(month)) %>%
  mutate(month_write = ifelse(month == 1, "Jan",
                               ifelse(month == 2, "Feb",
                                      ifelse(month == 3, "Mar",
                                             ifelse(month == 4, "Apr",
                                                    ifelse(month == 5, "May",
                                                           ifelse(month == 6, "Jun",
                                                                  ifelse(month == 7, "Jul",
                                                                         ifelse(month == 8, "Aug",
                                                                                ifelse(month == 9, "Sep",
                                                                                       ifelse(month == 10, "Oct",
                                                                                              ifelse(month == 11, "Nov",
                                                                                                     ifelse(month == 12, "Dec", NA))))))))))))) %>%
  mutate(month_write = factor(month_write, levels = c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")))

ggplot(variants_popular, aes(variant, n, fill = month_write)) +
  geom_bar(stat = "identity") +
  facet_wrap(~year) +
  coord_flip() +
  theme_classic()


ggplot(variants_popular, aes(month_write, n, fill = variant)) +
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


latlon_joined[149, "CapitalLatitude"] <- "38.9072"
latlon_joined[149, "CapitalLongitude"] <-"77.0369"
latlon_joined[149, "CapitalName"] <- "Washington DC"
latlon_joined[149, "CapitalCode"] <- "USA"
library(leaflet)

latlon_trial <- latlon_joined %>%
  mutate(lat = as.numeric(CapitalLatitude)) %>%
  mutate(lon = as.numeric(CapitalLongitude)) %>%
  mutate(fully_vac = as.factor(People_fully_vaccinated))

leaflet(data = latlon_trial) %>% 
  addTiles() %>% 
  addMarkers(popup = ~fully_vac)

#no lat and lon for DC in the USA, there are other countries missing too but less important 
  