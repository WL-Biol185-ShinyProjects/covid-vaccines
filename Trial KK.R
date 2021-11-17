time_series_covid19_vaccine_global <- read_csv("https://raw.githubusercontent.com/govex/COVID-19/master/data_tables/vaccine_data/global_data/time_series_covid19_vaccine_global.csv")
hopkins <- time_series_covid19_vaccine_global

hopkins <- hopkins %>%
  filter(Date == "2021-10-25") %>%
  filter(!is.na(People_fully_vaccinated)) %>%
  filter(Country_Region != "US (Aggregate)") %>%
  filter(Country_Region != "World")


GDP_per_capita <- read.csv("~/covid-vaccines/CSVs/GDP_per_capita.csv")

hopkins_GDP <- left_join(hopkins, GDP_per_capita, by = c("Country_Region" = "Country"))

hopkins_GDP <- hopkins_GDP %>%
  mutate(GDP.nominal.per.capita = gsub("$", "", GDP.nominal.per.capita, fixed = TRUE)) %>%
  mutate(GDP.nominal.per.capita = gsub(",", "", GDP.nominal.per.capita, fixed = TRUE)) %>%
  mutate(GDP.nominal.per.capita = as.numeric(GDP.nominal.per.capita)) %>%
  arrange(desc(GDP.nominal.per.capita)) %>%
  mutate(Share.of.World.GDP = gsub("%", "", Share.of.World.GDP, fixed = TRUE)) %>%
  mutate(Share.of.World.GDP = as.numeric(Share.of.World.GDP)) %>%
  mutate(logShareofWorldGDP = log(Share.of.World.GDP))

hopkins_GDP$Category <- seq.int(nrow(hopkins_GDP))


ggplot(hopkins_GDP, aes(People_fully_vaccinated, GDP.nominal.per.capita)) +
  geom_point()
         

  

