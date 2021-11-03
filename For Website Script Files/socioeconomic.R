time_series_covid19_vaccine_global <- read_csv("https://raw.githubusercontent.com/govex/COVID-19/master/data_tables/vaccine_data/global_data/time_series_covid19_vaccine_global.csv")
hopkins <- time_series_covid19_vaccine_global

hopkins <- hopkins %>%
  filter(Date == "2021-10-25") %>%
  filter(!is.na(People_fully_vaccinated)) %>%
  filter(Country_Region != "US (Aggregate)") %>%
  filter(Country_Region != "World")
  

GDP_per_capita <- read.csv("~/covid-vaccines/CSVs/GDP_per_capita.csv")

hopkins_GDP <- left_join(hopkins, GDP_per_capita, by = c("Country_Region" = "Country"))

view(hopkins_GDP)