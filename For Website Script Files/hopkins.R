time_series_covid19_vaccine_global <- read_csv("https://raw.githubusercontent.com/govex/COVID-19/master/data_tables/vaccine_data/global_data/time_series_covid19_vaccine_global.csv")
hopkins <- time_series_covid19_vaccine_global

#left join hopkins with world cities in order to get population to do fully vaccinated per capita



hopkins1 <- hopkins %>%
  filter(Date == "2021-10-25") %>%
  filter(!is.na(People_partially_vaccinated)) %>%
  filter(Country_Region != "US (Aggregate)") %>%
  filter(Country_Region != "World")

hopkins_fully <- hopkins1 %>%
  arrange(desc(People_fully_vaccinated)) %>%
  slice(1:10)

ggplot(hopkins_fully, aes(reorder(Country_Region, People_fully_vaccinated), People_fully_vaccinated)) + 
  geom_bar(stat = "identity")

