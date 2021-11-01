time_series_covid19_vaccine_global <- read_csv("https://raw.githubusercontent.com/govex/COVID-19/master/data_tables/vaccine_data/global_data/time_series_covid19_vaccine_global.csv")
hopkins <- time_series_covid19_vaccine_global

#left join hopkins with world cities in order to get population to do fully vaccinated per capita
country_pop <- read.csv("population_by_country_2020.csv") %>%
  mutate(Country..or.dependency. = as.character(Country..or.dependency.)) %>%
  mutate(pop = Population..2020.)
  
country_pop$Country..or.dependency.[3] <- "US"

hopkins1 <- hopkins %>%
  filter(Date == "2021-10-25") %>%
  filter(!is.na(People_partially_vaccinated)) %>%
  filter(Country_Region != "US (Aggregate)") %>%
  filter(Country_Region != "World")

hopkins_fully <- hopkins1 %>%
  arrange(desc(People_fully_vaccinated)) %>%
  slice(1:10)

pop_hopkins_fully <- left_join(hopkins_fully, country_pop, by = c("Country_Region" = "Country..or.dependency.")) %>%
  mutate(fully_per_capita = People_fully_vaccinated / pop) %>%
  mutate(World.Share = gsub("%", "", World.Share, fixed = TRUE)) %>%
  mutate(World.Share = as.numeric(World.Share))

ggplot(pop_hopkins_fully, aes(reorder(Country_Region, fully_per_capita), 
                              fully_per_capita, fill = World.Share)) + 
  geom_bar(stat = "identity") +
  theme_classic() +
  labs(title = "Fully Vaccinated Rates Per Capita (Countries with Highest Number of Vaccines Distribued)", 
       subtitle = "Colored by % of World Population for Each Country", 
       y = "Fully Vaccinated Individuals per Capita",
       x = "Country")
       
       
       
       
       
       
       

